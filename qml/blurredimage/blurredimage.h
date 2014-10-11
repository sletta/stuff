#ifndef BLURREDIMAGE_H
#define BLURREDIMAGE_H

#include <private/qquickimagebase_p.h>

#include <QtGui/QImage>

class BlurredImage : public QQuickImageBase
{
    Q_OBJECT

    Q_PROPERTY(qreal blurRatio READ blurRatio WRITE setBlurRatio NOTIFY blurRatioChanged)
public:
    BlurredImage();

    qreal blurRatio() const { return m_blurRatio; }
    void setBlurRatio(qreal ratio);

protected:
    void pixmapChange() Q_DECL_OVERRIDE;
    void geometryChanged(const QRectF &ng, const QRectF &og) Q_DECL_OVERRIDE;
    QSGNode *updatePaintNode(QSGNode *, UpdatePaintNodeData *);

signals:
    void sourceChanged();
    void blurRatioChanged();

private:
    qreal m_blurRatio;

    bool m_updateImage;
    bool m_updateRatio;
    bool m_updateGeometry;
};

#endif // BLURREDIMAGE_H
