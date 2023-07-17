#include "FireBaseAccess.h"
#include "FirmwareUpgradeController.h"


#include <QVariantMap>

QString g_industry;
QString g_name;
QString g_mail;
QString g_number;
QString g_address;
QString g_locality;
QString g_role;
QString usermail = " ";

QString firebase_storage_name;

FireBaseAccess::FireBaseAccess(QObject *parent)
    : QObject{parent}
{
    m_NetworkAccessManager = new QNetworkAccessManager(this);
}

FireBaseAccess::~FireBaseAccess()
{
    m_NetworkAccessManager->deleteLater();
}

void FireBaseAccess::new_user_registration(const QString &industry,const QString &role,const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality, const QString &password)
{

    g_name = name;
    g_mail = mail;
    g_number = number;
    g_address = address;
    g_locality = locality;
    g_industry = industry;
    g_role = role;


    m_NetworkReply = m_NetworkAccessManager->get(QNetworkRequest(QUrl("https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/.json")));
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::rds_data_network_reply_read);
    qDebug()<<g_name+g_mail+g_number+g_address+g_locality+g_industry+g_role;
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
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    if(jsonDocument.object().contains("error")){
        emit mailAlreadyExists();
    }
    else if(jsonDocument.object().contains("kind")){
            QVariantMap newUser;
            newUser["Mail"] = g_mail;

            QVariantMap newUserDetails;
            newUserDetails["Name"] = g_name;
            newUserDetails["Mail"] = g_mail;
            newUserDetails["Number"] = g_number;
            newUserDetails["Address"] = g_address;
            newUserDetails["Locality"] = g_locality;
            newUserDetails["Industry"] = g_industry;
            newUserDetails["Role"] = g_role;

            QJsonDocument jsonDoc = QJsonDocument::fromVariant(newUser);
            QJsonDocument jsonDoc1 = QJsonDocument::fromVariant(newUserDetails);

            QString user_mail = g_mail;
            //int pos = user_mail.lastIndexOf("@gmail.com");
            int pos = user_mail.lastIndexOf("@");
            user_mail = user_mail.left(pos);
            usermail = user_mail;
            firebase_storage_name = usermail;
            qDebug() << "user_mail" <<user_mail;

            QString link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user_mail + "/UserInformation.json";
            QUrl userUrl = link;
            QNetworkRequest newAdditionRequest((QUrl(userUrl)));
            newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
            m_NetworkAccessManager->put(newAdditionRequest,jsonDoc1.toJson());

            emit userRegisteredSuccessfully();
    }
}

void FireBaseAccess::registered_user(const QString &mail, const QString &password)
{
    QString user_mail = mail;
    //int pos = user_mail.lastIndexOf("@gmail.com");
    int pos = user_mail.lastIndexOf("@");
    user_mail = user_mail.left(pos);
    usermail = user_mail;
    m_firebasejsonname = user_mail;
    firebase_storage_name = m_firebasejsonname;
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
    m_NetworkReply->deleteLater();
    registeredUser_parseResponse(response);
}

void FireBaseAccess::registeredUser_parseResponse(const QByteArray &response)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    if(jsonDocument.object().contains("error")){
        QString errorString = QString(response);
        if(errorString.contains("EMAIL_NOT_FOUND")){
            emit emailNotFound();
        }
        else if(errorString.contains("INVALID_PASSWORD")){
            emit incorrectPassword();
        }
    }
    else if(jsonDocument.object().contains("kind")){
        QString user_link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + m_firebasejsonname + "/UserInformation.json";
        m_NetworkReply = m_NetworkAccessManager->get(QNetworkRequest(QUrl(user_link)));
        connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::user_details_network_reply_read);
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
    m_name = obj["Name"].toString();
    m_address = obj["Address"].toString();
    m_locality = obj["Locality"].toString();
    m_number = obj["Number"].toString();
    m_mail = obj["Mail"].toString();
    m_role = obj["Role"].toString();
    emit successfullLogin();
    emit nameChanged();
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

void FireBaseAccess::update_profile(const QString &name, const QString &mail, const QString &number, const QString &address, const QString &locality)
{
    qDebug()<<"in update_profile";
    m_networkAccessManagerWithPatch = new QNetworkAccessManagerWithPatch(this);
    QVariantMap newAddition;
    newAddition["Name"] = name;
    newAddition["Mail"] = mail;
    newAddition["Number"] = number;
    newAddition["Address"] = address;
    newAddition["Locality"] = locality;
    qDebug()<<"update profile newAddition:"<<newAddition;
    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newAddition);
    qDebug()<<"jsonDoc:"<<jsonDoc;
    QNetworkRequest newAdditionRequest(QUrl("https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + m_firebasejsonname + "/UserInformation.json"));
    newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    m_networkAccessManagerWithPatch->patch(newAdditionRequest,jsonDoc.toJson());
    emit profile_updated();

}

void FireBaseAccess::get_profile_update()
{
    m_NetworkReply = m_NetworkAccessManager->get(QNetworkRequest(QUrl("https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/"+ m_firebasejsonname + "/UserInformation.json")));
    connect(m_NetworkReply,&QNetworkReply::readyRead,this,&FireBaseAccess::profile_data_network_reply_read);

}

void FireBaseAccess:: profile_data_network_reply_read()
{
    QByteArray response = m_NetworkReply->readAll();
    m_NetworkReply->deleteLater();
    profile_update_parse(response);
}

void FireBaseAccess::profile_update_parse(const QByteArray &response)
{
    QJsonDocument doc = QJsonDocument::fromJson(response);
    //qDebug()<<"doc:"<<doc;
    QJsonObject obj = doc.object();
    m_name = obj["Name"].toString();
    m_address = obj["Address"].toString();
    m_locality = obj["Locality"].toString();
    m_number = obj["Number"].toString();
    m_mail = obj["Mail"].toString();
    qDebug()<<"name:"<<m_name;
    qDebug()<<"address:"<<m_address;
    qDebug()<<"Locality:"<<m_locality;
    qDebug()<<"number:"<<m_number;
    qDebug()<<"mail:"<<m_mail;
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

QString FireBaseAccess::role() const
{
    return m_role;
}

void FireBaseAccess::setRole(const QString &newRole)
{
    if (m_role == newRole)
        return;
    m_role = newRole;
    emit roleChanged();
}

QString FireBaseAccess::storagename() const
{
    //return m_storagename;
    return firebase_storage_name;
}

void FireBaseAccess::setStoragename(const QString &newStoragename)
{
    if (m_storagename == newStoragename)
        return;
    m_storagename = newStoragename;
    emit storagenameChanged();
}
