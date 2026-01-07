#include "SqlTableModel.h"
#include <QDebug>

SqlTableModel::SqlTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
}

int SqlTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_data.count();
}

int SqlTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_columnNames.count();
}

QVariant SqlTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.count() || index.column() >= m_columnNames.count())
        return QVariant();

    // Support DisplayRole for TableView
    if (role == Qt::DisplayRole || role == Qt::EditRole) {
        return m_data[index.row()].value(index.column());
    }
    
    return QVariant();
}

QVariant SqlTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole) {
        if (section >= 0 && section < m_columnNames.count()) {
            return m_columnNames[section];
        }
    }
    return QVariant();
}

QHash<int, QByteArray> SqlTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "display"; 
    return roles;
}

void SqlTableModel::setRecords(const QList<QSqlRecord>& records)
{
    beginResetModel();
    m_data = records;
    m_columnNames.clear();
    if (!m_data.isEmpty()) {
        QSqlRecord rec = m_data.first();
        for (int i = 0; i < rec.count(); ++i) {
            m_columnNames.append(rec.fieldName(i));
        }
    }
    endResetModel();
    emit countChanged();
    emit columnNamesChanged();
}

QStringList SqlTableModel::columnNames() const
{
    return m_columnNames;
}

QVariant SqlTableModel::get(int row)
{
    if (row < 0 || row >= m_data.count())
        return QVariant();
    
    QVariantMap map;
    const QSqlRecord &rec = m_data[row];
    for (int i = 0; i < rec.count(); ++i) {
        map.insert(rec.fieldName(i), rec.value(i));
    }
    return map;
}
