/*
1000000 iterations:
 - Old School connect:
   - no arguments .........: 1.35508 seconds
   - int argument .........: 2.3232 seconds
   - two string arguments .: 2.78454 seconds
 - New School connect:
   - no arguments .........: 0.474147 seconds
   - int argument .........: 0.410915 seconds
   - two string arguments .: 0.405892 seconds
*/

#include <QtCore>

class Test : public QObject
{
    Q_OBJECT
public:

public slots:
    void zeroArguments() { }
    void intArgument(int) { }
    void twoStringArguments(const QString &, const QString &) { }

signals:
    void signalZeroArguments();
    void signalIntArgument(int);
    void signalTwoStringArguments(const QString &, const QString &);
};

int main(int, char **)
{
    Test t;
    QElapsedTimer timer;
    const int iterations = 1000000;


    // new school
    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, &Test::signalZeroArguments, &t, &Test::zeroArguments);
    }
    qint64 newschool_zero = timer.nsecsElapsed();

    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, &Test::signalIntArgument, &t, &Test::intArgument);
    }
    qint64 newschool_int = timer.nsecsElapsed();

    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, &Test::signalTwoStringArguments, &t, &Test::twoStringArguments);
    }
    qint64 newschool_twoStrings = timer.nsecsElapsed();



    // old school...
    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, SIGNAL(signalZeroArguments()), &t, SLOT(zeroArguments()));
    }
    qint64 oldschool_zero = timer.nsecsElapsed();

    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, SIGNAL(signalIntArgument(int)), &t, SLOT(intArgument(int)));
    }
    qint64 oldschool_int = timer.nsecsElapsed();

    timer.start();
    for (int i=0; i<iterations; ++i) {
        QObject::connect(&t, SIGNAL(signalTwoStringArguments(QString,QString)), &t, SLOT(twoStringArguments(QString,QString)));
    }
    qint64 oldschool_twoStrings = timer.nsecsElapsed();


    qDebug() << iterations << "iterations:" << endl
             << " - Old School connect:" << endl
             << "   - no arguments .........:" << oldschool_zero / 1000000000.0 << "seconds" << endl
             << "   - int argument .........:" << oldschool_int / 1000000000.0 << "seconds" << endl
             << "   - two string arguments .:" << oldschool_twoStrings / 1000000000.0 << "seconds" << endl
             << " - New School connect:" << endl
             << "   - no arguments .........:" << newschool_zero / 1000000000.0 << "seconds" << endl
             << "   - int argument .........:" << newschool_int / 1000000000.0 << "seconds" << endl
             << "   - two string arguments .:" << newschool_twoStrings / 1000000000.0 << "seconds" << endl

             ;

    return 0;
}

#include "connecttest.moc"