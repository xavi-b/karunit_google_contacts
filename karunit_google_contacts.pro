TEMPLATE        = lib
CONFIG         += plugin c++17
DEFINES        += QT_DEPRECATED_WARNINGS
QT             += widgets qml quick quickwidgets xml
TARGET          = karunit_google_contacts_plugin
DESTDIR         = $$PWD/../karunit/app/plugins

DEFINES += ENABLE_ENCODER_GENERIC
CONFIG += qzxing_qml
include($$PWD/third-party/qzxing/src/QZXing.pri)

LIBS += -L$$PWD/third-party/QGoogleWrapper/
LIBS += -lQGoogleWrapper
INCLUDEPATH += $$PWD/third-party/QGoogleWrapper/src/
DEPENDPATH += $$PWD/third-party/QGoogleWrapper/src/

LIBS += -L$$PWD/../karunit/lib/
LIBS += -L$$PWD/../karunit/app/plugins/

LIBS += -lplugininterface
INCLUDEPATH += $$PWD/../karunit/plugininterface
DEPENDPATH += $$PWD/../karunit/plugininterface

LIBS += -lcommon
INCLUDEPATH += $$PWD/../karunit/common
DEPENDPATH += $$PWD/../karunit/common

SUBDIRS += \
    src/ \
    qm/

include(src/src.pri)
include(qml/qml.pri)

RESOURCES += \
    karunit_google_contacts.qrc
