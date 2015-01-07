#include <QtCore>
#include <QtGui>
#include <QtQuick>

class FpsDecider : public QWindow
{
public:
    FpsDecider()
        : gl(0)
        , frameCount(0)
    {
        setSurfaceType(OpenGLSurface);
        QSurfaceFormat format;
#if QT_VERSION >= 0x050300
        format.setSwapInterval(1);
#endif
        setFormat(format);
    }

    void exposeEvent(QExposeEvent *) {
        if (isExposed())
            render();
    }

    bool event(QEvent *e)
    {
        if (e->type() == QEvent::UpdateRequest) {
            render();
            return true;
        }
        return QWindow::event(e);
    }

    void render()
    {
        if (!gl) {
            gl = new QOpenGLContext();
            gl->setFormat(format());
            gl->create();
            timer.start();
        }

        gl->makeCurrent(this);
        QOpenGLFunctions *func = gl->functions();

        if (frameCount == 0) {
#if QT_VERSION >= 0x050300
            qDebug() << "GL_VENDOR:  " << (const char *) func->glGetString(GL_VENDOR);
            qDebug() << "GL_RENDERER:" << (const char *) func->glGetString(GL_RENDERER);
            qDebug() << "GL_VERSION: " << (const char *) func->glGetString(GL_VERSION);
#else
            Q_UNUSED(func);
            qDebug() << "GL_VENDOR:  " << (const char *) glGetString(GL_VENDOR);
            qDebug() << "GL_RENDERER:" << (const char *) glGetString(GL_RENDERER);
            qDebug() << "GL_VERSION: " << (const char *) glGetString(GL_VERSION);
#endif
        }

        ++frameCount;
        int c = frameCount % 2;

#if QT_VERSION >= 0x050300
        func->glClearColor(c, 0, 1 - c, 1);
        func->glClear(GL_COLOR_BUFFER_BIT);
#else
        glClearColor(c, 0, 1 - c, 1);
        glClear(GL_COLOR_BUFFER_BIT);
#endif

        gl->swapBuffers(this);

        int time = timer.elapsed();
        if (time > 5000) {
            qDebug() << endl
                     << "FPS:" << frameCount * 1000 / float(time)
                     << " -- " << frameCount << "frames in" << time << "ms;"
                     << time / float(frameCount) << "ms/frame" << endl;
            exit(0);

        } else {
            QCoreApplication::postEvent(this, new QEvent(QEvent::UpdateRequest));
        }
    }

private:
    QOpenGLContext *gl;
    QElapsedTimer timer;
    int frameCount;
};



struct Options
{
    Options()
        : bmTemplate("Shell.qml")
        , fullscreen(false)
    {
    }

    QString bmTemplate;
    bool fullscreen;
};



struct Benchmark
{
    Benchmark(const QString &file)
        : fileName(file)
        , completed(false)
    {
    }

    QString fileName;

    bool completed;
};



class BenchmarkRunner : public QObject
{
    Q_OBJECT
public:
    BenchmarkRunner();

    bool execute();

    QList<Benchmark> benchmarks;
    Options options;

public slots:
//    void recordResults(qreal opsPerSecond);

    void maybeStartNext();
    void start();
//    void complete();
    void abort();
    void abortAll();

private:
    int m_currentBenchmark;

    QQuickView *m_view;
    QQmlComponent *m_component;
};



int main(int argc, char **argv)
{
	QGuiApplication app(argc, argv);	

	QCommandLineParser parser;

    QCommandLineOption decideFpsOption(QStringLiteral("decide-fps"), QStringLiteral("Run a simple test to decide the frame rate of the primary screen"));
    parser.addOption(decideFpsOption);

    QCommandLineOption fullscreenOption(QStringLiteral("fullscreen"), QStringLiteral("Run graphics in fullscreen mode"));
    parser.addOption(fullscreenOption);

//    QCommandLineOption excludeRenderOption(QStringLiteral("exclude-rendering"),
//                                           QStringLiteral("Only object instantiation will be benchmarked, render is not measured"));
//    QCommandLineOption templateOption(QStringList() << QStringLiteral("t") << QStringLiteral("template"),
//                                           QStringLiteral("What kind of benchmark template to run"));


    parser.addPositionalArgument(QStringLiteral("input"),
                                 QStringLiteral("One or more QML files or a directory of QML files to benchmark"));
    const QCommandLineOption &helpOption = parser.addHelpOption();

    parser.process(app);

    if (parser.isSet(decideFpsOption)) {
        FpsDecider fpsDecider;
        if (parser.isSet(fullscreenOption))
            fpsDecider.showFullScreen();
        else
            fpsDecider.show();
        return app.exec();
    }

    if (parser.isSet(helpOption) || parser.positionalArguments().size() == 0) {
        parser.showHelp(0);
    }

    BenchmarkRunner runner;
    runner.options.fullscreen = parser.isSet(fullscreenOption);

    foreach (QString input, parser.positionalArguments()) {
        QFileInfo info(input);
        if (!info.exists()) {
            qDebug() << "input doesn't exist:" << input;
        } else if (info.suffix() == QStringLiteral("qml")) {
            runner.benchmarks << Benchmark(info.absoluteFilePath());
        } else if (info.isDir()) {
            QDirIterator iterator(input, QStringList() << QStringLiteral("*.qml"));
            while (iterator.hasNext()) {
                runner.benchmarks << Benchmark(iterator.next());
            }
        }
    }

    if (!runner.execute())
        return 0;

    app.setQuitOnLastWindowClosed(false);
    return app.exec();
}

BenchmarkRunner::BenchmarkRunner()
    : m_currentBenchmark(0)
    , m_view(0)
{

}

bool BenchmarkRunner::execute()
{
    m_currentBenchmark = 0;
    if (benchmarks.size() == 0)
        return false;
    QMetaObject::invokeMethod(this, "start", Qt::QueuedConnection);
    return true;
}

void BenchmarkRunner::start()
{
    if (!QFileInfo(options.bmTemplate).exists()) {
        qDebug() << "benchmark template missing:" << options.bmTemplate;
        abortAll();
        return;
    }

    m_view = new QQuickView();
    m_view->setSource(QUrl::fromLocalFile(options.bmTemplate));

    if (!m_view->rootObject()) {
        qDebug() << "no root object..";
        abortAll();
        return;
    }

    const Benchmark &bm = benchmarks.at(m_currentBenchmark);
    qDebug() << "running:" << bm.fileName;

    m_component = new QQmlComponent(m_view->engine(), bm.fileName);
    if (m_component->status() != QQmlComponent::Ready) {
        qDebug() << "component is not ready" << bm.fileName;
        abort();
        return;
    }

    m_view->rootObject()->dumpObjectTree();

    QObject *bmShell = 0;
    if (m_view->rootObject()->objectName() == QStringLiteral("benchmarkShell"))
        bmShell = m_view->rootObject();
    else
        bmShell = m_view->rootObject()->findChild<QQuickItem *>("benchmarkShell");

    if (!bmShell) {
        qDebug() << "no 'benchmarkShell' in" << options.bmTemplate;
        abortAll();
        return;
    }

    bool ok = bmShell->setProperty("benchmarkDelegate", QVariant::fromValue(m_component));
    if (!ok) {
        qDebug() << "failed to set 'benchmarkDelegate' in" << options.bmTemplate;
        abortAll();
        return;
    }

    if (options.fullscreen)
        m_view->showFullScreen();
    else
        m_view->show();
}

void BenchmarkRunner::maybeStartNext()
{
    ++m_currentBenchmark;
    if (benchmarks.size() < m_currentBenchmark) {
        start();
    } else {
        qDebug() << "All done...";
        qApp->quit();
    }
}

void BenchmarkRunner::abort()
{
    maybeStartNext();
}

void BenchmarkRunner::abortAll()
{
    qDebug() << "Aborting all benchmarks...";
    qApp->quit();
}

#include "main.moc"
