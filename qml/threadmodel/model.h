#pragma once

#include <QAbstractTableModel>
#include <QThread>
#include <QDebug>
#include <QCoreApplication>
#include <QRunnable>
#include <QThreadPool>

class Model;

class ModelThread : public QThread
{
    Q_OBJECT

protected:
    void run() Q_DECL_OVERRIDE;

signals:
    void dataReady(int Row, qint64 value);

private:
    int fibb(int i);
    friend class Model;
    Model* m_model;
    int m_count;
    QAtomicInt m_finished;
};

class Model : public QAbstractListModel
{
    Q_OBJECT

public:
    Model(int count = 100);
    ~Model();

    int rowCount(const QModelIndex &) const Q_DECL_OVERRIDE { return m_values.size(); }
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;

    void startProducing();

    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE { return m_roleNames; }

private slots:
    void dataReady(int Row, qint64 value);

signals:
    void contentReady();

private:
    QVector<qint64> m_values;
    ModelThread m_thread;

    QHash<int, QByteArray> m_roleNames;
};

inline Model::Model(int count)
{
    for (int i=0; i < count; i++)
        m_values.append(0);
    m_thread.m_count = m_values.size();
    m_thread.m_model = this;
    connect(&m_thread, &ModelThread::dataReady, this, &Model::dataReady);

    m_roleNames[Qt::UserRole] = "result";
}

inline void Model::startProducing()
{
    m_thread.start();
}

inline Model::~Model()
{
    m_thread.m_finished = true;
    m_thread.wait();
}

inline QVariant Model::data(const QModelIndex &index, int role) const
{
    if (role == Qt::UserRole) {
        qint64 value = m_values.at(index.row());
        if(value != 0)
            return value;
    }
    return QVariant();
}

inline void Model::dataReady(int row, qint64 value)
{
    Q_ASSERT(row >= 0);
    Q_ASSERT(row < m_values.size());
    m_values[row] = value;
    emit dataChanged(index(row),index(row));
}

// intentionally costly implementation so we'll end up spending a lot of time
// producing values..
inline int ModelThread::fibb(int i)
{
    if (i < 2)
        return 1;
    else
        return fibb(i-1)+fibb(i-2);
}

inline void ModelThread::run()
{
    for (int i=0; ((i < m_count) && !m_finished); i++)
    {
        qint64 v = fibb(i);
        emit dataReady(i, v);
    }
}
