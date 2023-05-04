#include <QNetworkRequest>
#include <QDebug>
#include <QVariantMap>
#include <QJsonDocument>
#include <QJsonObject>

#include "FirebaseHandler.h"

FirebaseHandler::FirebaseHandler(QObject *parent) : QObject(parent)
{

}

FirebaseHandler::~FirebaseHandler()
{
    m_networkAccessManager->deleteLater();
}

void FirebaseHandler::access_firebase(const QString &type, const QString &model_name, const QString &drone_name, const QString &uin)
{
    m_networkAccessManager = new QNetworkAccessManager(this);
    //m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl("https://myfirebaseproject-85891-default-rtdb.asia-southeast1.firebasedatabase.app/"))); ---> locked mode

    //====for get alone====//
    //    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl("https://myfirebasefreemode-default-rtdb.asia-southeast1.firebasedatabase.app/RPA/UIN.json"))); //----> test mode
    //    connect(m_networkreply,&QNetworkReply::readyRead,this,&FirebaseHandler::network_reply_read);


    QVariantMap newAddition;
    newAddition["Drone Type"] = type;
    newAddition["Model Name"] = model_name;
    newAddition["Drone Name"] = drone_name;
    newAddition["UIN"] = uin;
    qDebug()<<"newAddition:"<<newAddition;
    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newAddition);
    qDebug()<<"jsonDoc:"<<jsonDoc;

    QString fileName = uin + ".json";
    qDebug()<<fileName;

    QNetworkRequest newAdditionRequest(QUrl("https://myfirebasefreemode-default-rtdb.asia-southeast1.firebasedatabase.app/"+ fileName));
    newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    m_networkAccessManager->post(newAdditionRequest,jsonDoc.toJson());



}

void FirebaseHandler::network_reply_read()
{
    qDebug()<<m_networkreply->readAll();
}
