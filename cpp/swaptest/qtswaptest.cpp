#include <QtGui>

class Window : public QWindow
{
    Q_OBJECT

public:
    Window()
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

    void exposeEvent(QExposeEvent *) Q_DECL_OVERRIDE
    {
        if (isExposed())
            render();
    }

    bool event(QEvent *e) Q_DECL_OVERRIDE
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
            qDebug() << "GL_VENDOR: " << (const char *) func->glGetString(GL_VENDOR);
            qDebug() << "GL_RENDERER: " << (const char *) func->glGetString(GL_RENDERER);
            qDebug() << "GL_VERSION: " << (const char *) func->glGetString(GL_VERSION);
#else
            Q_UNUSED(func);
            qDebug() << "GL_VENDOR: " << (const char *) glGetString(GL_VENDOR);
            qDebug() << "GL_RENDERER: " << (const char *) glGetString(GL_RENDERER);
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
        if (time > 10000) {
            qDebug() << frameCount << "frames in" << time << "ms;" <<
                        frameCount * 1000 / float(time) << "fps," <<
                        time / float(frameCount) << "ms/frame";
            QGuiApplication::instance()->exit();
        } else {
            QCoreApplication::postEvent(this, new QEvent(QEvent::UpdateRequest));
        }
    }

private:
    QOpenGLContext *gl;
    QElapsedTimer timer;
    int frameCount;
};

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    Window w;
    w.showFullScreen();

    return app.exec();
}

#include "qtswaptest.moc"
