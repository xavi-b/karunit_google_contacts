#ifndef GOOGLECONTACTSPLUGINCONNECTOR_H
#define GOOGLECONTACTSPLUGINCONNECTOR_H

#include <QQmlContext>
#include <QZXing.h>
#include "qgooglewrapper.h"
#include "plugininterface.h"
#include "settings.h"

class KU_GoogleContacts_PluginConnector : public KU::PLUGIN::PluginConnector
{
    Q_OBJECT

    Q_PROPERTY(QString refreshToken MEMBER refreshToken CONSTANT)

public:
    KU_GoogleContacts_PluginConnector(QObject* parent = nullptr);
    Q_INVOKABLE void setEngine(QObject* obj);
    void             setup();
    Q_INVOKABLE void askDeviceCode();
    Q_INVOKABLE void call(QString number);

signals:
    void authenticated();
    void pendingVerification(QString const& verificationUrl, QString const& userCode);
    void contactsRequest(QString const& bytes);

private:
    QString         refreshToken;
    QGoogleWrapper* wrapper = nullptr;
};

#endif // GOOGLECONTACTSPLUGINCONNECTOR_H
