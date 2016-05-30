#pragma once

#include <QtQuick>

#include "model.h"

class TableRow : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QAbstractItemModel *model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(int row READ row WRITE setRow NOTIFY rowChanged)
    Q_PROPERTY(int cellWidth READ cellWidth WRITE setCellWidth NOTIFY cellWidthChanged)
    Q_PROPERTY(int cellSpacing READ cellSpacing WRITE setCellSpacing NOTIFY cellSpacingChanged)

public:
    static bool initialize(QQmlEngine *engine);

protected:
    TableRow();

    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry) Q_DECL_OVERRIDE;
    void updatePolish() Q_DECL_OVERRIDE;

    QAbstractItemModel *model() const { return m_model; }
    void setModel(QAbstractItemModel *model) { if (m_model != model) { m_model = model; emit modelChanged(); } }

    int row() const { return m_row; }
    void setRow(int row) { if (row != m_row) { m_row = row; emit rowChanged(); } }

    int cellWidth() const { return m_cellWidth; }
    void setCellWidth(int width) { if (m_cellWidth != width) { m_cellWidth = width; emit cellWidthChanged(); } }

    int cellSpacing() const { return m_cellSpacing; }
    void setCellSpacing(int spacing) { if (m_cellSpacing != spacing) { m_cellSpacing = spacing; emit cellSpacingChanged(); } }

    Q_INVOKABLE void polishNow() { updatePolish(); }

signals:
    void rowChanged();
    void modelChanged();
    void cellWidthChanged();
    void cellSpacingChanged();

private:
    QAbstractItemModel *m_model;
    int m_row;
    int m_cellWidth;
    int m_cellSpacing;
};

inline void TableRow::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    polish();
    QQuickItem::geometryChanged(newGeometry, oldGeometry);
}

