#pragma once

#include <QAbstractTableModel>

class Model : public QAbstractListModel
{
public:
    Model();

    int rowCount(const QModelIndex &) const Q_DECL_OVERRIDE { return 1000; }
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;

    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE { return m_roleNames; }

private:
    enum CustomRoles {
        ColumnValue = Qt::UserRole + 1,
        ColumnType = Qt::UserRole + 100,
        ColumnSize = ColumnType + 200
    };

    QHash<int, QByteArray> m_roleNames;
};

inline Model::Model()
{
    for (int i=0; i<10; ++i)
        m_roleNames[ColumnValue + i] = QByteArray("column") + QByteArray::number(i);
    for (int i=0; i<10; ++i)
        m_roleNames[ColumnType + i] = QByteArray("columnType") + QByteArray::number(i);
    m_roleNames[ColumnSize] = "columnSize";
}

inline QVariant Model::data(const QModelIndex &index, int role) const
{
    if (role > Qt::UserRole) {
        if (role == ColumnSize) {
            return 10;
        } else if (role >= ColumnType) {
            return ((index.row() + (role - ColumnType)) * 3) % 7;
        } else {
            int col = role - ColumnValue;
            return QString::fromLatin1("cell(%1:%2)").arg(index.row()).arg(col);
        }
    }
    return QVariant();
}