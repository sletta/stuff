#include "filecontenttracker.h"

#include <QtCore/QFileInfo>
#include <QtCore/QDebug>
#include <QtCore/QUrl>

FileContentTracker::FileContentTracker()
    : m_watcher(0)
    , m_timer(0)
{
}

void FileContentTracker::setFile(const QUrl &file)
{
    if (m_watcher) {
        delete m_watcher;
        m_watcher = 0;
        killTimer(m_timer);
        m_timer = 0;
    }

    m_fileName = file.toLocalFile();

    QFileInfo info(m_fileName);
    if (!info.exists()) {
        qDebug() << "FileContentTracker: file does not exist:" << m_fileName;
        return;
    }

    if (!info.isFile()) {
        qDebug() << "FileContentTracker: not a file:" << m_fileName;
        return;
    }

    m_watcher = new QFileSystemWatcher(this);
    if (!m_watcher->addPath(m_fileName)) {
        qDebug() << "FileContentTracker: failed to track file" << m_fileName;
        delete m_watcher;
        m_watcher = 0;
        return;
    }

    qDebug() << "FileContentTracker: now tracking" << m_fileName;

    connect(m_watcher, SIGNAL(fileChanged(QString)), this, SLOT(updateContent(QString)));
    updateContent(m_fileName);
    m_timer = startTimer(1000); // Need this because it doesn't seem to track on Mac OS X.
}

void FileContentTracker::timerEvent(QTimerEvent *)
{
    updateContent(m_fileName);
}

void FileContentTracker::updateContent(const QString &name)
{
    QFile f(name);
    if (!f.open(QFile::ReadOnly)) {
        qDebug() << "FileContentTracker: failed to open file" << name;
        return;
    }
    m_content = f.readAll();

    emit contentChanged();
}


