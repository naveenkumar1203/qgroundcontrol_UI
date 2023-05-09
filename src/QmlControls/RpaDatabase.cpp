#include "RpaDatabase.h"
#include "FirmwareUpgradeController.h"
#include "FireBaseAccess.h"
#include <QDebug>
#include <QJsonArray>
#include <QTimer>

QString uin_number;
QString user;

class FireBaseAccess;

TableModel::TableModel(QObject *parent) :
    QAbstractTableModel(parent)
{
    m_networkAccessManager = new QNetworkAccessManager(this);
}

TableModel::~TableModel()
{
    m_networkAccessManager->deleteLater();
}

void TableModel::network_reply_read()
{
    //qDebug()<<m_networkreply->readAll();
    QByteArray response = m_networkreply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    QJsonObject object = doc.object();
    QList<QJsonObject> jsonObjectList;
    qDebug()<<response;

    if (response == "null"){
        emit uinNotFound();
    }
    else {
        emit uinFound();
    }
}

void TableModel::network_reply_read_addData()
{
    //qDebug()<< m_networkreply->readAll();
    QByteArray response = m_networkreply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    QJsonObject object = doc.object();
    //QList<QJsonObject> jsonObjectList;
    qDebug()<<"inside add data read";
    uinlist.clear();
    typelist.clear();
    modellist.clear();
    dronelist.clear();
    qDebug()<<"cleared list";
    foreach(const QString& key, object.keys()) {
        QJsonValue value = object.value(key);
        QJsonObject jsonObject = value.toObject();
        qDebug()<<"The Value for Key is" << jsonObject;
        foreach (const QString& key1, jsonObject.keys()) {
            if(key1 == "Model"){
                QJsonValue value = jsonObject.value("Model");
                modellist.append(value.toString());
                qDebug()<<"Model appended";
            }
            if(key1 == "Type"){
                QJsonValue value = jsonObject.value("Type");
                typelist.append(value.toString());
                qDebug()<<"type appended";
            }
            if(key1 == "UINNO"){
                QJsonValue value = jsonObject.value("UINNO");
                uinlist.append(value.toString());
                qDebug()<<"uin appended";
            }
            if(key1 == "Name"){
                QJsonValue value = jsonObject.value("Name");
                dronelist.append(value.toString());
                qDebug()<<"drone list appended";
            }
            //dronelist.append("dji1");
        }
    }
    qDebug()<<uinlist;
    qDebug()<<typelist;
    qDebug()<<modellist;

    setData(index(0,0),"1",2);
}

bool TableModel::setData(const QModelIndex &index1, const QVariant &value, int role)
{

    QModelIndex topLeft =index(0,0);
    QModelIndex bottomRight = index(rowCount() -1 , columnCount() -1);
    emit dataChanged(topLeft,bottomRight,{CheckBoxRole,
                                          TypeRole,
                                          ModelRole,
                                          DroneRole,
                                          UinRole,
                                          SqlEditRole});

    qDebug()<<"show table called";
    //emit showTable();
    emit dataAdded();
    return true;
}

int TableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return typelist.count();
}

int TableModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 4;
}

QVariant TableModel::data(const QModelIndex & index, int role) const {

    if (index.row() < 0 || index.row() >= typelist.count())
        return QVariant();

    //    if (role == CheckBoxRole)
    //        return typelist[index.row()];

    else if (role== TypeRole){
        return typelist[index.row()]; //.isEnabled();
    }
    else if (role== ModelRole){
        return modellist[index.row()];
    }
    else if (role== DroneRole){
        return dronelist[index.row()];
    }
    else if (role== UinRole){
        return uinlist[index.row()];
    }
    else if (role== SqlEditRole){
        return uinlist[index.row()];
    }
    else {
        return QVariant();
    }
}

void TableModel::delete_query(const QString &name, const QString &number)
{
    QString user_mail = name;
    int pos = user_mail.lastIndexOf("@");
    //qDebug() << user_mail.left(pos);
    user_mail = user_mail.left(pos);
    user = user_mail;
    QString deleteUin =  uinlist.at(number.toInt());
    QString user_link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/" + deleteUin + ".json";
    m_networkreply = m_networkAccessManager->deleteResource(QNetworkRequest(QUrl(user_link)));
    emit dataDeleted();
}

void TableModel::existingUIN(const QString &userName,const QString &uinText)
{
    uin_number = uinText;
    QString user_mail = userName;
    int pos = user_mail.lastIndexOf("@");
    user_mail = user_mail.left(pos);
    user = user_mail;
    QString user_link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/" + uinText + "/.json";
    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl(user_link)));
    connect(m_networkreply,&QNetworkReply::readyRead,this,&TableModel::network_reply_read);

}

void TableModel::add_rpa(const QString &droneType, const QString &droneModel, const QString &droneName, const QString &uinText)
{
    QVariantMap newAddition;
    newAddition["UINNO"] = uinText;
    newAddition["Type"] = droneType;
    newAddition["Model"] = droneModel;
    newAddition["Name"] = droneName;
    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newAddition);

    QString link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/" + uinText + "/.json";
    QUrl userUrl = link;
    QNetworkRequest newAdditionRequest((QUrl(userUrl)));
    newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    m_networkreply = m_networkAccessManager->put(newAdditionRequest,jsonDoc.toJson());
    getData();
}

void TableModel::getData()
{
    qDebug()<<user;
    qDebug()<<"FIRST ";
    QString link1 = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/.json";
    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl(link1)));
    connect(m_networkreply,&QNetworkReply::readyRead,this,&TableModel::network_reply_read_addData);
    qDebug()<<"I am ";
}

void TableModel::manageRpaClicked(const QString &userName)
{
    QString user_mail = userName;
    int pos = user_mail.lastIndexOf("@");
    //qDebug() << user_mail.left(pos);
    user_mail = user_mail.left(pos);
    user = user_mail;
    getData();
}

void TableModel::modelSelected(const QString &number)
{
    qDebug()<<"in model selected";

    qDebug()<<uinlist.at(number.toInt());
    m_uin = uinlist.at(number.toInt());
    qDebug()<<modellist.at(number.toInt());
    m_model = modellist.at(number.toInt());
}

void TableModel::firmwareupgrade_data()
{
    QString link1 = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + usermail + "/FIRMWARELOG/.json";
    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl(link1)));
    connect(m_networkreply,&QNetworkReply::readyRead,this,&TableModel::firmwarelog_contain_data);
    qDebug()<<"i am enter in the new function ";
}

void TableModel:: firmwarelog_contain_data()
{
    QByteArray response = m_networkreply->readAll();
    m_networkreply->deleteLater();
    firmware_apply_read_addData(response);
}

void TableModel::firmware_apply_read_addData(const QByteArray &response)
{
    //QByteArray response = m_networkreply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    QJsonObject object = doc.object();
    foreach(const QString& key, object.keys()) {
        qDebug()<< key;
        QString date_time = key;
        QJsonValue value = object.value(key);
        QJsonObject jsonObject = value.toObject();
        qDebug()<<"The Value for Key is" << jsonObject;
        foreach (const QString& key1, jsonObject.keys()) {
            if(key1 == "status"){
                QJsonValue value = jsonObject.value("status");
                QString adddata = date_time + " " + " " + " " + " " + " " + value.toString();
                m_firmwarelog_list.clear();
                m_firmwarelog_list.append(adddata);
                qDebug()<<m_firmwarelog_list;
                qDebug()<<"error while updating firmware log";
                qDebug()<<"Model appended";
            }
        }

     emit firmwarelog_listChanged();
    }

}

/*void TableModel::checkbox_edit(const QString &name,const QString &number,const QString &droneType, const QString &droneModel, const QString &droneName, const QString &uinText)
{
    QString user_mail = name;
    int pos = user_mail.lastIndexOf("@");
    //qDebug() << user_mail.left(pos);
    user_mail = user_mail.left(pos);
    user = user_mail;
    uinText =  uinlist.at(number.toInt());
    m_uin = uinText;
    droneType = typelist.at(number.toInt());
    m_type = droneType;
    droneModel = modellist.at(number.toInt());
    m_model = droneModel;
    droneName = dronelist.at(number.toInt());
    m_droneName = droneName;
//    QString user_link = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/" + editUin + ".json";
//    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl(user_link)));
//    connect(m_networkreply,&QNetworkReply::readyRead,this,&TableModel::network_reply_read_editData);
}

void TableModel::update_rpa(const QString &droneType, const QString &droneModel, const QString &droneName, const QString &uinText)
{
    m_networkAccessManagerWithPatch = new QNetworkAccessManagerWithPatch(this);
    QVariantMap newAddition;
    newAddition["UINNO"] = uinText;
    newAddition["Type"] = droneType;
    newAddition["Model"] = droneModel;
    newAddition["Name"] = droneName;
    qDebug()<<"newAddition:"<<newAddition;
    QJsonDocument jsonDoc = QJsonDocument::fromVariant(newAddition);
    qDebug()<<"jsonDoc:"<<jsonDoc;
    QNetworkRequest newAdditionRequest(QUrl("https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/" + uinText + "/.json"));
    newAdditionRequest.setHeader(QNetworkRequest::ContentTypeHeader,QString("application/json"));
    m_networkAccessManagerWithPatch->patch(newAdditionRequest,jsonDoc.toJson());

}*/


QHash<int, QByteArray> TableModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CheckBoxRole] = "checkbox";
    roles[TypeRole] = "type";
    roles[ModelRole] = "model_name";
    roles[DroneRole] = "drone_name";
    roles[UinRole] = "uin_number";
    roles[SqlEditRole] = "edit_operations";
    return roles;
}


QString TableModel::droneName() const
{
    return m_droneName;
}

void TableModel::setDroneName(const QString &newDroneName)
{
    if (m_droneName == newDroneName)
        return;
    m_droneName = newDroneName;
    emit droneNameChanged();
}

QString TableModel::uin() const
{
    return m_uin;
}

void TableModel::setUin(const QString &newUin)
{
    if (m_uin == newUin)
        return;
    m_uin = newUin;
    emit uinChanged();
}

QString TableModel::type() const
{
    return m_type;
}

void TableModel::setType(const QString &newType)
{
    if (m_type == newType)
        return;
    m_type = newType;
    emit typeChanged();
}

QString TableModel::model() const
{
    return m_model;
}

void TableModel::setModel(const QString &newModel)
{
    if (m_model == newModel)
        return;
    m_model = newModel;
    emit modelChanged();
}

QStringList TableModel::firmwarelog_list() const
{
    return m_firmwarelog_list;
}

void TableModel::setFirmwarelog_list(const QStringList &newFirmwarelog_list)
{
    if (m_firmwarelog_list == newFirmwarelog_list)
                              return;
    m_firmwarelog_list = newFirmwarelog_list;
    emit firmwarelog_listChanged();
}


