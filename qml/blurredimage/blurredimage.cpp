#include "blurredimage.h"

#include <QQuickWindow>
#include <QSGSimpleTextureNode>
#include <QSGSimpleMaterial>
#include <QSGGeometry>
#include <QQuickTextureFactory>
#include <private/qquickimagebase_p_p.h>

#include <qopengl.h>
#include <qmath.h>
#include <QPainter>

// #define DUMP_IMAGES

BlurredImage::BlurredImage()
    : m_blurRatio(0)
    , m_updateImage(false)
    , m_updateRatio(false)
    , m_updateGeometry(false)
{
    setFlag(ItemHasContents);
}

void BlurredImage::setBlurRatio(qreal ratio)
{
    ratio = qBound<qreal>(0, ratio, 1);
    if (ratio == m_blurRatio)
        return;
    m_blurRatio = ratio;
    emit blurRatioChanged();
    m_updateRatio = true;
    update();
}


void BlurredImage::pixmapChange()
{
    m_updateImage = true;
    update();
    QQuickImageBase::pixmapChange();
}

void BlurredImage::geometryChanged(const QRectF &ng, const QRectF &og)
{
    m_updateGeometry = true;
    QQuickImageBase::geometryChanged(ng, og);
}

static QImage boxBlur(const QImage &s)
{
    int sw = s.width();
    int sh = s.height();
    uint *sp = (uint *) s.bits();
    uint sstride = s.bytesPerLine() / 4;

    QImage d(s.width(), s.height(), QImage::Format_ARGB32_Premultiplied);
    uint *dp = (uint *) d.bits();
    uint dstride = d.bytesPerLine() / 4;

    for (int y=0; y<sh; ++y) {
        for (int x=0; x<sw; ++x) {
            int r = 0;
            int g = 0;
            int b = 0;
            int a = 0;
            const int radius = 1;
            for (int yy=-radius; yy<=radius; ++yy) {
                for (int xx=-radius; xx<=radius; ++xx) {
                    int sx = x + xx;
                    int sy = y + yy;
                    if (sy >= 0 && sy < sh && sx >= 0 && sx < sw) {
                        int p = sp[sy * sstride + sx];
                        r += qRed(p);
                        g += qGreen(p);
                        b += qBlue(p);
                        a += qAlpha(p);
                    }
                }
            }
            const int div = (radius * 2 + 1) * (radius * 2 + 1);
            dp[y * dstride + x] = qRgba(r / div, g / div, b / div, a / div);
        }
    }
    return d;
}

static QImage downscaleAndBlur(const QImage &image)
{
    QImage s = image;
    s = s.scaled(image.width() / 2,
                 image.height() / 2,
                 Qt::IgnoreAspectRatio,
                 Qt::SmoothTransformation);

    static const bool BLUR = qEnvironmentVariableIsEmpty("NO_MIPMAP_BLURRING");
    return BLUR ? boxBlur(s) : s;
}

class BlurryTexture : public QSGTexture
{
public:
    BlurryTexture(const QImage &image)
        : m_image(image)
    {
        glGenTextures(1, &m_id);
        glBindTexture(GL_TEXTURE_2D, m_id);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        m_size = image.size();
        m_levels = 0;
    }

    bool hasAlphaChannel() const Q_DECL_OVERRIDE { return true; }
    bool hasMipmaps() const Q_DECL_OVERRIDE { return true; }
    QSize textureSize() const Q_DECL_OVERRIDE { return m_size; }
    int textureId() const Q_DECL_OVERRIDE { return m_id; }
    void bind() Q_DECL_OVERRIDE {
        glBindTexture(GL_TEXTURE_2D, m_id);
        if (!m_image.isNull()) {
//            QElapsedTimer timer; timer.start();
#ifdef DUMP_IMAGES
            QImage result(m_image.width() * 4, m_image.height() * 2, QImage::Format_ARGB32_Premultiplied);
            result.fill(Qt::white);
            QPainter p(&result);
            p.setRenderHint(QPainter::SmoothPixmapTransform);
#endif
            QImage image = m_image.convertToFormat(QImage::Format_ARGB32_Premultiplied);
            int level = 0;
            while (image.width() >= 1 && image.height() >= 1) {
#ifdef DUMP_IMAGES
                if (level < 4) {
                    qreal x = level * m_image.width();
                    p.drawImage(QRect(x, 0, m_image.width(), m_image.height()), image);
                    x += m_image.width() / 2 - image.width() / 2;
                    qreal y = m_image.height() + m_image.height() / 2 - image.height() / 2;
                    p.drawImage(x, y, image);
                    p.drawRect(x, y, image.width(), image.height());
                }
#endif

                glTexImage2D(GL_TEXTURE_2D, level, GL_RGBA, image.width(), image.height(),
                             0, GL_BGRA, GL_UNSIGNED_BYTE, image.constBits());
                image = downscaleAndBlur(image);
                ++level;
            }
#ifdef DUMP_IMAGES
            p.end();
            result.save(QString::fromLatin1("image_%1.png").arg(m_id));
#endif
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, level - 1);
            m_levels = level;
            m_image = QImage();
//            printf("uploaded %dx%d image in %d ms\n", m_size.width(), m_size.height(), (int) timer.elapsed());
        }
    }

    int levels() const { return m_levels; }

private:
    GLuint m_id;
    QSize m_size;
    QImage m_image;
    int m_levels;
};

struct BlurImageState
{
    float ratio;
    BlurryTexture *texture;
};

class BlurImageShader : public QSGSimpleMaterialShader<BlurImageState>
{
    QSG_DECLARE_SIMPLE_SHADER(BlurImageShader, BlurImageState)

public:
    BlurImageShader() {
        setShaderSourceFile(QOpenGLShader::Vertex, ":/blurredimage.vsh");
        setShaderSourceFile(QOpenGLShader::Fragment, ":/blurredimage.fsh");
    }

    QList<QByteArray> attributes() const {
        return QList<QByteArray>() << "v" << "t";
    }

    void updateState(const BlurImageState *s, const BlurImageState *) {
        s->texture->bind();
        program()->setUniformValue(id_ratio, s->ratio * s->texture->levels());
    }

    void resolveUniforms() {
        id_tex = program()->uniformLocation(QLatin1String("tex"));
        id_ratio = program()->uniformLocation(QLatin1String("ratio"));
    }

private:
    int id_tex;
    int id_ratio;
};

class BlurNode : public QSGGeometryNode
{
public:
    BlurNode()
        : g(QSGGeometry::defaultAttributes_TexturedPoint2D(), 4)
    {
        setGeometry(&g);

        QSGSimpleMaterial<BlurImageState> *m = BlurImageShader::createMaterial();
        state = m->state();
        state->ratio = 0;
        state->texture = 0;
        m->setFlag(QSGMaterial::Blending, true);
        setMaterial(m);
        setFlag(OwnsMaterial, true);
    }

    ~BlurNode() {
        GLuint id = state->texture->textureId();
        glDeleteTextures(1, &id);
    }

    void setRect(const QRectF r) {
        QSGGeometry::updateTexturedRectGeometry(&g, r, QRectF(0, 0, 1, 1));
    }

    BlurImageState *state;
    QSGGeometry g;
};

class BlurryTextureCache : public QObject
{
    Q_OBJECT
public:
    static BlurryTexture *lookup(QQuickWindow *window, QQuickTextureFactory *);

public slots:
    void invalidated();
    void afterSync();
    void nuked(QObject *o);

private:
    static QHash<QQuickWindow *, BlurryTextureCache *> caches;
    QHash<QQuickTextureFactory *, BlurryTexture *> textures;
    QSet<QQuickTextureFactory *> deleted;
};

QHash<QQuickWindow *, BlurryTextureCache *> BlurryTextureCache::caches;

BlurryTexture *BlurryTextureCache::lookup(QQuickWindow *window, QQuickTextureFactory *f)
{
    BlurryTextureCache *c = caches.value(window);
    if (!c) {
        c = new BlurryTextureCache();
        caches[window] = c;
        connect(window, SIGNAL(sceneGraphInvalidated()), c, SLOT(invalidated()), Qt::DirectConnection);
        connect(window, SIGNAL(afterSynchronizing()), c, SLOT(afterSync()), Qt::DirectConnection);
    }

    BlurryTexture *t = c->textures.value(f);
    if (!t) {
        t = new BlurryTexture(f->image());
        c->textures[f] = t;
        connect(f, SIGNAL(destroyed(QObject*)), c, SLOT(nuked(QObject*)), Qt::DirectConnection);
    }

    return t;
}

void BlurryTextureCache::invalidated()
{
    qDeleteAll(textures.values());
    caches.remove(caches.key(this));
}

void BlurryTextureCache::nuked(QObject *o)
{
    deleted << static_cast<QQuickTextureFactory *>(o);
}

void BlurryTextureCache::afterSync()
{
    foreach (QQuickTextureFactory *f, deleted)
        delete textures.take(f);
}

QSGNode *BlurredImage::updatePaintNode(QSGNode *old, UpdatePaintNodeData *)
{
    if (m_updateImage) {
        m_updateGeometry = true;
        m_updateRatio = true;
        delete old;
        old = 0;
    }

    BlurNode *node = static_cast<BlurNode *>(old);
    if (!old) {
        node = new BlurNode();
        QQuickImageBasePrivate *d = (QQuickImageBasePrivate *) QQuickItemPrivate::get(this);
        node->state->texture = BlurryTextureCache::lookup(window(), d->pix.textureFactory());
        m_updateImage = false;
    }

    QSGNode::DirtyState dirty = 0;

    if (m_updateRatio) {
        node->state->ratio = m_blurRatio;
        dirty |= QSGNode::DirtyMaterial;
        m_updateRatio = false;
    }

    if (m_updateGeometry) {
        node->setRect(boundingRect());
        m_updateGeometry = false;
    }

    node->markDirty(dirty);

    return node;
}

#include "blurredimage.moc"



