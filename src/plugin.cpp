#include "plugin.h"

QString KU_GoogleContacts_Plugin::name() const
{
    return "Google Contacts";
}

QString KU_GoogleContacts_Plugin::id() const
{
    return "google.contacts";
}

KU::PLUGIN::PluginVersion KU_GoogleContacts_Plugin::version() const
{
    return { 1, 0, 0 };
}

QSet<KU::PLUGIN::PluginInfo> KU_GoogleContacts_Plugin::dependencies() const
{
    return QSet<KU::PLUGIN::PluginInfo>();
}

QString KU_GoogleContacts_Plugin::license() const
{
    return "LGPL";
}

QIcon KU_GoogleContacts_Plugin::icon() const
{
    return QIcon();
}

bool KU_GoogleContacts_Plugin::initialize(const QSet<KU::PLUGIN::PluginInterface*>& plugins)
{
    return true;
}

bool KU_GoogleContacts_Plugin::stop()
{
    return true;
}

QWidget* KU_GoogleContacts_Plugin::createWidget()
{
    QZXing::registerQMLTypes();
    QZXing::registerQMLImageProvider(this->engine);

    auto widget = new GoogleContactsWidget(&this->engine);
    connect(widget, &GoogleContactsWidget::log, this->getPluginConnector(), &KU::PLUGIN::PluginConnector::log);
    widget->setup();
    return widget;
}

QWidget* KU_GoogleContacts_Plugin::createSettingsWidget()
{
    return nullptr;
}

bool KU_GoogleContacts_Plugin::loadSettings()
{
    return true;
}

bool KU_GoogleContacts_Plugin::saveSettings() const
{
    return KU::Settings::instance()->status() == QSettings::NoError;
}
