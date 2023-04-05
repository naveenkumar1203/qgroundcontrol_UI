#include "Database.h"

static QString mail_from_db; // loginexistinguser
static QString password_from_db; // loginexistinguser
QString user_name_from_db; //create_database
static QString number_from_db; // signupexistingusernumber
static QString name_from_db; // signupexistingusername
static QString gmail_from_db; // signupexistingusermail
static QString address_from_db;
static QString locality_from_db;
static QString userpassword_from_db;
static QString industry_from_db;
static QString mobilenumber_from_db;

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
            usernumber_database(mail);
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

void AjayDatabase::update_profile_contents(const QString &industry, const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality, const QString &password)
{
    QSqlQueryModel *use_database = new QSqlQueryModel();
    use_database->setQuery("use QGC_User_Login");

    QSqlQuery profileContents;
    profileContents.prepare("UPDATE UsersLoginInfo SET industry=:industry,name=:name,mail=:mail,address=:address,locality=:locality,password=:password WHERE number=:number");
    //profileContents.prepare("UPDATE UsersLoginInfo SET name=:name WHERE number=:number");
    profileContents.bindValue(":industry",industry);
    profileContents.bindValue(":name",name);
    profileContents.bindValue(":mail",mail);
    profileContents.bindValue(":address",address);
    profileContents.bindValue(":locality",locality);
    profileContents.bindValue(":password",password);
    profileContents.bindValue(":number",number);
    qDebug()<<industry + name + mail + address + number + locality + password;

    if(!profileContents.exec()){
        //qDebug()<<queryString;
        qDebug()<<"error in updating profile_contents";
    }
    usernumber_database(mail);

}

/*void AjayDatabase::address(const QString &address)
{
    QSqlQuery searchAddress;
    searchAddress.prepare("SELECT address FROM UsersLoginInfo WHERE address = :address");
    searchAddress.bindValue(":address",address);

    if(!searchAddress.exec()){
        qDebug()<<"error while searching address";
    }

    if(searchAddress.exec()){
        while (searchAddress.next()) {
            address_from_db = searchAddress.value(0).toString();
            m_address = address_from_db;
        }
    }
}

void AjayDatabase::locality(const QString &locality)
{
    QSqlQuery searchLocality;
    searchLocality.prepare("SELECT locality FROM UsersLoginInfo WHERE locality = :locality");
    searchLocality.bindValue(":locality",locality);

    if(!searchLocality.exec()){
        qDebug()<<"error while searching locality";
    }

    if(searchLocality.exec()){
        while (searchLocality.next()) {
            locality_from_db = searchLocality.value(0).toString();
            m_locality = locality_from_db;
        }
    }
}

void AjayDatabase::number(const QString &number)
{
    QSqlQuery searchNumber;
    searchNumber.prepare("SELECT number FROM UsersLoginInfo WHERE number = :number");
    searchNumber.bindValue(":number",number);

    if(!searchNumber.exec()){
        qDebug()<<"error while searching number";
    }

    if(searchNumber.exec()){
        while (searchNumber.next()) {
            mobilenumber_from_db = searchNumber.value(0).toString();
            m_number = mobilenumber_from_db;
        }
    }
}

void AjayDatabase::password(const QString &password)
{
    QSqlQuery searchPassword;
    searchPassword.prepare("SELECT password FROM UsersLoginInfo WHERE password = :password");
    searchPassword.bindValue(":password",password);

    if(!searchPassword.exec()){
        qDebug()<<"error while searching password";
    }

    if(searchPassword.exec()){
        while (searchPassword.next()) {
            userpassword_from_db = searchPassword.value(0).toString();
            m_password = userpassword_from_db;
        }
    }
}*/



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


void AjayDatabase::usernumber_database(const QString &mail){
    qDebug()<<("called here");
    QSqlQuery searchNumber;
    searchNumber.prepare("SELECT industry,number,address,locality,password,name FROM UsersLoginInfo WHERE mail = :mail");
    searchNumber.bindValue(":mail",mail);
    if(!searchNumber.exec()){
        qDebug()<<("error in username");
    }

    if(searchNumber.exec()){
        while (searchNumber.next()) {
            industry_from_db = searchNumber.value(0).toString();
            m_industry = industry_from_db;
            mobilenumber_from_db = searchNumber.value(1).toString();
            m_number = mobilenumber_from_db;
            address_from_db = searchNumber.value(2).toString();
            m_address = address_from_db;
            locality_from_db = searchNumber.value(3).toString();
            m_locality = locality_from_db;
            userpassword_from_db = searchNumber.value(4).toString();
            m_password = userpassword_from_db;
            user_name_from_db = searchNumber.value(5).toString();
            m_name = user_name_from_db;
        }
        qDebug()<<("username "+m_number);
    }

    QSqlQuery createDataBase;
    QString query = "create database "+ mobilenumber_from_db;
    createDataBase.prepare(query);
    if(!createDataBase.exec()){
        //qDebug()<<query;
        qDebug()<<"error in creating a database";
    }

    QSqlQuery useDataBase;
    QString query2 = "use " + mobilenumber_from_db;
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
