#pragma once

#include <QAbstractTableModel>
#include <QList>
#include <QSqlRecord>
#include <QStringList>
#include <QVariant>

class SqlTableModel : public QAbstractTableModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(QStringList columnNames READ columnNames NOTIFY columnNamesChanged)

public:
    explicit SqlTableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setRecords(const QList<QSqlRecord>& records);

    QStringList columnNames() const;

    Q_INVOKABLE QVariant get(int row);

signals:
    void countChanged();
    void columnNamesChanged();

private:
    QList<QSqlRecord> m_data;
    QStringList m_columnNames;
};
