#include "tablerow.h"

static QVector<QQmlComponent *> tablerow_delegates;

bool TableRow::initialize(QQmlEngine *engine)
{
    for (int i=0; i<7; ++i) {
        QString fileName = QString::fromLatin1("Delegate%1.qml").arg(i);
        QQmlComponent *component = new QQmlComponent(engine, fileName);

        QList<QQmlError> errors = component->errors();
        if (errors.size()) {
            qDebug() << "Failed to prepare" << fileName << endl << errors;
            return false;
        }

        tablerow_delegates.append(component);
    }
    return true;
}

TableRow::TableRow()
    : m_model(0)
    , m_row(0)
    , m_cellWidth(50)
    , m_cellSpacing(5)
{
    polish();
}


void TableRow::updatePolish()
{
    if (!m_model)
        return;

    if (m_row < 0 || m_row >= m_model->rowCount()) {
        qDebug("TableRow: row=%d is out of bounds, model.rowCount=%d", m_row, m_model->rowCount());
        return;
    }

    const QModelIndex index = m_model->index(m_row, 0);

    int columnSize = m_model->data(index, Model::ColumnSize).toInt();
    int xpos = 0;

    QQmlContext *context = qmlContext(this);

    for (int i=0; i<columnSize; ++i) {
        int type = m_model->data(index, Model::ColumnType + i).toInt();

        // bad data, skip this cell
        if (type < 0 || type >= tablerow_delegates.size()) {
            xpos += m_cellWidth + m_cellSpacing;
            continue;
        }

        QQmlComponent *comp = tablerow_delegates.at(type);
        QObject *object = comp->create(context);

        QQuickItem *item = qobject_cast<QQuickItem *>(object);

        if (item) {
            item->setX(xpos);
            item->setWidth(m_cellWidth);
            item->setHeight(height() - m_cellSpacing);
            item->setParentItem(this);
        } else {
            delete object;
        }

        xpos += m_cellWidth + m_cellSpacing;

    }

}