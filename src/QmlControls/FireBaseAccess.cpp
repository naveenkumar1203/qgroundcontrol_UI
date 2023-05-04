#include "FireBaseAccess.h"

#include <QVariantMap>

FireBaseAccess::FireBaseAccess(QObject *parent)
    : QObject{parent}
{
    m_NetworkAccessManager = new QNetworkAccessManager(this);
}

FireBaseAccess::~FireBaseAccess()
{
    m_NetworkAccessManager->deleteLater();
}

void FireBaseAccess::new_user_registration(const QString &industry,const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality, const QString &password)
{
    QVariantMap newUser;
    newUser["Mail"] = mail;

    QVariantMap newUserDetails;
    newUserDetails["Name"] = name;
    newUserDetails["Mail"] = mail;
    newUserDetails["Number"] = number;
    newUserDetails["Address"] = address;
    newUserDetails["Locality"] = locality;
    newUserDetails["Industry"] = industry;
    //newUserDetails["Password"] = industry;

    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newUser);
    QJsonDocument jsonDoc1 = QJsonDocument::fromVariant(newUserDetails);

    //QNetworkRequest newAdditionRequest(QUrl("https://trial-cast-default-rtdb.asia-southeast1.firebasedatabase.app/.json"));
    //newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    //m_NetworkAccessManager->post(newAdditionRequest,jsonDoc.toJson());

    QString user_mail = mail;
    int pos = user_mail.lastIndexOf("@gmail.com");
    //qDebug() << user_mail.left(pos);
    user_mail = user_mail.left(pos);
    //qDebug() << "user_mail" <<user_mail;

    QString link = "https://trial-cast-default-rtdb.asia-southeast1.firebasedatabase.app/" + user_mail + "/UserInformation.json";
    QUrl userUrl = link;
    QNetworkRequest newAdditionRequest((QUrl(userUrl)));
    newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    m_NetworkAccessManager->put(newAdditionRequest,jsonDoc1.toJson());

    m_NetworkReply = m_NetworkAccessManager->get(QNetworkRequest(QUrl("https://trial-cast-default-rtdb.asia-southeast1.firebasedatabase.app/.json")));
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::rds_data_network_reply_read);

    new_user_account_creation(mail,password);
}

void FireBaseAccess::rds_data_network_reply_read()
{
    qDebug()<<m_NetworkReply->readAll();
}

void FireBaseAccess::new_user_account_creation(const QString &email, const QString &password)
{
    QString api = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="+ m_apikey;

    QVariantMap payload;
    payload["email"] = email;
    payload["password"] = password;
    payload["returnSecureToken"] = true;

    QJsonDocument json = QJsonDocument::fromVariant(payload);
    new_user_POST(api, json);
}

void FireBaseAccess::new_user_POST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest new_request((QUrl(url)));
    new_request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_NetworkReply = m_NetworkAccessManager->post(new_request,payload.toJson());
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::new_user_network_reply_read);
}

void FireBaseAccess::new_user_network_reply_read()
{
    //qDebug()<<m_NetworkReply->readAll();
    QByteArray response = m_NetworkReply->readAll();
    m_NetworkReply->deleteLater();
    newUser_parseResponse(response);
}

void FireBaseAccess::newUser_parseResponse(const QByteArray &response)
{
    qDebug()<<"inside newUser_parseResponse";
    //qDebug()<<"response:"<<response;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    if(jsonDocument.object().contains("error")){
        //qDebug()<<"error occured:"<<response;
        emit mailAlreadyExists();
        //        QString errorString = QString(response);
        //        if(errorString.contains("INVALID_EMAIL")){
        //            emit invalidEmail();
        //        }
    }
    else if(jsonDocument.object().contains("kind")){
        emit userRegisteredSuccessfully();
    }
}

void FireBaseAccess::registered_user(const QString &mail, const QString &password)
{
    QString user_mail = mail;
    int pos = user_mail.lastIndexOf("@gmail.com");
    user_mail = user_mail.left(pos);
    m_firebasejsonname = user_mail;
    registered_user_signup(mail,password);
}

void FireBaseAccess::registered_user_signup(const QString &email, const QString &password)
{
    QString api = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="+ m_apikey;

    QVariantMap payload;
    payload["email"] = email;
    payload["password"] = password;
    payload["returnSecureToken"] = true;

    QJsonDocument json = QJsonDocument::fromVariant(payload);
    registered_user_POST(api, json);
}

void FireBaseAccess::registered_user_POST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest new_request((QUrl(url)));
    new_request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_NetworkReply = m_NetworkAccessManager->post(new_request,payload.toJson());
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::registered_user_network_reply_read);
}

void FireBaseAccess::registered_user_network_reply_read()
{
    //qDebug()<<m_NetworkReply->readAll();
    QByteArray response = m_NetworkReply->readAll();
    //newUser_parseResponse(response);
    m_NetworkReply->deleteLater();
    registeredUser_parseResponse(response);
}

void FireBaseAccess::registeredUser_parseResponse(const QByteArray &response)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    if(jsonDocument.object().contains("error")){
        //qDebug()<<"error occured:"<<response;
        QString errorString = QString(response);
        //qDebug()<<DataAsString;
        if(errorString.contains("EMAIL_NOT_FOUND")){
            emit emailNotFound();
        }
        else if(errorString.contains("INVALID_PASSWORD")){
            emit incorrectPassword();
        }
    }
    else if(jsonDocument.object().contains("kind")){
        QString user_link = "https://trial-cast-default-rtdb.asia-southeast1.firebasedatabase.app/" + m_firebasejsonname + "/UserInformation.json";
        m_NetworkReply = m_NetworkAccessManager->get(QNetworkRequest(QUrl(user_link)));
        connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::user_details_network_reply_read);
        //connect(m_NetworkReply1,SIGNAL(finished()),this,SLOT(user_details_network_reply_read()));
        //qDebug()<<"firebase json name"<<m_firebasejsonname;
        //emit successfullLogin();
    }
}

void FireBaseAccess::user_details_network_reply_read()
{
    //qDebug()<<"user data:" <<m_NetworkReply1->readAll();
    QByteArray response = m_NetworkReply->readAll();
    m_NetworkReply->deleteLater();
    userDetails_parseResponse(response);
}

void FireBaseAccess::userDetails_parseResponse(const QByteArray &response)
{
    QJsonDocument doc = QJsonDocument::fromJson(response);
    if (doc.isNull()) {
        qDebug()<<"THIS DOC DOES NOT CONTAIN ANY OBJECT"<<doc;

    }
    //qDebug()<<"doc:"<<doc;
    QJsonObject obj = doc.object();
    //QString name = obj["Name"].toString();
    //m_name = name;
    //QString address = obj["Address"].toString();
    //QString industry = obj["Industry"].toString();
    //QString locality = obj["Locality"].toString();
    //QString number = obj["Number"].toString();
    //QString mail = obj["Mail"].toString();
    //qDebug()<<m_name<<address<<industry<<locality<<number<<mail;
    m_name = obj["Name"].toString();
    m_address = obj["Address"].toString();
    m_locality = obj["Locality"].toString();
    m_number = obj["Number"].toString();
    m_mail = obj["Mail"].toString();
    emit successfullLogin();
}

void FireBaseAccess::reset_password(const QString &email)
{
    QString api = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key="+ m_apikey;

    QVariantMap payload;
    payload["requestType"] = "PASSWORD_RESET";
    payload["email"] = email;

    QJsonDocument json = QJsonDocument::fromVariant(payload);
    password_reset_POST(api, json);
}

void FireBaseAccess::password_reset_POST(const QString &url, const QJsonDocument &payload)
{
    QNetworkRequest new_request((QUrl(url)));
    new_request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json"));
    m_NetworkReply = m_NetworkAccessManager->post(new_request,payload.toJson());
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::reset_password_network_reply_read);
}

void FireBaseAccess::reset_password_network_reply_read()
{
    //qDebug()<<m_NetworkReply->readAll();
    QByteArray response = m_NetworkReply->readAll();
    m_NetworkReply->deleteLater();
    password_reset_parseResponse(response);
}

void FireBaseAccess::password_reset_parseResponse(const QByteArray &response)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    if(jsonDocument.object().contains("error")){
        emit resetMailNotFound();
    }
    else if(jsonDocument.object().contains("kind")){
        emit resetMailFound();
    }
}

QString FireBaseAccess::name() const
{
    return m_name;
}

void FireBaseAccess::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

QString FireBaseAccess::firebasejsonname() const
{
    return m_firebasejsonname;
}

void FireBaseAccess::setFirebasejsonname(const QString &newFirebasejsonname)
{
    if (m_firebasejsonname == newFirebasejsonname)
        return;
    m_firebasejsonname = newFirebasejsonname;
    emit firebasejsonnameChanged();
}

QString FireBaseAccess::industry() const
{
    return m_industry;
}

void FireBaseAccess::setindustry(const QString &newIndustry)
{
    if (m_industry == newIndustry)
        return;
    m_industry = newIndustry;
    emit industryChanged();
}

QString FireBaseAccess::mail() const
{
    return m_mail;
}

void FireBaseAccess::setMail(const QString &newMail)
{
    if (m_mail == newMail)
        return;
    m_mail = newMail;
    emit mailChanged();
}

QString FireBaseAccess::number() const
{
    return m_number;
}

void FireBaseAccess::setNumber(const QString &newNumber)
{
    if (m_number == newNumber)
        return;
    m_number = newNumber;
    emit numberChanged();
}

QString FireBaseAccess::address() const
{
    return m_address;
}

void FireBaseAccess::setAddress(const QString &newAddress)
{
    if (m_address == newAddress)
        return;
    m_address = newAddress;
    emit addressChanged();
}

QString FireBaseAccess::locality() const
{
    return m_locality;
}

void FireBaseAccess::setLocality(const QString &newLocality)
{
    if (m_locality == newLocality)
        return;
    m_locality = newLocality;
    emit localityChanged();
}
