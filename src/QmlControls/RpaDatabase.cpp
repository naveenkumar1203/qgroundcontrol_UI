#include "RpaDatabase.h"
#include "QDebug"

static QString uin_from_db;
static QString model_from_db;


RpaDatabase::RpaDatabase(QObject *parent) : QSqlQueryModel(parent)
{

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

void RpaDatabase::checkboxSql(QString queryString)
{
    QSqlQuery check;
    check.prepare(queryString);
    if(!check.exec()){
        qDebug()<<queryString;
        qDebug()<<"error in searching a database";
    }
    if(check.exec()){
        while (check.next()) {
            model_from_db = check.value(0).toString();
            m_model = model_from_db;
        }
    }
    qDebug()<<model_from_db;
}

QString RpaDatabase::model() const
{
    return m_model;
}

void RpaDatabase::setModel(const QString &newModel)
{
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}

void RpaDatabase::generateRoleNames()
{
    m_roleNames.clear();

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

}

void RpaDatabase::existingUIN(const QString &UIN)
{
    QSqlQuery searchUin;
    searchUin.prepare("SELECT UIN FROM RpaList WHERE UIN = :UIN");
    searchUin.bindValue(":UIN",UIN);

    if(!searchUin.exec()){
        qDebug()<<"error while searching UIN";
    }

    if(searchUin.exec()){
        while (searchUin.next()) {
            uin_from_db = searchUin.value(0).toString();
        }
    }

    if(uin_from_db == UIN){
        emit uin_record_found();
        qDebug()<<"Given UIN is already used.";
    }
    else{
        emit uin_record_notfound();
    }
}




