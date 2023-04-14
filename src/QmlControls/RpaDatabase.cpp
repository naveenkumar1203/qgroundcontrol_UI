#include "RpaDatabase.h"
#include "QDebug"

static QString uin_from_db;
static QString model_from_db;
static QString name_from_db;
static QString type_from_db;
static QString uin_from_db_first;


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

void RpaDatabase::checkboxSqlfly(QString queryString)
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
            uin_from_db_first = check.value(1).toString();
            m_model = model_from_db;
            //m_model = "";
            m_uin = uin_from_db_first;
        }
    }
    qDebug()<<m_model;
}

void RpaDatabase::checkboxSqledit(QString queryString)
{
    QSqlQuery check;
    check.prepare(queryString);
    if(!check.exec()){
        qDebug()<<queryString;
        qDebug()<<"error in searching a database";
    }
    if(check.exec()){
        while (check.next()) {
            type_from_db = check.value(0).toString();
            m_type = type_from_db;
            model_from_db = check.value(1).toString();
            m_model = model_from_db;
            name_from_db = check.value(2).toString();
            m_droneName = name_from_db;
            uin_from_db_first = check.value(3).toString();
            m_uin = uin_from_db_first;
        }
    }
    qDebug()<<m_type;
    qDebug()<<m_model;
    qDebug()<<m_droneName;
    qDebug()<<m_uin;
}

void RpaDatabase::update_table_contents(const QString &TYPE,const QString &MODEL_NAME, const QString &DRONE_NAME, const QString &UIN)
{
    QSqlQuery tableContents;
    //UPDATE UsersLoginInfo SET password="wd" WHERE mail="w";
    tableContents.prepare("UPDATE RpaList SET TYPE=:TYPE,MODEL_NAME=:MODEL_NAME,DRONE_NAME=:DRONE_NAME WHERE UIN=:UIN");
    tableContents.bindValue(":TYPE",TYPE);
    tableContents.bindValue(":MODEL_NAME",MODEL_NAME);
    tableContents.bindValue(":DRONE_NAME",DRONE_NAME);
    tableContents.bindValue(":UIN",UIN);
    qDebug()<<TYPE;
    qDebug()<<MODEL_NAME;
    qDebug()<<DRONE_NAME;
    qDebug()<<UIN;

    if(!tableContents.exec()){
        qDebug()<<"error while updating contents";
    }

}

void RpaDatabase::delete_table_contents(QString number) //queryString
{
//    QSqlQuery deleteContents;
//    deleteContents.prepare(queryString);
//    qDebug()<<queryString;
//    //deleteContents.prepare("delete from RpaList where UIN:"+uin_from_db_first);

//    if(!deleteContents.exec()){
//        qDebug()<<deleteContents.lastError();
//        qDebug()<<"error while deleting";
//    }
    QString uin_number;
    QSqlQuery searchquery;
    QString searchquerystring = "SELECT uin FROM RpaList limit " + number;
    searchquery.prepare(searchquerystring);
    if(searchquery.exec()){
        while(searchquery.next()){
            uin_number  = searchquery.value(0).toString();
        }
    }
    if(!searchquery.exec()){
        qDebug()<<"unable to execute search query";
    }

    QSqlQuery deletequery;
    QString deletequerystring1 = "DELETE FROM RpaList where UIN='" + uin_number + "'";
    qDebug()<<deletequerystring1;
    deletequery.prepare(deletequerystring1);

    if(!deletequery.exec()){
        qDebug()<<"unable to execute delete query";
    }
}

QString RpaDatabase::type() const
{
    return m_type;
}

void RpaDatabase::setType(const QString &newType)
{
    if (m_type == newType)
        return;
    m_type = newType;
    emit typeChanged();
}

QString RpaDatabase::model() const
{
    return model_from_db;//m_model;
}

void RpaDatabase::setModel(const QString &newModel)
{
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}

QString RpaDatabase::droneName() const
{
    return m_droneName;
}

void RpaDatabase::setDroneName(const QString &newDroneName)
{
    if (m_droneName == newDroneName)
        return;
    m_droneName = newDroneName;
    emit droneNameChanged();
}
QString RpaDatabase::uin() const
{
    return uin_from_db_first;//m_uin;
}

void RpaDatabase::setUin(const QString &newUin)
{
    if (m_uin == newUin)
        return;
    m_uin = newUin;
    emit uinChanged();
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










