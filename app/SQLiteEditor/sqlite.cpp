#include "sqlite.h"

SQLite::SQLite(QObject *parent) :
    QObject(parent),
    m_dbThread(NULL),
    m_databasePath(QUrl(""))
{
    //    qRegisterMetaType< QList<QSqlRecord> >( "QList<QSqlRecord>" );

    qDebug() << __PRETTY_FUNCTION__;

    connect(this, SIGNAL(databasePathChanged(QUrl)),
            this, SLOT(createThread(QUrl)));
}

void SQLite::createThread(QUrl databasePath)
{
    qDebug() << __PRETTY_FUNCTION__;
    if(databasePath.isEmpty()) return;

    if(m_dbThread && m_dbThread->isRunning())
    {
        dbThreadStarted();
    }
    else
    {
        m_dbThread = new DbThread(this, databasePath.toString(QUrl::RemoveScheme));
        connect( m_dbThread, SIGNAL( results( const QList<QSqlRecord>& ) ),
                 this, SLOT( slotResults( const QList<QSqlRecord>& ) ) );
        connect( m_dbThread, SIGNAL(started()), this, SLOT(dbThreadStarted()));
        m_dbThread->start();
    }
}

void SQLite::executeQuery(QString queryStatement)
{
    qDebug() << __PRETTY_FUNCTION__;
    setStatus(Loading);
    m_query = queryStatement;
    m_dbThread->execute(queryStatement);
}

void SQLite::slotResults(const QList<QSqlRecord> &result)
{
    qDebug() << __PRETTY_FUNCTION__;
    qDebug() << "count="<<result.count();


    QVariantList val;

    QListIterator<QSqlRecord> sqlRecordsIterator(result);

    while(sqlRecordsIterator.hasNext())
    {
        QSqlRecord sqlRecord = sqlRecordsIterator.next();
        QVariantMap dataMap;
        for(int column = 0; column < sqlRecord.count(); column++)
        {
            //qDebug() << sqlRecord.fieldName(column);
            dataMap.insert(sqlRecord.fieldName(column), sqlRecord.value(column));
        }
        val.append(QVariant::fromValue(dataMap));
    }
    qDebug() << "count of list=" << val.count();
    resultsReady(val, m_query);
    setStatus(Ready);
}

void SQLite::dbThreadStarted()
{
    qDebug() << __PRETTY_FUNCTION__;
    databaseOpened();
    if(!m_query.isEmpty())
    {
        this->executeQuery(m_query);
    }
    else
    {
        connect(this, SIGNAL(queryChanged(QString)),
                this, SLOT(executeQuery(QString)));
    }
}

