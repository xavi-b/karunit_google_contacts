TEMPLATE        = lib
CONFIG         += plugin c++17
DEFINES        += QT_DEPRECATED_WARNINGS
QT             += qml quick xml
TARGET          = karunit_google_contacts_plugin
DESTDIR         = $$PWD/../karunit/app/plugins

unix {
target.path = /usr/local/bin/plugins
INSTALLS += target
}

qzxing.target = $$PWD/third-party/qzxing/src/libQZXing.so
qzxing.commands += cd $$PWD/third-party/qzxing/src && qmake "CONFIG+=qzxing_qml" "DEFINES+=ENABLE_ENCODER_GENERIC" && make -j4
QMAKE_EXTRA_TARGETS += qzxing
PRE_TARGETDEPS += $$qzxing.target

qzxing.files = $$PWD/third-party/qzxing/src/libQZXing.so*
qzxing.path = /usr/lib
INSTALLS += qzxing

libQGoogleWrapper.target = $$PWD/third-party/QGoogleWrapper/lib/libQGoogleWrapper.so
libQGoogleWrapper.commands += cd $$PWD/third-party/QGoogleWrapper && qmake && make -j4
QMAKE_EXTRA_TARGETS += libQGoogleWrapper
PRE_TARGETDEPS += $$libQGoogleWrapper.target

libQGoogleWrapper.files = $$PWD/third-party/QGoogleWrapper/lib/libQGoogleWrapper.so*
libQGoogleWrapper.path = /usr/lib
INSTALLS += libQGoogleWrapper

DEFINES += QZXING_QML
DEFINES += ENABLE_ENCODER_GENERIC
LIBS += -L$$PWD/third-party/qzxing/src -lQZXing
INCLUDEPATH += $$PWD/third-party/qzxing/src

LIBS += -L$$PWD/third-party/QGoogleWrapper/lib -lQGoogleWrapper
INCLUDEPATH += $$PWD/third-party/QGoogleWrapper/include

LIBS += -L$$PWD/../karunit/plugininterface/ -lkarunit_plugininterface
INCLUDEPATH += $$PWD/../karunit/plugininterface

LIBS += -L$$PWD/../karunit/common/ -lkarunit_common
INCLUDEPATH += $$PWD/../karunit/common

LIBS += -L$$PWD/../karunit/third-party/xblog/lib -lxblog
INCLUDEPATH += $$PWD/../karunit/third-party/xblog/include

SUBDIRS += \
    src/

include(src/src.pri)

RESOURCES += \
    karunit_google_contacts.qrc
