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

QString KU_GoogleContacts_Plugin::license() const
{
    return "LGPL";
}

QIcon KU_GoogleContacts_Plugin::icon() const
{
    return QIcon();
}

bool KU_GoogleContacts_Plugin::initialize()
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

    this->widget = new GoogleContactsWidget(&this->engine);
    connect(this->widget, &GoogleContactsWidget::log, this->getPluginConnector(), &KU::PLUGIN::PluginConnector::log);
    this->widget->setup(KU::Settings::instance()->value(this->id(), "refresh_token", QString()).toString());
    return this->widget;
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
    if(!this->widget->getWrapper()->getRefreshToken().isEmpty())
        KU::Settings::instance()->setValue(this->id(), "refresh_token", this->widget->getWrapper()->getRefreshToken());
    KU::Settings::instance()->sync();
    return KU::Settings::instance()->status() == QSettings::NoError;
}
