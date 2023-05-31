#include <iostream>
#include <fstream>
#include <string>
#include "FirmwareUpdate.h"
#include "ParameterEditorController.h"
#include <QMessageBox>
#include <QPushButton>


QString data_model_A_value1= "a";
QString data_model_A_value2= "b";
QString data_model_B_value1= "c";
QString data_model_B_value2= "d";

QString code_model_A_value1= "e";
QString code_model_A_value2= "f";
QString code_model_B_value1= "g";
QString code_model_B_value2= "h";


FirmwareUpdate::FirmwareUpdate(QObject *parent)
    : QObject{parent}
{

}
void FirmwareUpdate::checksum_generation_process_model_A(QString real_file_location)
{
    QProcess code_checksum_process_model_A;

    real_file_location = real_file_location.remove("file://");
    real_file_location.remove("/Documents");

    QString a_data_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_A.params";
    QString a_data_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_data_A_checksum.txt";

    QString a_code_location = real_file_location + "/GoDrona GCS/Telemetry/firmware_A.apj";
    QString a_code_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_code_A_checksum.txt";


    QFile file(a_data_params_location);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        data_model_A_value1 = hashData.toHex();
    }


    QFile file1(a_code_location);
    if (file1.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file1.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        code_model_A_value1 = hashData.toHex();
    }
    file.close();
    file1.close();

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

    QString calculated_data_checksum_cmd_model_A =  real_file_location + "/GoDrona GCS/Telemetry/data_A_checksum.txt";
    QFile file(calculated_data_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }

    QTextStream in(&file);

    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString data_checksum_calculated_model_A = split_text.value( split_text.length()-1);
        data_checksum_calculated_model_A = data_checksum_calculated_model_A.trimmed();
        data_model_A_value2 = data_checksum_calculated_model_A;

    }

    QString calculated_code_checksum_cmd_model_A =  real_file_location + "/GoDrona GCS/Telemetry/code_A_checksum.txt";
    QFile file1(calculated_code_checksum_cmd_model_A);
    if (!file1.open(QIODevice::ReadOnly | QIODevice::Text)){

    }

    QTextStream in1(&file1);

    while (!file1.atEnd()) {
        QString line1 = in1.readAll();
        QStringList split_text = line1.split( "=" );
        QString code_checksum_calculated_model_A = split_text.value( split_text.length()-1);
        code_checksum_calculated_model_A = code_checksum_calculated_model_A.trimmed();
        code_model_A_value2 = code_checksum_calculated_model_A;
    }
    compare_file_model_A(real_file_location);


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

    QString data_list1 = data_model_A_value1;
    QString data_list2 = data_model_A_value2;

    QString code_list1 = code_model_A_value1;
    QString code_list2 = code_model_A_value2;

    qDebug() <<"Model Generated"<< data_list1;
    qDebug() << "Model Calculated"<< data_list2;

    qDebug() << "Code Generated"<< code_list1;
    qDebug() << "Code Calculated"<< code_list2;

    if((data_list1 == data_list2) && (code_list1 == code_list2))
            {
                QMessageBox msgBox;
                msgBox.setText("Model A - The Checksum Matches");
                msgBox.setStyleSheet("color:white;background:#05324D");
                QPushButton *confirmButton = new QPushButton("OK", &msgBox);
                msgBox.addButton(confirmButton, QMessageBox::AcceptRole);
                msgBox.setDefaultButton(confirmButton);
                msgBox.exec();

        load_file_model_A(real_file_location);
        qDebug()<< "Model A - The checksum matches. Please continue";

        return;

    }
    else {

        QMessageBox msgBox;
        msgBox.setText("Model A - The Checksum does not match. Please contact your OEM");
        msgBox.setStyleSheet("color:white;background:#05324D");
        QPushButton *confirmButton = new QPushButton("OK", &msgBox);
        msgBox.addButton(confirmButton, QMessageBox::AcceptRole);
        msgBox.setDefaultButton(confirmButton);
        msgBox.exec();

        qDebug()<< "Model A - The Checksum does not match. Please contact your OEM";

    }
}
void FirmwareUpdate::load_file_model_A(QString real_file_location)
{
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
    real_file_location.remove("/Documents");

    QString b_data_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";
    QString b_data_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_data_B_checksum.txt";

    QString b_code_location = real_file_location + "/GoDrona GCS/Telemetry/firmware_B.apj";
    QString b_code_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_code_B_checksum.txt";

    QFile file(b_data_params_location);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        data_model_B_value1 = hashData.toHex();
    }

    QFile file2(b_code_location);
    if (file2.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file2.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        code_model_B_value1 = hashData.toHex();
    }
    file.close();
    file2.close();

    checksum_calculation_process_model_B(real_file_location);
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
    QString calculated_data_checksum_cmd_model_B =  real_file_location + "/GoDrona GCS/Telemetry/data_B_checksum.txt";
    qDebug()<<"my name is " << real_file_location;
    QFile file(calculated_data_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString data_checksum_calculated_model_B = split_text.value( split_text.length()-1);
        data_checksum_calculated_model_B = data_checksum_calculated_model_B.trimmed();
        data_model_B_value2 = data_checksum_calculated_model_B;
    }

    QString calculated_code_checksum_cmd_model_B =  real_file_location + "/GoDrona GCS/Telemetry/code_B_checksum.txt";

    QFile file1(calculated_code_checksum_cmd_model_B);
    if (!file1.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in2(&file1);
    while (!file1.atEnd()) {
        QString line1 = in2.readAll();
        QStringList split_text = line1.split( "=" );
        QString code_checksum_calculated_model_B = split_text.value( split_text.length()-1);
        code_checksum_calculated_model_B = code_checksum_calculated_model_B.trimmed();
        code_model_B_value2 = code_checksum_calculated_model_B;
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

    QString data_list1 = data_model_B_value1;
    QString data_list2 = data_model_B_value2;

    QString code_list1 = code_model_B_value1;
    QString code_list2 = code_model_B_value2;

    qDebug() <<"Model Generated"<< data_list1;
    qDebug() << "Model Calculated"<< data_list2;

    qDebug() << "Code Generated"<< code_list1;
    qDebug() << "Code Calculated"<< code_list2;

    if((data_list1 == data_list2) && (code_list1 == code_list2)){

        QMessageBox msgBox;
        msgBox.setText("Model B - The Checksum Matches");
        msgBox.setStyleSheet("color:white;background:#05324D");
        QPushButton *confirmButton = new QPushButton("OK", &msgBox);
        msgBox.addButton(confirmButton, QMessageBox::AcceptRole);
        msgBox.setDefaultButton(confirmButton);
        msgBox.exec();

        load_file_model_B(real_file_location);

        qDebug()<< "Model B - The checksum matches. Please continue";
        return;
    }
    else {

        QMessageBox msgBox;
        msgBox.setText("Model B - The Checksum does not match. Please contact your OEM");
        msgBox.setStyleSheet("color:white;background:#05324D");
        QPushButton *confirmButton = new QPushButton("OK", &msgBox);
        msgBox.addButton(confirmButton, QMessageBox::AcceptRole);
        msgBox.setDefaultButton(confirmButton);
        msgBox.exec();
        qDebug()<< "Model B - The Checksum does not match. Please contact your OEM";
    }

}

void FirmwareUpdate::load_file_model_B(QString real_file_location)
{
    QString filename = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";;
    QFile file(filename);

    if(file.exists()){
    model_B_firmware_load =filename;
    emit firmware_load_model_BChanged();
    }
    else {
    qDebug()<<"no such file";
    }
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
