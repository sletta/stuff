QT += quick quick-private core-private gui-private qml-private

TEMPLATE = lib

HEADERS += \
    blurredimage.h

SOURCES += \
    blurredimage.cpp \
    pluginmain.cpp

TARGET = blurredimage

CONFIG += plugin qt

TARGETPATH = Qt/labs/blurredimage
OTHER_FILES = qmldir \
    test.qml \
    blurredimage.vsh \
    blurredimage.fsh

target.path = $$[QT_INSTALL_QML]/$$TARGETPATH
qmldir.files = qmldir
qmldir.path = $$[QT_INSTALL_QML]/$$TARGETPATH
INSTALLS = target qmldir
[

RESOURCES += \
    blurredimage.qrc
