TARGET = slettacore
TARGETPATH = org/sletta/core
TEMPLATE = lib

CONFIG += plugin


QT = core gui quick

SOURCES += \
    filecontenttracker.cpp \
    pluginmain.cpp

HEADERS += \
    filecontenttracker.h

#QML_FILES += \


load(qml_module)


target.path = $$[QT_INSTALL_QML]/$$TARGETPATH

INSTALLS += target
