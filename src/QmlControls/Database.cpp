#include "Database.h"
#include <QMessageBox>

static QString mail_from_db; // loginexistinguser
static QString password_from_db; // loginexistinguser
QString user_name_from_db; //create_database
static QString number_from_db; // signupexistingusernumber
static QString name_from_db; // signupexistingusername
static QString gmail_from_db; // signupexistingusermail
static QString address_from_db;
static QString locality_from_db;
static QString userpassword_from_db;
static QString mobilenumber_from_db;
//static QString previous_username;
//QString profilename_from_db;
QString profilemail_from_db;
//QString profilenumber_from_db;
QString forgotmail_from_db;

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
        QMessageBox msgbox;
        msgbox.setText("Connection Not Established. Please Check Your Internet Connection.");
        msgbox.setStyleSheet("color:white;background:#05324D");
        msgbox.setDefaultButton(QMessageBox::Ok);
        msgbox.exec();
        //emit connection_not_established();
    }

    QSqlQueryModel *database_creation = new QSqlQueryModel();
    database_creation->setQuery("create database QGC_User_Login");

    QSqlQueryModel *use_database = new QSqlQueryModel();
    use_database->setQuery("use QGC_User_Login");

    QSqlQueryModel *create_table = new QSqlQueryModel();
    create_table->setQuery("create table UsersLoginInfo(industry text,name text,mail text,number int,address text,locality text,password text)");

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
            m_mail = mail_from_db;
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
        qDebug()<<searchName.lastError();
        qDebug()<<"error while searching name";
    }

    if(searchName.exec()){
        while (searchName.next()) {
            name_from_db = searchName.value(0).toString();
            m_name = name_from_db;
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
            m_number = number_from_db;
        }
    }

    if(number_from_db == number){
        emit number_record_found();
        qDebug()<<"Given Number is already registered";
    }
}

/*void AjayDatabase::existingUserProfilename(const QString &name)
{

    QSqlQuery *query = new QSqlQuery();
    query->prepare("use QGC_User_Login");
    if(!query->exec()){
        qDebug()<<"database not changed";
    }

    QSqlQuery searchName;
    searchName.prepare("SELECT name FROM UsersLoginInfo WHERE name = :name");
    searchName.bindValue(":name",name);

    if(!searchName.exec()){
        qDebug()<<"error while searching profilename";
    }

    if(searchName.exec()){
        while (searchName.next()) {
            profilename_from_db = searchName.value(0).toString();
            //m_name = profilename_from_db;
        }
    }

    if(profilename_from_db == name){
        emit name_record_found();
        qDebug()<<"Entered Name is already Used";
    }
}*/

void AjayDatabase::existingUserProfilemail(const QString &mail)
{
    QSqlQuery *query = new QSqlQuery();
    query->prepare("use QGC_User_Login");
    if(!query->exec()){
        qDebug()<<"database not changed";
    }

    QSqlQuery searchMail;
    searchMail.prepare("SELECT mail FROM UsersLoginInfo WHERE mail = :mail");
    searchMail.bindValue(":mail",mail);

    if(!searchMail.exec()){
        qDebug()<<"error while searching profilemail";
    }

    if(searchMail.exec()){
        while (searchMail.next()) {
            profilemail_from_db = searchMail.value(0).toString();
            //m_mail = profilemail_from_db;
        }
    }

    if(profilemail_from_db == mail){
        emit mail_record_found();
        qDebug()<<"Entered Mail is already Used";
    }
}

void AjayDatabase::forgotPasswordmail(const QString &mail)
{
    QSqlQuery searchMail;
    searchMail.prepare("SELECT mail FROM UsersLoginInfo WHERE mail = :mail");
    searchMail.bindValue(":mail",mail);

    if(!searchMail.exec()){
        qDebug()<<searchMail.lastError();
        qDebug()<<"error while searching profile mail";
    }

    if(searchMail.exec()){
        while (searchMail.next()) {
            forgotmail_from_db = searchMail.value(0).toString();
            m_mail = forgotmail_from_db;
        }
    }

    if(forgotmail_from_db != mail){
        emit forgotmail_record_notfound();
        qDebug()<<"Entered Mail is not correct";
    }
}

/*void AjayDatabase::existingUserProfilenumber(const QString &number)
{
    QSqlQuery *query = new QSqlQuery();
    query->prepare("use QGC_User_Login");
    if(!query->exec()){
        qDebug()<<"database not changed";
    }

    QSqlQuery searchNumber;
    searchNumber.prepare("SELECT number FROM UsersLoginInfo WHERE number = :number");
    searchNumber.bindValue(":number",number);

    if(!searchNumber.exec()){
        qDebug()<<"error while searching profilenumber";
    }

    if(searchNumber.exec()){
        while (searchNumber.next()) {
            profilenumber_from_db = searchNumber.value(0).toString();
            m_number = profilenumber_from_db;
        }
    }

    if(profilenumber_from_db == number){
        emit number_record_found();
        qDebug()<<"Entered Number is already Used";
    }
}*/

void AjayDatabase::update_profile_contents(const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality, const QString &password)
{
    QSqlQueryModel *use_database = new QSqlQueryModel();
    use_database->setQuery("use QGC_User_Login");

    QSqlQuery profileContents;
    profileContents.prepare("UPDATE UsersLoginInfo SET name=:name,mail=:mail,address=:address,locality=:locality,password=:password WHERE number=:number");
    //profileContents.prepare("UPDATE UsersLoginInfo SET name=:name WHERE number=:number");
    profileContents.bindValue(":name",name);
    profileContents.bindValue(":mail",mail);
    profileContents.bindValue(":address",address);
    profileContents.bindValue(":locality",locality);
    profileContents.bindValue(":password",password);
    profileContents.bindValue(":number",number);

    if(!profileContents.exec()){
        //qDebug()<<queryString;
        qDebug()<<"error in updating profile_contents";
    }
    username_database(mail);

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
        db.setHostName("logdata.cbgenywwv2vb.ap-south-1.rds.amazonaws.com");
        db.setUserName("admin");
        db.setPassword("admin123");

        if(db.open()){
            qDebug()<<"connection opened";
        }
        else if(!db.open()){
            qDebug()<<"connection not opened";
            emit connectionNotopened();
        }

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


void AjayDatabase::username_database(const QString &mail){ //,const int flag

    qDebug()<<("called here");
    QSqlQuery searchName;
    searchName.prepare("SELECT number,address,locality,password,name FROM UsersLoginInfo WHERE mail = :mail");
    searchName.bindValue(":mail",mail);
    if(!searchName.exec()){
        qDebug()<<("error in username");
    }

    if(searchName.exec()){
        while (searchName.next()) {
            mobilenumber_from_db = searchName.value(0).toString();
            m_number = mobilenumber_from_db;
            address_from_db = searchName.value(1).toString();
            m_address = address_from_db;
            locality_from_db = searchName.value(2).toString();
            m_locality = locality_from_db;
            userpassword_from_db = searchName.value(3).toString();
            m_password = userpassword_from_db;
            user_name_from_db = searchName.value(4).toString();
            m_name = user_name_from_db;
        }
        qDebug()<<("username "+m_name);
    }

    QSqlQuery createDataBase;
    QString query = "create database "+ user_name_from_db;
    createDataBase.prepare(query);
    if(!createDataBase.exec()){
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

    QSqlQueryModel *create_table1 = new QSqlQueryModel();
    create_table1->setQuery("create table FirmwareLog(Info text,Date text,Time text)");

    emit record_found();

    /*if(flag == 0){
        previous_username = user_name_from_db;
        QSqlQuery createDataBase;
        QString query = "create database "+ user_name_from_db;
        createDataBase.prepare(query);
        if(!createDataBase.exec()){
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

        QSqlQueryModel *create_table1 = new QSqlQueryModel();
        create_table1->setQuery("create table FirmwareLog(Info text,Date text,Time text)");

        emit record_found();
    }
    if(flag == 1){
        QSqlQueryModel *database_creation = new QSqlQueryModel();
        database_creation->setQuery("create database "+user_name_from_db);

        qDebug()<<previous_username + user_name_from_db;

        QString query = "rename table "+ previous_username + ".RpaList to " + user_name_from_db + ".RpaList";
        QString query1 = "rename table "+ previous_username + ".FirmwareLog to " + user_name_from_db + ".FirmwareLog";
        QString query3 = "drop database "+ previous_username;

        QSqlQuery renameRpatable;
        renameRpatable.prepare(query);
        if(!renameRpatable.exec()){
            qDebug()<<renameRpatable.lastError();
            qDebug()<<"error in renaming table1";
        }

        QSqlQuery renameFirmwaretable;
        renameFirmwaretable.prepare(query1);
        if(!renameFirmwaretable.exec()){
            qDebug()<<renameFirmwaretable.lastError();
            qDebug()<<"error in renaming table2";
        }

        QSqlQuery deleteDatabase;
        deleteDatabase.prepare(query3);
        if(!deleteDatabase.exec()){
            qDebug()<<"error in deleting database";
        }
        previous_username = user_name_from_db;
    }*/
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

QString AjayDatabase::mail() const
{
    return m_mail;
}

void AjayDatabase::setMail(const QString &newMail)
{
    if (m_mail == newMail)
        return;
    m_mail = newMail;
    emit mailChanged();
}

QString AjayDatabase::address() const
{
    return m_address;
}

void AjayDatabase::setAddress(const QString &newAddress)
{
    if (m_address == newAddress)
        return;
    m_address = newAddress;
    emit addressChanged();
}

QString AjayDatabase::locality() const
{
    return m_locality;
}

void AjayDatabase::setLocality(const QString &newLocality)
{
    if (m_locality == newLocality)
        return;
    m_locality = newLocality;
    emit localityChanged();
}

QString AjayDatabase::password() const
{
    return m_password;
}
void AjayDatabase::setPassword(const QString &newPassword)
{
    if (m_password == newPassword)
        return;
    m_password = newPassword;
    emit passwordChanged();
}

QString AjayDatabase::number() const
{
    return m_number;
}
void AjayDatabase::setNumber(const QString &newNumber)
{
    if (m_number == newNumber)
        return;
    m_number = newNumber;
    emit numberChanged();
}

QString AjayDatabase::industry() const
{
    return m_industry;
}

void AjayDatabase::setIndustry(const QString &newIndustry)
{
    if (m_industry == newIndustry)
        return;
    m_industry = newIndustry;
    emit industryChanged();
}

QString AjayDatabase::awsname() const
{
    return user_name_from_db;//m_awsname;
}

void AjayDatabase::setAwsname(const QString &newAwsname)
{
    if (m_awsname == newAwsname)
        return;
    m_awsname = newAwsname;
    emit awsnameChanged();
}
