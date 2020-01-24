#include "googlecontactswidget.h"

GoogleContactsWidget::GoogleContactsWidget(QQmlEngine* engine, QWidget *parent)
    : QQuickWidget(engine, parent)
{
    this->setResizeMode(QQuickWidget::SizeRootObjectToView);
}

void GoogleContactsWidget::setup()
{
    this->wrapper = new QGoogleWrapper(":/res/code_secret_client.json", this);
    connect(this->wrapper, &QGoogleWrapper::log, this, &GoogleContactsWidget::log);

    connect(this, &QQuickWidget::statusChanged, this, [=](QQuickWidget::Status status)
    {
        if(status == QQuickWidget::Error)
        {
            for(auto& e : this->errors())
            {
                emit log("QML ERROR: " + e.toString());
            }
        }
    });
    this->setSource(QUrl("qrc:/qml/GoogleContacts.qml"));

    this->wrapper->askDeviceCode("https://www.google.com/m8/feeds");

    connect(this->wrapper, &QGoogleWrapper::pendingVerification, this, [=](QString const& verificationUrl, QString const& userCode)
    {
        QMetaObject::invokeMethod(this->rootObject(), "pendingVerification", Q_ARG(QString, verificationUrl), Q_ARG(QString, userCode));
    });

    connect(this->wrapper, &QGoogleWrapper::authenticated, this, [=]()
    {
        QMetaObject::invokeMethod(this->rootObject(), "authenticated");

        QNetworkRequest request;
        request.setUrl(QUrl("https://www.google.com/m8/feeds/contacts/default/full?max-results=1000"));
        request.setRawHeader("GData-Version", "3.0");
        auto reply = this->wrapper->apiCall(request);
        connect(reply, &QNetworkReply::finished, this, [=]()
        {
            QByteArray bytes = reply->readAll();
            //emit log("contactsRequest " + bytes);
            QMetaObject::invokeMethod(this->rootObject(), "contactsRequest", Q_ARG(QString, QString(bytes)));
            reply->deleteLater();
        });
        connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error), this, [=](QNetworkReply::NetworkError error)
        {
            emit log("contactsRequest " + reply->errorString());
        });
    });
}
