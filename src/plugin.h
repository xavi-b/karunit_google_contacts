#ifndef GOOGLECONTACTSPLUGIN_H
#define GOOGLECONTACTSPLUGIN_H

#include <QtPlugin>
#include <QIcon>
#include <QDebug>
#include <QDateTime>
#include <QFontDatabase>
#include <QZXing.h>
#include "plugininterface.h"
#include "settings.h"
#include "googlecontactspluginconnector.h"

class KU_GoogleContacts_Plugin : public QObject, public KU::PLUGIN::PluginInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "xavi-b.karunit.PluginInterface")
    Q_INTERFACES(KU::PLUGIN::PluginInterface)

public:
    virtual QString                   name() const override;
    virtual QString                   id() const override;
    virtual KU::PLUGIN::PluginVersion version() const override;
    virtual QString                   license() const override;
    virtual QString                   icon() const override;
    virtual bool                      initialize() override;
    virtual bool                      stop() override;

    virtual bool loadSettings() override;
    virtual bool saveSettings() const override;

    virtual KU_GoogleContacts_PluginConnector* getPluginConnector() override;
};

#endif // GOOGLECONTACTSPLUGIN_H
