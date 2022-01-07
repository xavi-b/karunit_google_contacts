#include "plugin.h"
#include <QQmlEngine>

QString KU_GoogleContacts_Plugin::name() const
{
    return "Google Contacts";
}

QString KU_GoogleContacts_Plugin::id() const
{
    return "karunit_google_contacts";
}

KU::PLUGIN::PluginVersion KU_GoogleContacts_Plugin::version() const
{
    return {1, 0, 0};
}

QString KU_GoogleContacts_Plugin::license() const
{
    return "LGPL";
}

QString KU_GoogleContacts_Plugin::icon() const
{
    return QString();
}

bool KU_GoogleContacts_Plugin::initialize()
{
    QZXing::registerQMLTypes();

    this->getPluginConnector()->setup();

    qmlRegisterSingletonInstance("KarunitPlugins", 1, 0, "KUPGoogleContactsPluginConnector", this->pluginConnector);

    return true;
}

bool KU_GoogleContacts_Plugin::stop()
{
    return true;
}

bool KU_GoogleContacts_Plugin::loadSettings()
{
    return true;
}

bool KU_GoogleContacts_Plugin::saveSettings()
{
    return KU::Settings::instance()->status() == QSettings::NoError;
}

KU_GoogleContacts_PluginConnector* KU_GoogleContacts_Plugin::getPluginConnector()
{
    if (this->pluginConnector == nullptr)
        this->pluginConnector = new KU_GoogleContacts_PluginConnector;
    return qobject_cast<KU_GoogleContacts_PluginConnector*>(this->pluginConnector);
}
