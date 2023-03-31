#include "Database.h"

static QString mail_from_db;
static QString password_from_db;
QString user_name_from_db;
static QString number_from_db;
static QString name_from_db;
static QString gmail_from_db;

QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");

AjayDatabase::AjayDatabase(QObject *parent) : QObject(parent)
{
    //QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
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

    if(!searchMail.exec()){
        qDebug()<<"error while searching mail";
    }
    if(!searchPassword.exec()){
        qDebug()<<"error while searching password";
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

    if(mail_from_db == mail){
        if(password_from_db == password){
            username_database(mail);
            //emit record_found();
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

void AjayDatabase::signupExistingUsername(const QString &name)
{

    QSqlQuery searchName;
    searchName.prepare("SELECT name FROM UsersLoginInfo WHERE name = :name");
    searchName.bindValue(":name",name);

    if(!searchName.exec()){
        qDebug()<<"error while searching name";
    }

    if(searchName.exec()){
        while (searchName.next()) {
            name_from_db = searchName.value(0).toString();
        }
    }

    if(name_from_db == name){
        emit name_record_found();
        qDebug()<<"Given Name is already registered";
    }

}

void AjayDatabase::signupExistingUsermail(const QString &mail)
{
    QSqlQuery searchMail;
    searchMail.prepare("SELECT mail FROM UsersLoginInfo WHERE mail = :mail");
    searchMail.bindValue(":mail",mail);

    if(!searchMail.exec()){
        qDebug()<<"error while searching mail";
    }

    if(searchMail.exec()){
        while (searchMail.next()) {
            gmail_from_db = searchMail.value(0).toString();
        }
    }

    if((gmail_from_db == mail)){
        emit mail_record_found();
        qDebug()<<"Given Mail is already registered";
    }

}

void AjayDatabase::signupExistingUsernumber(const QString &number)
{
    QSqlQuery searchNumber;
    searchNumber.prepare("SELECT number FROM UsersLoginInfo WHERE number = :number");
    searchNumber.bindValue(":number",number);

    if(!searchNumber.exec()){
        qDebug()<<"error while searching number";
    }

    if(searchNumber.exec()){
        while (searchNumber.next()) {
            number_from_db = searchNumber.value(0).toString();
        }
    }

    if(number_from_db == number){
        emit number_record_found();
        qDebug()<<"Given Number is already registered";
    }
}

void AjayDatabase::logout()
{
    db.removeDatabase("QMYSQL");
    db.close();
    emit close_database();
    if(db.isOpen()){
        qDebug()<<"The database is still open";
    }
    else{
        qDebug()<<"the database is closed";
    }

    db.open();
    QSqlQuery *query = new QSqlQuery(db);
    query->prepare("use QGC_User_Login");
    if(!query->exec()){
        qDebug()<<"The database is closed again";
    }
    else {
        qDebug()<<"The database is opened again";
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


void AjayDatabase::username_database(const QString &mail){
    QSqlQuery searchName;
    searchName.prepare("SELECT name FROM UsersLoginInfo WHERE mail = :mail");
    searchName.bindValue(":mail",mail);

    if(searchName.exec()){
        while (searchName.next()) {
            user_name_from_db = searchName.value(0).toString();
            m_name = user_name_from_db;
        }
        qDebug()<<("username "+m_name);
    }

    QSqlQuery createDataBase;
    QString query = "create database "+ user_name_from_db;
    createDataBase.prepare(query);
    if(!createDataBase.exec()){
        //qDebug()<<query;
        qDebug()<<"error in creating a database";
    }

    QSqlQuery useDataBase;
    QString query2 = "use " + user_name_from_db;
    useDataBase.prepare(query2);
    if(!useDataBase.exec()){
        qDebug()<<query2;
        qDebug()<<"error in using a database";
    }

    QSqlQueryModel *create_table = new QSqlQueryModel();
    create_table->setQuery("create table RpaList(TYPE text,MODEL_NAME text, DRONE_NAME text, UIN text)");


    emit record_found();
}

QString AjayDatabase::name() const
{
    return m_name;
}

void AjayDatabase::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}
