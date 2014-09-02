TARGETPATH=org/sletta/ui/

QML_FILES = \
    CheckersBackground.qml \
    GradientSpinner.qml \
    PulseSpinner.qml \

load(qml_module)

GLSL_FILES = \
        gradientspinner.fsh \
        pulsespinner.fsh

glsl.path = $$[QT_INSTALL_QML]/$$TARGETPATH
glsl.files = $$GLSL_FILES

INSTALLS += glsl



