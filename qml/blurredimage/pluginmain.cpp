#include <QQmlExtensionPlugin>

#include "blurredimage.h"

class BlurredImagePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri)
    {
        qmlRegisterType<BlurredImage>(uri, 1, 0, "BlurredImage");
    }
};

#include "pluginmain.moc"

