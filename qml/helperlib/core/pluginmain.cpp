#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>

#include "filecontenttracker.h"

class PluginMain : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri)
    {
        qmlRegisterType<FileContentTracker>(uri, 1, 0, "FileContentTracker");
    }
};

#include "pluginmain.moc"

