// MIT License
//
// Copyright (c) 2017 Niraj Desai
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include "dbthread.h"

#define DATABASE_DRIVER "QSQLITE"

class DbWorker : public QObject
{
  Q_OBJECT

   public:
    DbWorker( QObject* parent = 0, QString databasePath = "");
    ~DbWorker();

  public slots:
    void slotExecute( const QString& query );

signals:
  void results( const QList<QSqlRecord>& records );

   private:
     QSqlDatabase m_database;
};

DbWorker::DbWorker( QObject* parent, QString databasePath )
    : QObject( parent )
{
    QUuid uuid = QUuid::createUuid();
    m_database = QSqlDatabase::addDatabase(DATABASE_DRIVER, uuid.toString());
    m_database.setDatabaseName(databasePath);

    if (!m_database.open())
    {
        qDebug() << "Unable to connect to database, giving up:" << m_database.lastError().text();
        return;
    }
}

DbWorker::~DbWorker()
{
    m_database.close();
}

void DbWorker::slotExecute( const QString& query )
{
    qDebug() << __PRETTY_FUNCTION__;
    QList<QSqlRecord> recs;
    QSqlQuery sql(query, m_database);
    while(sql.next())
    {
        recs.push_back(sql.record());
    }
    qDebug() << Q_FUNC_INFO << "query is\"" << query << "\"and records count is" << recs.count();
    emit results(recs);
}

//

DbThread::DbThread(QObject *parent, QString databaseFilePath) :
    QThread(parent)
{
    m_databaseFilePath = databaseFilePath;
}

DbThread::~DbThread()
{
    delete m_worker;
}

void DbThread::execute(const QString &query)
{
    qDebug() << __PRETTY_FUNCTION__;
    emit executefwd(query);
}

void DbThread::run()
{
    emit ready(false);
    emit progress("DbThread is starting..one moment please..");

    m_worker = new DbWorker(0, m_databaseFilePath);

    connect( this, SIGNAL( executefwd( const QString& ) ),
             m_worker, SLOT( slotExecute( const QString& ) ) );

    qRegisterMetaType< QList<QSqlRecord> >( "QList<QSqlRecord>" );

    connect( m_worker, SIGNAL( results( const QList<QSqlRecord>& ) ),
             this, SIGNAL( results( const QList<QSqlRecord>& ) ) );

    emit ready(true);

    exec();

}

#include "dbthread.moc"
