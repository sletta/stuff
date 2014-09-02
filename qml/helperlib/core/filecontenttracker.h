#ifndef FILECONTENTTRACKER_H
#define FILECONTENTTRACKER_H

#include <QtCore/QObject>
#include <QtCore/QFileSystemWatcher>
#include <QtCore/QString>

class FileContentTracker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUrl file WRITE setFile)
    Q_PROPERTY(QByteArray content READ content NOTIFY contentChanged)

public:
    FileContentTracker();

    void setFile(const QUrl &file);
    void timerEvent(QTimerEvent *);

    QByteArray content() const { return m_content; }

signals:
    void contentChanged();

public slots:
    void updateContent(const QString &string);
    
private:
    QByteArray m_content;
    QString m_fileName;
    QFileSystemWatcher *m_watcher;
    int m_timer;
};

#endif // FILECONTENTTRACKER_H
