#include "RpaDatabase.h"
#include "FirmwareUpgradeController.h"
#include "FireBaseAccess.h"
#include <QDebug>
#include <QJsonArray>
#include <QTimer>

QString uin_number;
QString user;

QString file_model="";
QString file_uin;

QString uin_number_selected;

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

/*void TableModel::modelSelected(const QString &number)
{
    qDebug()<<"in model selected";

    qDebug()<<uinlist.at(number.toInt());
    m_uin = uinlist.at(number.toInt());
    qDebug()<<modellist.at(number.toInt());
    m_model = modellist.at(number.toInt());
}*/

void TableModel::modelSelected(const QString &number)
{
    uin_number_selected = number;
    QString link1 = "https://godrona-gcs-default-rtdb.asia-southeast1.firebasedatabase.app/" + user + "/RPA/UIN/.json";
    m_networkreply = m_networkAccessManager->get(QNetworkRequest(QUrl(link1)));
    connect(m_networkreply,&QNetworkReply::readyRead,this,&TableModel::modelSelected_list);
}

void TableModel::modelSelected_list()
{
    QByteArray response = m_networkreply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    QJsonObject object = doc.object();
    uinlist.clear();
    typelist.clear();
    modellist.clear();
    dronelist.clear();

    foreach(const QString& key, object.keys()) {
        QJsonValue value = object.value(key);
        QJsonObject jsonObject = value.toObject();
        foreach (const QString& key1, jsonObject.keys()) {
            if(key1 == "Model"){
                QJsonValue value = jsonObject.value("Model");
                modellist.append(value.toString());
                //qDebug()<<"Model appended";
            }
            if(key1 == "Type"){
                QJsonValue value = jsonObject.value("Type");
                typelist.append(value.toString());
                //qDebug()<<"type appended";
            }
            if(key1 == "UINNO"){
                QJsonValue value = jsonObject.value("UINNO");
                uinlist.append(value.toString());
                //qDebug()<<"uin appended";
            }
            if(key1 == "Name"){
                QJsonValue value = jsonObject.value("Name");
                dronelist.append(value.toString());
            }
        }
    }

    qDebug()<<"uin selected is"<<uinlist.at(uin_number_selected.toInt());
    m_uin = uinlist.at(uin_number_selected.toInt());
    qDebug()<<"model selected is"<<modellist.at(uin_number_selected.toInt());
    m_model = modellist.at(uin_number_selected.toInt());
    file_model = m_model;
    file_uin = m_uin;
    emit modelChanged();

}

void TableModel::image_function(const QString &file_name, const QString &firebase_folder_name)
{
    qDebug()<<"in image_function";
    QString imagelink = "https://firebasestorage.googleapis.com/v0/b/" + _projectID + ".appspot.com/o/" + firebase_folder_name + "%2F" + file_name + "?alt=media";
    QUrl imageurl = QUrl(QString::fromStdString(imagelink.toStdString()));
    m_image = imageurl;
}

void TableModel::upload_function(const QString &firebase_file_name, const QString &firebase_folder_name,const QString &folder_location)
{
    QNetworkRequest request;

    QString link = "https://firebasestorage.googleapis.com/v0/b/" + _projectID + ".appspot.com/o/" + firebase_folder_name + "%2F" + firebase_file_name  ;
    qDebug()<<"link is"<<link;
    request.setUrl(QUrl(link));
    request.setHeader(QNetworkRequest::ContentTypeHeader,"text/csv");
    request.setRawHeader("Authorization","Bearer");

    QFile *file = new QFile(folder_location);
    file->open(QIODevice::ReadOnly);

    QNetworkReply *reply;
    reply = m_networkAccessManager->post(request,file);
    connect(reply,&QNetworkReply::finished,[reply, firebase_folder_name, this](){
        if(reply->error() != QNetworkReply::NoError){
            qDebug()<<"if msg" << " " << reply->error();
            qDebug()<<reply->errorString();
        }
        else{
            qDebug()<<"file uploaded";
        }
    });
}

void TableModel::list_function(const QString &firebase_folder_name)
{
    QString link = "https://firebasestorage.googleapis.com/v0/b/" + _projectID + ".appspot.com/o?prefix=" + firebase_folder_name + "/";
    QNetworkRequest request;
    request.setUrl(QUrl(link));
    request.setRawHeader("Authorization","Bearer");
    QNetworkReply *reply;
    reply = m_networkAccessManager->get(request);
    connect(reply,&QNetworkReply::finished,[reply,firebase_folder_name, this](){
        //qDebug()<<"list is " <<reply->readAll();
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject object = doc.object();
        QJsonArray items = doc.object()["items"].toArray();
        for (const QJsonValue& item : items) {
            QString name = item.toObject()["name"].toString();
            if (name.endsWith(".csv")) {
                //qDebug()<<"total file name" << name;
                QString file_name = firebase_folder_name + "/";
                QString user_file = name;
                user_file = user_file.remove(file_name);
                //qDebug()<<"file name"<<user_file;
                m_filename << user_file;
                //qDebug()<<"list contents"<<user_file;
                QString filepath = "QGroundControl.settingsManager.appSettings.telemetrySavePath" + user + "/.txt";
                QFile file(filepath);
                file.open(QIODevice::WriteOnly | QIODevice::ReadOnly | QIODevice::Text |QIODevice::Append);
                QTextStream in(&file);
                in << user_file;
            }
        }
    });

}

void TableModel::read_text_file(QString user_text_file_name, QString user_text_file_folder)
{
    QString user_file = user_text_file_name;
    int pos = user_file.lastIndexOf("@");
    //qDebug() << user_mail.left(pos);
    user_file = user_file.left(pos);

    QString filepath = user_text_file_folder + "/" + user_file + ".txt";

    //qDebug()<<"file to read" << filepath;

    m_filename.clear();
    QString link = "https://firebasestorage.googleapis.com/v0/b/" + _projectID + ".appspot.com/o?prefix=" + user_file + "/";
    QNetworkRequest request;
    request.setUrl(QUrl(link));
    request.setRawHeader("Authorization","Bearer");
    QNetworkReply *reply;
    reply = m_networkAccessManager->get(request);
    connect(reply,&QNetworkReply::finished,[reply,user_file, filepath, this](){
        //qDebug()<<"list is " <<reply->readAll();
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject object = doc.object();
        QJsonArray items = doc.object()["items"].toArray();
        for (const QJsonValue& item : items) {
            QString name = item.toObject()["name"].toString();
            if (name.endsWith(".csv")) {
                //qDebug()<<"total files present" << name;
                QString file_name = user_file + "/";
                QString user_file = name;
                user_file = user_file.remove(file_name);
                qDebug()<<"list contents"<<user_file;
                QFile file(filepath);
                file.open(QIODevice::WriteOnly | QIODevice::ReadOnly | QIODevice::Text |QIODevice::Append);
                QTextStream in(&file);
                in << user_file;
                m_filename.append(user_file);
                qDebug()<< "reading" << m_filename;
                file.close();
            }
        }
    });
}

void TableModel::download_function(const QString &file_name, const QString &firebase_folder_name, const QString &local_pc_location)
{
    QString user_file = firebase_folder_name;
    int pos = user_file.lastIndexOf("@");
    user_file = user_file.left(pos);
    qDebug() << user_file.left(pos);

    QString user_download_location = local_pc_location + ".csv";
    qDebug()<<"user download location"<<user_download_location;
    QNetworkRequest request;

    QString link = "https://firebasestorage.googleapis.com/v0/b/" + _projectID + ".appspot.com/o/" + user_file + "%2F" + file_name + "?alt=media";
    qDebug()<<"link is"<<link;
    request.setUrl(QUrl(link));
    request.setHeader(QNetworkRequest::ContentTypeHeader,"text/csv");
    request.setRawHeader("Authorization","Bearer");

    QNetworkReply *response1 = m_networkAccessManager->get(QNetworkRequest(QUrl(QString::fromStdString(link.toStdString()))));
    //qDebug()<<"response1 is--->"+response1;
    connect(response1,&QNetworkReply::finished,[response1, local_pc_location, user_download_location](){
        QByteArray data = response1->readAll();
        QFile file(user_download_location);
        if (!file.open(QIODevice::WriteOnly)) {
            // handle error
        }
        file.write(data);
        file.close();
        qDebug()<<"else msg" << " " << response1->errorString();
        qDebug()<<"file downloaded";
    });
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
    m_firmwarelog_list.clear();
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
                m_firmwarelog_list.append(adddata);
                qDebug()<<m_firmwarelog_list;
                qDebug()<<"error while updating firmware log";
                qDebug()<<"Model appended";
            }
        }

     emit firmwarelog_listChanged();
    }

}




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

QUrl TableModel::image() const
{
    return m_image;
}

void TableModel::setImage(const QUrl &newImage)
{
    if (m_image == newImage)
        return;
    m_image = newImage;
    emit imageChanged();
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
    //return m_uin;
    return file_uin;
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
    //return m_model;
    return file_model;
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


QStringList TableModel::filename() const
{
    return m_filename;
}

void TableModel::setFileName(const QStringList &newFilename)
{
    if (m_filename == newFilename)
        return;
    m_filename = newFilename;
    emit filenameChanged();
}



