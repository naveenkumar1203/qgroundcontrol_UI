#include <iostream>
#include <fstream>
#include <string>
#include "FirmwareUpdate.h"
#include "ParameterEditorController.h"
#include <QMessageBox>


QString model_A_value1;
QString model_A_value2;
QString model_B_value1;
QString model_B_value2;

FirmwareUpdate::FirmwareUpdate(QObject *parent)
    : QObject{parent}
{

}
void FirmwareUpdate::checksum_generation_process_model_A(QString folder_location)
{
    QProcess code_checksum_process_model_A;

    QString real_file_location = folder_location.remove("file://");
    QString a_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_A.params";
    QString a_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_model_A.txt";

    code_checksum_process_model_A.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << a_checksum_location << a_params_location);

    QString generated_checksum_cmd_model_A = a_checksum_location;

    QFile file(a_params_location);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        model_A_value1 = hashData.toHex();
    }

//    QFile file(generated_checksum_cmd_model_A);
//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

//    }

//    QTextStream in(&file);
//    while (!file.atEnd()) {
//        QString line = in.readAll();
//        QStringList split_text = line.split( "=" );
//        QString checksum_generated_model_A = split_text.value( split_text.length()-1);
//        model_A_value1 = checksum_generated_model_A;
//        //qDebug()<< "generated checksum" << checksum_generated_model_A;
//    }

    checksum_calculation_process_model_A(real_file_location);
}

QString FirmwareUpdate::checksum_generation_model_A()
{
    return model_A_generated_checksum;
}

void FirmwareUpdate::setgenerated_checksum_model_A(const QString &newgenerated_checksum_model_A)
{
    if (model_A_generated_checksum == newgenerated_checksum_model_A)
        return;
    model_A_generated_checksum = newgenerated_checksum_model_A;
    emit generation_checksum_model_AChanged();
}


void FirmwareUpdate::checksum_calculation_process_model_A(QString real_file_location)
{

    QString calculated_checksum_cmd_model_A =  real_file_location + "/GoDrona GCS/Telemetry/model_A_checksum.txt";
    QFile file(calculated_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    if(file.exists()){
        while (!file.atEnd()) {
            QString line1 = in.readAll();
            QStringList split_text = line1.split( "=" );
            QString checksum_calculated_model_A = split_text.value( split_text.length()-1);
            checksum_calculated_model_A = checksum_calculated_model_A.trimmed();
            model_A_value2 = checksum_calculated_model_A;
            //qDebug()<<"existing checksum"<<checksum_calculated_model_A;
        }
    compare_file_model_A(real_file_location);
    }
}
QString FirmwareUpdate::checksum_calculation_model_A()
{
    return model_A_calculated_checksum;
}

void FirmwareUpdate::setcalculated_checksum_model_A(const QString &newcalculated_checksum_model_A)
{
    if (model_A_calculated_checksum == newcalculated_checksum_model_A)
        return;
    model_A_calculated_checksum = newcalculated_checksum_model_A;
    emit calculation_checksum_model_AChanged();
}

void FirmwareUpdate::compare_file_model_A(QString real_file_location)
{

    QString list1 = model_A_value1;
    QString list2 = model_A_value2;

    qDebug() << list1;
    qDebug() << list2;

    if(list1 == list2){

//        QMessageBox msgBox;
//        msgBox.setText("Model A - The checksum matches. Please continue");
//        msgBox.setStyleSheet("color:white;background:#05324D");
//        msgBox.setDefaultButton(QMessageBox::Ok);
//        msgBox.exec();
        load_file_model_A(real_file_location);
        //qDebug()<< "Model A - The checksum matches. Please continue";
        return;
    }
    else {

        QMessageBox msgBox;
        msgBox.setText("Model A - The Checksum does not match. Please contact your OEM");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        //qDebug()<< "Model A - The Checksum does not match. Please contact your OEM";
    }


}
void FirmwareUpdate::load_file_model_A(QString real_file_location)
{
    //QString filename = "/home/vasanth/firmware_load/model_A_change.params";
    QString filename = real_file_location + "/GoDrona GCS/Telemetry/model_A.params";;

    QFile file(filename);
    if(file.exists()){
        model_A_firmware_load =filename;
        emit firmware_load_model_AChanged();
    }
    else {
        qDebug()<<"no such file";
    }
}
QString FirmwareUpdate::firmware_load_model_A()
{
    return model_A_firmware_load;
}

void FirmwareUpdate::setfirmware_load_model_A(const QString &newfirmware_load_model_A)
{
    if (model_A_firmware_load == newfirmware_load_model_A)
        return;
    model_A_firmware_load = newfirmware_load_model_A;
}


void FirmwareUpdate::checksum_generation_process_model_B(QString real_file_location)

{
    QProcess code_checksum_process_model_B;


    real_file_location = real_file_location.remove("file://");
    QString b_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";
    QString b_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_model_B.txt";

    qDebug()<<b_params_location;
    qDebug()<<b_checksum_location;

    code_checksum_process_model_B.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << b_checksum_location << b_params_location);


    QString generated_checksum_cmd_model_B = b_checksum_location;

    QFile file(b_params_location);
    if(file.exists()){
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        model_B_value1 = hashData.toHex();
    }
    checksum_calculation_process_model_B(real_file_location);
    }

//    QFile file(generated_checksum_cmd_model_B);
//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

//    }
//    QTextStream in(&file);
//    if(file.exists()){
//        while (!file.atEnd()) {
//            QString line = in.readAll();
//            QStringList split_text = line.split( "=" );
//            QString checksum_generated_model_B = split_text.value( split_text.length()-1);
//            model_B_value1 = checksum_generated_model_B;
//            qDebug()<<checksum_generated_model_B;

//        }
//        checksum_calculation_process_model_B(real_file_location);
//    }
}
QString FirmwareUpdate::checksum_generation_model_B()
{
    return model_B_generated_checksum;
}
void FirmwareUpdate::setgenerated_checksum_model_B(const QString &newgenerated_checksum_model_B)
{
    if (model_B_generated_checksum == newgenerated_checksum_model_B)
        return;
    model_B_generated_checksum = newgenerated_checksum_model_B;
    emit generation_checksum_model_BChanged();
}
void FirmwareUpdate::checksum_calculation_process_model_B(QString real_file_location)
{
    QString calculated_checksum_cmd_model_B =  real_file_location + "/GoDrona GCS/Telemetry/model_B_checksum.txt";

    QFile file(calculated_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString checksum_calculated_model_B = split_text.value( split_text.length()-1);
        checksum_calculated_model_B = checksum_calculated_model_B.trimmed();
        model_B_value2 = checksum_calculated_model_B;
    }
    compare_file_model_B(real_file_location);

}
QString FirmwareUpdate::checksum_calculation_model_B()
{
    return model_B_calculated_checksum;
}

void FirmwareUpdate::setcalculated_checksum_model_B(const QString &newcalculated_checksum_model_B)
{
    if (model_B_calculated_checksum == newcalculated_checksum_model_B)
        return;
    model_B_calculated_checksum = newcalculated_checksum_model_B;
    emit calculation_checksum_model_BChanged();
}

void FirmwareUpdate::compare_file_model_B(QString real_file_location)
{

    QString list1 = model_B_value1;
    QString list2 = model_B_value2;

    qDebug() << list1;
    qDebug() << list2;

    if(list1 == list2){

//        QMessageBox msgBox;
//        msgBox.setText("Model B - The checksum matches. Please continue");
//        msgBox.setStyleSheet("color:white;background:#05324D");
//        msgBox.setDefaultButton(QMessageBox::Ok);
//        msgBox.exec();
        load_file_model_B(real_file_location);
        qDebug()<< "Model B - The checksum matches. Please continue";
        return;
    }
    else {
        QMessageBox msgBox;
        msgBox.setText("Model B - The Checksum does not match. Please contact your OEM");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        qDebug()<< "Model B - The Checksum does not match. Please contact your OEM";
    }

}

void FirmwareUpdate::load_file_model_B(QString real_file_location)
{
    QString filename = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";;

    QFile file(filename);
    model_B_firmware_load =filename;
    emit firmware_load_model_BChanged();

}
QString FirmwareUpdate::firmware_load_model_B()
{
    return model_B_firmware_load;
}

void FirmwareUpdate::setfirmware_load_model_B(const QString &newfirmware_load_model_B)
{
    if (model_B_firmware_load == newfirmware_load_model_B)
        return;
      model_B_firmware_load = newfirmware_load_model_B;
}

