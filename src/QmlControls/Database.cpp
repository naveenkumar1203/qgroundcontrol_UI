#include "Database.h"

static QString mail_from_db;
static QString password_from_db;
static QString user_name_from_db;

QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");

AjayDatabase::AjayDatabase(QObject *parent) : QObject(parent)
{
//    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("logdata.cbgenywwv2vb.ap-south-1.rds.amazonaws.com");
    db.setUserName("admin");
    db.setPassword("admin123");

    if(db.open()){
        qDebug()<<"connection opened";
    }
    else if(!db.open()){
        qDebug()<<"connection not opened";
    }

    QSqlQueryModel *database_creation = new QSqlQueryModel();
    database_creation->setQuery("create database QGC_User_Login");

    QSqlQueryModel *use_database = new QSqlQueryModel();
    use_database->setQuery("use QGC_User_Login");

    QSqlQueryModel *create_table = new QSqlQueryModel();
    create_table->setQuery("create table UsersLoginInfo(industry text,name text,mail text,number text,address text,locality text,password text)");
}

void AjayDatabase::newUserData(const QString &industry, const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality, const QString &password)
{
    QSqlQuery insertData;
    insertData.prepare("insert into UsersLoginInfo(industry,name,mail,number,address,locality,password) values(?,?,?,?,?,?,?)");
    insertData.addBindValue(industry);
    insertData.addBindValue(name);
    insertData.addBindValue(mail);
    insertData.addBindValue(number);
    insertData.addBindValue(address);
    insertData.addBindValue(locality);
    insertData.addBindValue(password);

    if(!insertData.exec()){
        qDebug()<<"error while inserting values";
    }
}

void AjayDatabase::loginExistingUser(const QString &mail, const QString &password)
{
    QSqlQuery searchMail;
    searchMail.prepare("SELECT mail FROM UsersLoginInfo WHERE mail = :mail");
    searchMail.bindValue(":mail",mail);

    QSqlQuery searchPassword;
    searchPassword.prepare("SELECT password FROM UsersLoginInfo WHERE password = :password");
    searchPassword.bindValue(":password",password);

    QSqlQuery searchName;
    searchName.prepare("SELECT name FROM UsersLoginInfo WHERE mail = :mail");
    searchName.bindValue(":mail",mail);

    if(!searchMail.exec()){
        qDebug()<<"error while searching mail";
    }
    if(!searchPassword.exec()){
        qDebug()<<"error while searching password";
    }
    if(!searchName.exec()){
        qDebug()<<"error while searching name";
    }

    if(searchMail.exec()){
        while (searchMail.next()) {
            mail_from_db = searchMail.value(0).toString();
        }
    }

    if(searchPassword.exec()){
        while (searchPassword.next()) {
            password_from_db = searchPassword.value(0).toString();
        }
    }

    if(searchName.exec()){
        while (searchName.next()) {
            user_name_from_db = searchName.value(0).toString();
        }
    }

    if(mail_from_db == mail){
        if(password_from_db == password){
            emit record_found();
            m_user = mail;
            QSqlQuery create_new_table;
            QString query = "create table "+ user_name_from_db +"(Time text,Roll text)";
            create_new_table.prepare(query);
            qDebug()<<"query table is:"<<query;

            if(!create_new_table.exec()){
                qDebug()<<"error while creating table";
            }
        }
    }
    if(mail_from_db == mail){
        if(password_from_db != password){
            emit incorrect_password();
            qDebug()<<"incorrect password";
        }
    }
    else if(mail_from_db != mail){
        emit no_record_found();
    }
}

void AjayDatabase::change_password(const QString &mail, const QString &newPassword)
{
    QSqlQuery changePassword;
    //UPDATE UsersLoginInfo SET password="wd" WHERE mail="w";
    changePassword.prepare("UPDATE UsersLoginInfo SET password=? WHERE mail=?");
    changePassword.addBindValue(newPassword);
    changePassword.addBindValue(mail);

    if(!changePassword.exec()){
        qDebug()<<"error while updating mail";
    }
}


QString AjayDatabase::user() const
{
    return m_user;
}

void AjayDatabase::setUser(const QString &newUser)
{
    if (m_user == newUser)
        return;
    m_user = newUser;
    emit userChanged();
}

void AjayDatabase::vehicleData(const QString &time, const QString &rollValue)
{
    QSqlQuery insertData;
    QString query = "insert into"+ user_name_from_db +"(Time,Roll) values(?,?)";
    insertData.prepare(query);
    insertData.addBindValue(time);
    insertData.addBindValue(rollValue);
    qDebug()<<"insert query is:"<<query;

    if(!insertData.exec()){
        qDebug()<<"error while inserting vehicle value";
    }
}
