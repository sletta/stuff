#include <QtCore>
#include <QtQml>

#define INLINE_CODE(x) #x

const char *SOURCE = INLINE_CODE(
import QtQuick 2.4;

Item {
    property real foo: 1;
    property real bar: foo;

    onFooChanged: print('onFooChanged', foo);
    onBarChanged: print('onBarChanged', bar);
}
);

int main(int argc, char **argv)
{
    QCoreApplication app(argc, argv);

    QQmlEngine engine;
    QQmlComponent component(&engine);
    component.setData(SOURCE, QUrl::fromLocalFile("nada.qml"));
    qDebug() << component.errors();

    QObject *item = component.create();
    Q_ASSERT(item);

    qDebug("QML file is:\n%s\n", SOURCE);

    qDebug("1: setting 'foo'");
    item->setProperty("foo", 2);

    qDebug("2: setting 'bar'");
    item->setProperty("bar", 3);

    qDebug("3: setting 'foo' again");
    item->setProperty("foo", 4);

    qDebug("4: setting 'bar' with QQmlProperty");
    QQmlProperty::write(item, QStringLiteral("bar"), 5);

    qDebug("5: setting 'foo' after write with QQmlProperty");
    item->setProperty("foo", 6);
    return 0;
}