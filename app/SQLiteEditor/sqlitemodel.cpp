#include "sqlitemodel.h"

SQLiteModel::SQLiteModel(QObject *parent) :
    QAbstractListModel(parent),
    m_databaseFilePath(""),
    m_query(""),
    m_status(Null)
{
    //    connect(this, SIGNAL(databaseFilePathChanged(QUrl)),
    //            this, SLOT(openDatabase(QUrl)));

        connect(this, SIGNAL(databaseFilePathChanged(QUrl)),
                this, SLOT(createThread(QUrl)));
}

SQLiteModel::~SQLiteModel()
{
    m_dbThread->terminate();
}


int SQLiteModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_modelData.count();
}

QVariant SQLiteModel::data(const QModelIndex &index, int role) const
{
    if(index.isValid())
    {
        QHash<int, QByteArray> _roles = this->roleNames();
        QString _key = _roles.value(role);
        if((index.row() <= m_modelData.count() - 1) && index.row() >= 0)
        {
            QMap<QString, QString > _dataMap = m_modelData.at(index.row());
            return QVariant(_dataMap.value(_key));
        }
    }
    return QVariant();
}

void SQLiteModel::createThread(QUrl databaseFilePath)
{
    if(m_dbThread && m_dbThread->isRunning())
    {
        dbThreadStarted();
    } else
    {
        // TODO set database file path
        m_dbThread = new DbThread(this, databaseFilePath.toString(QUrl::RemoveScheme));
        connect( m_dbThread, SIGNAL( results( const QList<QSqlRecord>& ) ),
                 this, SLOT( slotResults( const QList<QSqlRecord>& ) ) );
        connect( m_dbThread, SIGNAL(started()), this, SLOT(dbThreadStarted()));
        m_dbThread->start();
    }

}
void SQLiteModel::dbThreadStarted()
{
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

void SQLiteModel::executeQuery(QString queryStatement)
{
    executionTimer.restart();
    setStatus(Loading);
    m_dbThread->execute(queryStatement);
}

void SQLiteModel::slotResults(const QList<QSqlRecord>& sqlRecords)
{
    {
        // Clear all data and signal rows to update
        int count = m_modelData.count();
        beginInsertRows(QModelIndex(), 0, count - 1);
        m_modelData.clear();
        endInsertRows();
    }
    bool rolesSet = false;
    QListIterator<QSqlRecord> sqlRecordsIterator(sqlRecords);
    while(sqlRecordsIterator.hasNext())
    {
        QSqlRecord sqlRecord = sqlRecordsIterator.next();
        if(!rolesSet)
        {
            // Set the Roles for QAbstractListModel
            m_roleNames.clear();
            m_roleNames = roleNames();
            for(int column = 0; column < sqlRecord.count(); column++)
            {
                QString columnName = sqlRecord.fieldName(column);
                // Create Roles with the field names
                m_roleNames.insert( Qt::UserRole + 1 + column,
                                    QByteArray(columnName.toUtf8()));
                //qDebug() << __PRETTY_FUNCTION__ << columnName;
            }
            rolesSet = true;
//            doSetRoleNames(m_roleNames);
        }
        QMap<QString,QString> dataMap;
        for(int column = 0; column < sqlRecord.count(); column++)
        {
            dataMap.insert(sqlRecord.fieldName(column), sqlRecord.value(column).toString());
        }
        m_modelData.append(dataMap);
    }
    {
        beginInsertRows(QModelIndex(), 0, m_modelData.count() - 1);
        endInsertRows();
        emit countChanged(getCount());
        setStatus(Ready);
    }
    qDebug() << __PRETTY_FUNCTION__ << "Query And Populating Model took " << executionTimer.elapsed() << "ms";
}

QVariant SQLiteModel::get(int index)
{
    if(index < 0 || index >= m_modelData.count())
        return QVariant();
    QMap<QString,QVariant> dataMap;
    QMapIterator<QString,QString> i(m_modelData.at(index));
    while(i.hasNext())
    {
        i.next();
        dataMap.insert(i.key(),QVariant(i.value()));
    }
    return QVariant(dataMap);
}
