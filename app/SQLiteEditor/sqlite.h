#ifndef SQLITE_H
#define SQLITE_H

#include <QObject>
#include <QUrl>
#include <QSqlDatabase>
#include <QStringList>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QMap>
#include <QTime>
#include <QDebug>
#include <QJSEngine>
#include <QJSValue>
#include <QJSValueList>

#include "dbthread.h"

class SQLite : public QObject
{
    Q_OBJECT
    Q_ENUMS(Status)
    Q_PROPERTY(QUrl databasePath READ databasePath WRITE setDatabasePath NOTIFY databasePathChanged)
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(Status status READ getStatus WRITE setStatus NOTIFY statusChanged)

public:
    explicit SQLite(QObject *parent = 0);
    enum Status {
        Null,
        Ready,
        Loading,
        Error
    };
    QUrl databasePath() const
    {
        return m_databasePath;
    }

    QString getQuery() const
    {
        return m_query;
    }

    Status getStatus() const
    {
        return m_status;
    }

signals:

    void databaseOpened();

    void databasePathChanged(QUrl arg);

    void queryChanged(QString arg);

    void statusChanged(Status arg);

    void resultsReady(QVariantList results, QString query);

private slots:
    void createThread(QUrl);
    void slotResults( const QList<QSqlRecord>& );
    void dbThreadStarted();

public slots:
    void executeQuery(QString);

void setDatabasePath(QUrl arg)
{
    qDebug() << __PRETTY_FUNCTION__ << arg;
    if (m_databasePath == arg)
        return;

    m_databasePath = arg;
    emit databasePathChanged(arg);
}

void setQuery(QString arg)
{
    if (m_query == arg)
        return;

    m_query = arg;
    emit queryChanged(arg);
}

void setStatus(Status arg)
{
    if (m_status == arg)
        return;

    m_status = arg;
    emit statusChanged(arg);
}

private:
    DbThread *m_dbThread;

    QUrl m_databasePath;
    QString m_query;
    Status m_status;
};

#endif // SQLITE_H
