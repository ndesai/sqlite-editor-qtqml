#ifndef SQLITEMODEL_H
#define SQLITEMODEL_H

#include <QAbstractItemModel>
#include <QDebug>
#include <QUrl>
#include <QSqlDatabase>
#include <QStringList>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QMap>
#include <QTime>
#include "dbthread.h"

class SQLiteModel : public QAbstractListModel
{
    Q_OBJECT
    Q_ENUMS(Status)
    Q_PROPERTY(QUrl databaseFilePath READ getDatabaseFilePath WRITE setDatabaseFilePath NOTIFY databaseFilePathChanged )
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(Status status READ getStatus WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(int count READ getCount NOTIFY countChanged)
public:
    explicit SQLiteModel(QObject *parent = 0);
    ~SQLiteModel();
    Q_INVOKABLE QVariant get(int index);
    enum Status {
        Null,
        Ready,
        Loading,
        Error
    };

    QUrl getDatabaseFilePath() const
    {
        return m_databaseFilePath;
    }

    QString getQuery() const
    {
        return m_query;
    }


    int getCount() const
    {
        return m_modelData.count();
    }

    Status getStatus() const
    {
        return m_status;
    }

signals:
    void databaseFilePathChanged(QUrl arg);
    void queryChanged(QString arg);
    void countChanged(int arg);

    void statusChanged(Status arg);

public slots:

    void setDatabaseFilePath(QUrl arg)
    {
        qDebug() << __PRETTY_FUNCTION__ << arg;
        if (m_databaseFilePath != arg) {
            m_databaseFilePath = arg;
            emit databaseFilePathChanged(arg);
        }
    }
    void setQuery(QString arg)
    {
        if (m_query != arg) {
            m_query = arg;
            emit queryChanged(arg);
        }
    }

    void setStatus(Status arg)
    {
        if (m_status != arg) {
            m_status = arg;
            emit statusChanged(arg);
        }
    }

private slots:
    //    void openDatabase(QUrl);
    void createThread(QUrl);
    void executeQuery(QString);
    void slotResults( const QList<QSqlRecord>& );
    void dbThreadStarted();

private:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QSqlDatabase m_db;
    QUrl m_databaseFilePath;
    QString m_query;

    QHash<int, QByteArray> m_roleNames;

    QList< QMap<QString, QString > > m_modelData;

    DbThread *m_dbThread;
    QTime executionTimer;

    Status m_status;
};



#endif // SQLITEMODEL_H
