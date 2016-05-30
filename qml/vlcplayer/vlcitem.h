#pragma once

#include <QtQuick>

#include <vlc/vlc.h>

// An i420 frame
struct VLCFrame
{
	QImage y;
	QImage u;
	QImage v;
	QImage rgb;
};

class VLCItem : public QQuickItem
{
	Q_OBJECT

	Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)

public:
	VLCItem();
	~VLCItem();

	QString source() const { return m_source; }
	void setSource(const QString &source);

	int allocate(char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines);
	void *lock(void **planes);
	void unlock(void *picture, void *const *planes);
	void display(void *picture);

protected:
	void updatePolish() Q_DECL_OVERRIDE;
	QSGNode *updatePaintNode(QSGNode *old, UpdatePaintNodeData *) Q_DECL_OVERRIDE;

signals:
	void sourceChanged();
	void timeToUpdate();

private:
	QString m_source;

	libvlc_media_player_t *m_vlcPlayer;
	libvlc_instance_t *m_vlc;

	QVector<VLCFrame> m_frames;

	QQueue<VLCFrame> m_writeQueue;
	QMutex m_writeQueueMutex;
	QWaitCondition m_writeQueueCondition;

	QQueue<VLCFrame> m_displayQueue;
	QMutex m_displayQueueMutex;
};

