#include "RpaDatabase.h"
#include "QDebug"


RpaDatabase::RpaDatabase(QObject *parent) : QSqlQueryModel(parent)
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("logdata.cbgenywwv2vb.ap-south-1.rds.amazonaws.com");
    db.setUserName("admin");
    db.setPassword("admin123");


    if(!db.open()){
        qDebug() << "Connection to mysql failed";

    }

    QSqlQueryModel *database_creation = new QSqlQueryModel();
    database_creation->setQuery("create database RpaInformation");

    QSqlQueryModel *use_database = new QSqlQueryModel();
    use_database->setQuery("use RpaInformation");

    QSqlQueryModel *create_table = new QSqlQueryModel();
    create_table->setQuery("create table RpaList(TYPE text,MODEL_NAME text, DRONE_NAME text, UIN text)");
}

QHash<int, QByteArray> RpaDatabase::roleNames() const
{
    // Important that you set this
    // Else display will not work in QML

    return {{Qt::DisplayRole, "display"}};
}

void RpaDatabase::callSql(QString queryString)
{
    //qDebug()<< "I am here";
    this->setQuery(queryString);
}

void RpaDatabase::generateRoleNames()
{
    m_roleNames.clear();
//    for( int i = 0; i < record().count(); i ++) {
//        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
//    }
}

void RpaDatabase::addData(const QString &TYPE,const QString &MODEL_NAME, const QString &DRONE_NAME, const QString &UIN)
{
    QSqlQuery insertData;
    insertData.prepare("insert into RpaList(TYPE, MODEL_NAME, DRONE_NAME, UIN) values(?,?,?,?)");
    insertData.addBindValue(TYPE);
    insertData.addBindValue(MODEL_NAME);
    insertData.addBindValue(DRONE_NAME);
    insertData.addBindValue(UIN);

    if(!insertData.exec()){
        qDebug()<<"error while inserting values";
    }

//    QSqlQueryModel *create_table = new QSqlQueryModel();
//    create_table->setQuery("select * from RpaList");

//    QTableView *view = new QTableView;
//    view->setModel(create_table);
//    view->show();
}
