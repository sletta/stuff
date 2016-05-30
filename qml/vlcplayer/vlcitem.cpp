#include "vlcitem.h"

// #define RGB_FRAMES

VLCItem::VLCItem()
	: m_vlcPlayer(0)
	, m_vlcMedia(0)
	, m_vlc(0)
{
	setFlag(ItemHasContents, true);
	connect(this, &VLCItem::timeToUpdate, this, &QQuickItem::update);
}


void VLCItem::setSource(const QString &source)
{
	if (m_source == source)
		return;
	m_source = source;
	emit sourceChanged();
	polish();
}

static void *cb_lock(void *opaque, void **planes)
{
	VLCItem *self = (VLCItem *) (opaque);
	void *picture = self->lock(planes);
	// qDebug() << "VLC Callback: locked	" << opaque << planes << picture;
	return picture;
}

static void cb_unlock(void *opaque, void *picture, void *const *planes)
{
	// qDebug() << "VLC Callback: unlock" << opaque << picture << planes;
	VLCItem *self = (VLCItem *) (opaque);
	return self->unlock(picture, planes);
}

static void cb_display(void *opaque, void *picture)
{
	// qDebug() << "VLC Callback: display" << opaque << picture;
	VLCItem *self = (VLCItem *) opaque;
	self->display(picture);
}

static unsigned cb_videoFormat(void **opaque, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	qDebug() << "VLC Callback: videoFormat" << opaque << chroma << *width << *height << *pitches << *lines;
	VLCItem *self = (VLCItem *) (*opaque);
	return self->allocate(chroma, width, height, pitches, lines);
}

static void cb_cleanup(void *opaque)
{
	qDebug() << "VLC Callback: cleanup" << opaque;
}

static void cb_log(void *data, int level, const libvlc_log_t *ctx, const char *fmt, va_list args)
{
	char str[1024];
	vsprintf(str, fmt, args);
	qDebug() << "VLC Log: " << level << str;
}

void VLCItem::updatePolish()
{
	if (m_vlcPlayer)
		return;

 	qDebug() << "VLC:";

	const char *vlcArgv[] = {
		"--no-audio",
		"--avcodec-hw=vdpau-nvidia",
		"--swscale-mode=4"
	};
	int vlcArgc = sizeof(vlcArgv) / sizeof(*vlcArgv);
 	m_vlc = libvlc_new(vlcArgc, vlcArgv);
 	qDebug() << " - instance:" << m_vlc;

 	libvlc_log_set(m_vlc, cb_log, 0);

 	if (source().startsWith(QStringLiteral("rtsp://"))) {
 		m_vlcMedia = libvlc_media_new_location(m_vlc, qPrintable(source()));
		libvlc_media_add_option(m_vlcMedia, ":network-caching=2000");
	} else {
		m_vlcMedia = libvlc_media_new_path(m_vlc, qPrintable(source()));
	}
	qDebug() << " - media:" << m_vlcMedia;

	m_vlcPlayer = libvlc_media_player_new_from_media(m_vlcMedia);
	qDebug() << " - player:" << m_vlcPlayer;
	libvlc_media_release(m_vlcMedia);

	libvlc_video_set_callbacks(m_vlcPlayer, cb_lock, cb_unlock, cb_display, this);
	libvlc_video_set_format_callbacks(m_vlcPlayer, cb_videoFormat, cb_cleanup);
	qDebug() << " - callbacks registered..";

	libvlc_media_player_play(m_vlcPlayer);
}

int VLCItem::allocate(char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
#ifdef RGB_FRAMES
	memcpy(chroma, "RV32", 4);
#else
	memcpy(chroma, "I420", 4);
#endif

	int w = QQuickItem::width();
	int h = QQuickItem::height();
	if (w % 4) w -= w % 4;
	if (h % 4) h -= h % 4;
	*width = w;
	*height = h;
	// *height = 288;
	Q_ASSERT(*width % 2 == 0);
	Q_ASSERT(*height % 2 == 0);

	const int POOL_SIZE = 5;
	for (int i=0; i<POOL_SIZE; ++i) {
		VLCFrame frame;
#ifdef RGB_FRAMES
		frame.rgb = QImage(*width, *height, QImage::Format_RGB32);
#else
		frame.y = QImage(*width, *height, QImage::Format_Grayscale8);
		frame.u = QImage(*width / 2, *height / 2, QImage::Format_Grayscale8);
		frame.v = QImage(*width / 2, *height / 2, QImage::Format_Grayscale8);
#endif
		m_frames.append(frame);
		m_writeQueue.append(frame);
	}

	const VLCFrame &frame = m_frames.first();

#ifdef RGB_FRAMES
	pitches[0] = frame.rgb.bytesPerLine();
	lines[0] = frame.rgb.height();
#else
	pitches[0] = frame.y.bytesPerLine();
	pitches[1] = frame.u.bytesPerLine();
	pitches[2] = frame.v.bytesPerLine();
	lines[0] = frame.y.height();
	lines[1] = frame.u.height();
	lines[2] = frame.v.height();
#endif

	return POOL_SIZE;
}

void *VLCItem::lock(void **planes)
{
	QMutexLocker locker(&m_writeQueueMutex);
	if (m_writeQueue.isEmpty()) {
		// qDebug() << "VLCItem::lock: out of frames, need to wait..";
		m_writeQueueCondition.wait(&m_writeQueueMutex);
		Q_ASSERT(m_writeQueue.size() > 0);
		// qDebug() << "VLCItem::lock: was out of frames, now in good shape again..";
	}

	VLCFrame frame = m_writeQueue.dequeue();

	// Using constBits to avoid internal detach() and deep copy.
#ifdef RGB_FRAMES
	planes[0] = (void *) frame.rgb.constBits();
#else
	planes[0] = (void *) frame.y.constBits();
	planes[1] = (void *) frame.u.constBits();
	planes[2] = (void *) frame.v.constBits();
#endif

	// qDebug(" - planes [0]=%p, [1]=%p, [2]=%p", planes[0], planes[1], planes[2]);

	return planes[0];
}

void VLCItem::unlock(void *picture, void *const *)
{
	foreach (const VLCFrame &f, m_frames) {
		if (f.y.constBits() == picture || f.rgb.constBits() == picture) {
			m_displayQueueMutex.lock();
			m_displayQueue.enqueue(f);
			m_displayQueueMutex.unlock();
			return;
		}
	}
	Q_ASSERT(false);
}


void VLCItem::display(void *picture)
{
	unlock(picture, 0);

	// Use a signal/slot connection so QQuickItem::update gets called on the
	// GUI thread.
	emit timeToUpdate();
}


class PlaneTexture : public QSGTexture
{
public:
	PlaneTexture()
		: m_id(0)
	{
	}

	virtual void update(const QImage &plane, int w, int h)
	{
		QOpenGLFunctions *gl = QOpenGLContext::currentContext()->functions();

		if (m_id == 0) {
			gl->glGenTextures(1, &m_id);
			gl->glBindTexture(GL_TEXTURE_2D, m_id);
        	gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        	gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        	gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        	gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		} else {
			gl->glBindTexture(GL_TEXTURE_2D, m_id);
		}

#if 0
		if (m_data.size() != w * h) {
			m_data.resize(w * h);
			m_data.fill(0);
		}

		// Quick and cheap nearest neighboor downscaling using 22.10 fixed
		// point math.
		int sx = (plane.width() << 10) / w;
		int sy = (plane.height() << 10) / h;
		char *data = m_data.data();
		for (int y=0; y<h; ++y) {
			const uchar *src = plane.constScanLine((y * sy) >> 10);
			uchar *dst = (uchar *) (data + y * w);
			int px = 0;
			for (int x=0; x<w; ++x) {
				dst[x] = src[px >> 10];
				px += sx;
			}
		}
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, w, h, 0, GL_RED, GL_UNSIGNED_BYTE, data);
#else
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, plane.width(), plane.height(), 0, GL_RED, GL_UNSIGNED_BYTE, plane.constBits());
#endif
		m_size = QSize(w, h);
	}

	int textureId() const Q_DECL_OVERRIDE { return m_id; }
    QSize textureSize() const Q_DECL_OVERRIDE  { return m_size; }
    bool hasAlphaChannel() const Q_DECL_OVERRIDE  { return false; }
    bool hasMipmaps() const Q_DECL_OVERRIDE  { return false; }
    void bind() Q_DECL_OVERRIDE  { glBindTexture(GL_TEXTURE_2D, m_id); }

protected:
	QByteArray m_data;
	unsigned int m_id;
	QSize m_size;
};


class I420Node : public QSGGeometryNode
{
public:
	I420Node()
		: geometry(QSGGeometry::defaultAttributes_TexturedPoint2D(), 4)
	{
		setGeometry(&geometry);
		setFlag(OwnsGeometry, false);
		planes.y = new PlaneTexture();
		planes.u = new PlaneTexture();
		planes.v = new PlaneTexture();
	}

	~I420Node()
	{
		delete planes.y;
		delete planes.u;
		delete planes.v;
	}

	QSGGeometry geometry;

	struct Planes {
		PlaneTexture *y;
		PlaneTexture *u;
		PlaneTexture *v;
	} planes;
};

class I420Shader : public QSGSimpleMaterialShader<I420Node::Planes>
{
    QSG_DECLARE_SIMPLE_SHADER(I420Shader, I420Node::Planes)
public:

    const char *vertexShader() const {
        return
        "attribute highp vec4 aV;                   \n"
        "attribute highp vec2 aTC;                  \n"
        "uniform highp mat4 qt_Matrix;              \n"
        "varying highp vec2 vTC; 					\n"
        "void main() {                              \n"
        "    gl_Position = qt_Matrix * aV;          \n"
        "    vTC = aTC;								\n"
        "}";
    }

    const char *fragmentShader() const {
        return
        "varying highp vec2 vTC; 										\n"
        "uniform lowp sampler2D yPlane;									\n"
        "uniform lowp sampler2D uPlane;									\n"
        "uniform lowp sampler2D vPlane;									\n"
        "uniform highp mat3 M; 											\n"
        "uniform lowp float qt_Opacity;             					\n"
        "void main() {                              					\n"
        "    vec3 yuv = vec3(texture2D(yPlane, vTC).x - 0.0625, 		\n"
        "                    texture2D(uPlane, vTC).x - 0.5,   			\n"
        "                    texture2D(vPlane, vTC).x - 0.5);			\n"
        "    gl_FragColor = vec4(M * yuv, 1.0) * qt_Opacity;			\n"
        "}";
    }

    QList<QByteArray> attributes() const {
        return QList<QByteArray>() << "vC" << "vTC";
    }

    void resolveUniforms() {
    	// Strictly not "resolving" a uniform, but this value is constant
    	// across all draw calls, so we just need to set it once.

    	// float values[] = { 1.0, 0.0, 1.28033,
	    //                    1.0, -0.21482, -0.38059,
    	//                    1.0, 2.12798, 0.0};
    	// float values[] = { 1.0, 0, 0,
    	// 			   	   1.0, 0, 0,
    	// 			       1.0, 0, 0 };
    	float values[] = { 1.0, 0.0, 1.13983,
    				   	   1.0, -0.39465, -0.58060,
    				       1.0, 2.03211, 0.0 };
    	program()->setUniformValue("M", QMatrix3x3(values));

    	// Set up to match texture units
    	program()->setUniformValue("yPlane", 0);
    	program()->setUniformValue("uPlane", 1);
    	program()->setUniformValue("vPlane", 2);
    }

    void updateState(const I420Node::Planes *state, const I420Node::Planes *) {
    	QOpenGLFunctions *gl = QOpenGLContext::currentContext()->functions();
    	gl->glActiveTexture(GL_TEXTURE2);
    	state->v->bind();
    	gl->glActiveTexture(GL_TEXTURE1);
    	state->u->bind();
    	gl->glActiveTexture(GL_TEXTURE0);
    	state->y->bind();
    }
};


QSGNode *VLCItem::updatePaintNode(QSGNode *old, UpdatePaintNodeData *)
{
	m_displayQueueMutex.lock();

	// Nothing new, reuse existing state
	if (m_displayQueue.isEmpty()) {
		m_displayQueueMutex.unlock();
		return old;
	}

	VLCFrame frame = m_displayQueue.dequeue();
	// If we have multiple ones posted, skip to the most recent one
	if (!m_displayQueue.isEmpty()) {
		QMutexLocker locker(&m_writeQueueMutex);
		while (!m_displayQueue.isEmpty()) {
			m_writeQueue.enqueue(frame);
			frame = m_displayQueue.dequeue();
		}
		m_writeQueueCondition.wakeOne();
	}
	m_displayQueueMutex.unlock();

#ifdef RGB_FRAMES
	QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode *>(old);
	if (!node) {
		node = new QSGSimpleTextureNode();
		node->setRect(0, 0, width(), height());
	}

	QSGTexture *texture = window()->createTextureFromImage(frame.rgb);
	texture->bind();
	node->setTexture(texture);
#else
	I420Node *node = static_cast<I420Node *>(old);
	if (!node) {
		node = new I420Node();
		QRectF rect(0, 0, width(), height());
		QSGGeometry::updateTexturedRectGeometry(&node->geometry, rect, QRectF(0, 0, 1, 1));

		QSGSimpleMaterial<I420Node::Planes> *material = I420Shader::createMaterial();
		material->state()->y = node->planes.y;
		material->state()->u = node->planes.u;
		material->state()->v = node->planes.v;
		node->setMaterial(material);
		node->setFlag(QSGNode::OwnsMaterial, true);
	}

	// QElapsedTimer timer; timer.start();

	int w = qMin<int>(width(), frame.y.width());
	int h = qMin<int>(height(), frame.y.height());

	// Push the new frame data into textures
	node->planes.y->update(frame.y, w, h);
	node->planes.u->update(frame.u, w / 2, h / 2);
	node->planes.v->update(frame.v, w / 2, h / 2);
	node->markDirty(QSGNode::DirtyMaterial);

	// qDebug() << "uploaded in" << timer.nsecsElapsed() / 1000000.0 << frame.y.size();
#endif

	// Now that the buffer is uploaded, give it back to the write queue.
	m_writeQueueMutex.lock();
	m_writeQueue.enqueue(frame);
	m_writeQueueCondition.wakeOne();
	m_writeQueueMutex.unlock();


	return node;
}