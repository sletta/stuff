#include <QtCore>
#include <QtGui>
#include <QtQml>
#include <QtQuick>

#include "model.h"
#include "tablerow.h"

int main(int argc, char **argv)
{
    qmlRegisterType<TableRow>("Tables", 0, 1, "TableRow");

    QGuiApplication app(argc, argv);

    QString component = QStringLiteral("LoaderRepeaterListView.qml");

    if (argc > 1) {
        component = QString::fromLocal8Bit(argv[1]);
    }
    qDebug("Using component: '%s'", qPrintable(component));

    Model model;

    QQuickView view;

    if (!TableRow::initialize(view.engine())) {
        return 0;
    }

    view.rootContext()->setContextProperty("tableModel", &model);
    view.rootContext()->setContextProperty("viewComponent", component);
    view.setSource(QUrl::fromLocalFile("main.qml"));
    view.show();

    return app.exec();
}