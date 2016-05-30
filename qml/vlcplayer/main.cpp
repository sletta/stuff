#include "vlcitem.h"

int main(int argc, char **argv)
{
	qmlRegisterType<VLCItem>("MyVLC", 0, 1, "VLCItem");

	QGuiApplication app(argc, argv);

	QQuickView view;
	view.setSource(QUrl::fromLocalFile("main.qml"));
	view.show();

	return app.exec();
}