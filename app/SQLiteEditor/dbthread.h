#ifndef DBTHREAD_H
#define DBTHREAD_H

#include <QList>
#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QString>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QUuid>

class DbWorker;

class DbThread : public QThread
{
    Q_OBJECT
public:
    explicit DbThread(QObject *parent = 0, QString databaseFilePath = "");
    ~DbThread();

    void execute( const QString& query );
    
signals:
    void progress( const QString& msg );
    void ready(bool);
    void results( const QList<QSqlRecord>& records );

protected:
    void run();

signals:
    void executefwd( const QString& query );

private:
    DbWorker* m_worker;
    QString m_databaseFilePath;
    
};

#endif // DBTHREAD_H
