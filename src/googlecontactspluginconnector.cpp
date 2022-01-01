#include "googlecontactspluginconnector.h"
#include <QtQml>

KU_GoogleContacts_PluginConnector::KU_GoogleContacts_PluginConnector(QObject* parent)
    : KU::PLUGIN::PluginConnector(parent)
{
    this->wrapper = new QGoogleWrapper(":/karunit_google_contacts/res/code_secret_client.json", this);
}

void KU_GoogleContacts_PluginConnector::setEngine(QObject* obj)
{
    QZXing::registerQMLImageProvider(*qmlEngine(obj));
}

void KU_GoogleContacts_PluginConnector::setup()
{
    this->refreshToken = KU::Settings::instance()->get("karunit_google_contacts/refresh_token", QString()).toString();
    emitLogSignal(QString("loaded refresh_token ") + this->refreshToken);

    connect(this->wrapper, &QGoogleWrapper::log, this, &KU_GoogleContacts_PluginConnector::log);

    if (!refreshToken.isEmpty())
    {
        this->wrapper->setRefreshToken(refreshToken);
        this->wrapper->askAccessToken();
    }

    connect(this->wrapper,
            &QGoogleWrapper::pendingVerification,
            this,
            &KU_GoogleContacts_PluginConnector::pendingVerification);

    connect(this->wrapper, &QGoogleWrapper::authenticated, this, [=]() {
        emit authenticated();

        this->refreshToken = this->wrapper->getRefreshToken();
        if (!this->refreshToken.isEmpty() && this->refreshToken != "true")
        {
            KU::Settings::instance()->save("karunit_google_contacts/refresh_token", this->refreshToken);
            emitLogSignal(QString("saved refresh_token " + this->refreshToken));
        }

        QNetworkRequest request;
        request.setUrl(QUrl("https://www.google.com/m8/feeds/contacts/default/full?max-results=1000"));
        request.setRawHeader("GData-Version", "3.0");

        auto reply = this->wrapper->apiCall(request);

        connect(reply, &QNetworkReply::finished, this, [=]() {
            QByteArray bytes = reply->readAll();

            emit contactsRequest(QString(bytes));

            reply->deleteLater();
        });

        connect(reply,
                QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error),
                this,
                [=](QNetworkReply::NetworkError error) {
                    emitLogSignal("contactsRequest " + reply->errorString());
                });
    });

    connect(this->wrapper, &QGoogleWrapper::pollingTimedOut, this, &KU_GoogleContacts_PluginConnector::authenticated);
    connect(this->wrapper, &QGoogleWrapper::deviceCodeRequestError, this, [=](QString const& error) {
        emitLogSignal("deviceCodeRequestError " + error);
    });
    connect(this->wrapper, &QGoogleWrapper::pollingRequestError, this, [=](QString const& error) {
        emitLogSignal("deviceCodeRequestError " + error);
    });
    connect(this->wrapper, &QGoogleWrapper::accessTokenRequestError, this, [=](QString const& error) {
        emitLogSignal("deviceCodeRequestError " + error);
    });
}

void KU_GoogleContacts_PluginConnector::askDeviceCode()
{
    this->wrapper->askDeviceCode("https://www.google.com/m8/feeds");
}

void KU_GoogleContacts_PluginConnector::call(QString number)
{
    QVariantMap data;
    data["number"] = number;
    this->emitPluginChoiceSignal("dial", data);
}
