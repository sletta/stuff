#include <QtGui>
#include <QtCore>

int nodeCount = 4;

class Window : public QWindow 
{
public:
	void exposeEvent(QExposeEvent *e) {
		if (isExposed()) 
			render();
	}

	void render() {
		QOpenGLContext context;
		context.setFormat(format());
		context.create();
		context.makeCurrent(this);

		QElapsedTimer timer;
		timer.start();

		int frameCount = 0;
		while (timer.elapsed() < 5000) {

			context.makeCurrent(this);

			QOpenGLPaintDevice device(width(), height());

			QPainter p(&device);
			p.setBrush(QColor::fromRgbF(1, 0, 0, 0.1));
			p.setPen(Qt::NoPen);
			for (int i=0; i<nodeCount; ++i) 
				p.drawRect(0, 0, width(), height());

			context.swapBuffers(this);

			++frameCount;
		}

		qDebug() << "FPS:" << (frameCount * 1000.0 / timer.elapsed());

		exit(0);
	}
};

int main(int argc, char **argv) 
{
    for (int i=0; i<argc; ++i) {
        if (i + 1 < argc && std::string(argv[i]) == "--count") {
            nodeCount = atoi(argv[++i]);
        }
    }

    qDebug() << "Drawing:" << nodeCount << "rects on top of each other...";

	QGuiApplication app(argc, argv);

	QScreen *screen = QGuiApplication::primaryScreen();

	Window window;
	window.setGeometry(0, 0, screen->geometry().width(), screen->geometry().height());
	window.setSurfaceType(QWindow::OpenGLSurface);
	window.showFullScreen();

	return app.exec();
}