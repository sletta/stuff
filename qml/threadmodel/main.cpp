#include <QtCore>
#include <QtGui>
#include <QtQuick>

#include "model.h"

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    Model model(100);

    QQuickView view;
    view.rootContext()->setContextProperty("tableModel", &model);
    view.rootContext()->setContextProperty("viewComponent", "LoaderRepeaterListView.qml");
    view.setSource(QUrl::fromLocalFile("main.qml"));
    view.show();

    model.startProducing();

    return app.exec();
}
