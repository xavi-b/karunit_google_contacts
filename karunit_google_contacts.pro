TEMPLATE        = lib
CONFIG         += plugin c++17
DEFINES        += QT_DEPRECATED_WARNINGS
QT             += widgets qml quick quickwidgets xml
TARGET          = karunit_google_contacts_plugin
DESTDIR         = $$PWD/../karunit/app/plugins

DEFINES += ENABLE_ENCODER_GENERIC
CONFIG += qzxing_qml
include($$PWD/third-party/qzxing/src/QZXing.pri)

libQGoogleWrapper.target = $$PWD/third-party/QGoogleWrapper/libQGoogleWrapper.so
libQGoogleWrapper.commands += cd $$PWD/third-party/QGoogleWrapper && qmake && make
QMAKE_EXTRA_TARGETS += libQGoogleWrapper
PRE_TARGETDEPS += $$libQGoogleWrapper.target

LIBS += -L$$PWD/third-party/QGoogleWrapper/lib -lQGoogleWrapper
INCLUDEPATH += $$PWD/third-party/QGoogleWrapper/include

LIBS += -L$$PWD/../karunit/plugininterface/ -lkarunit_plugininterface
INCLUDEPATH += $$PWD/../karunit/plugininterface

LIBS += -L$$PWD/../karunit/common/ -lkarunit_common
INCLUDEPATH += $$PWD/../karunit/common

LIBS += -L$$PWD/../karunit/third-party/xblog/lib -lxblog
INCLUDEPATH += $$PWD/../karunit/third-party/xblog/include

SUBDIRS += \
    src/ \
    qm/

include(src/src.pri)
include(qml/qml.pri)

RESOURCES += \
    karunit_google_contacts.qrc
