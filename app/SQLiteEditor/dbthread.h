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

#pragma once

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
