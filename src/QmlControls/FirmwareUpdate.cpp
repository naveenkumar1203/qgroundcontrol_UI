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
void FirmwareUpdate::checksum_generation_process_model_A()
{
    QProcess code_checksum_process_model_A;
    code_checksum_process_model_A.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << "/home/vasanth/firmware_load/new_model_A.txt" << "/home/vasanth/firmware_load/model_A.params");
    qDebug() << "code checksum file generated with exit code";

    QString generated_checksum_cmd_model_A = "/home/vasanth/firmware_load/new_model_A.txt";


    QFile file(generated_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }

    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line = in.readAll();
        QStringList split_text = line.split( "=" );
        QString checksum_generated_model_A = split_text.value( split_text.length()-1);
        model_A_value1 = checksum_generated_model_A;
        qDebug()<<checksum_generated_model_A;

    }
    checksum_calculation_process_model_A();
    compare_file_model_A();
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


void FirmwareUpdate::checksum_calculation_process_model_A()
{

    QString calculated_checksum_cmd_model_A = "/home/vasanth/firmware_load/model_A_checksum.txt";
    QFile file(calculated_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString checksum_calculated_model_A = split_text.value( split_text.length()-1);
        model_A_value2 = checksum_calculated_model_A;
        qDebug()<<checksum_calculated_model_A;
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

void FirmwareUpdate::compare_file_model_A()
{

    QString list1 = model_A_value1;
    QString list2 = model_A_value2;

    qDebug() << list1;
    qDebug() << list2;

    if(list1 == list2){

        QMessageBox msgBox;
        msgBox.setText("Model A - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        load_file_model_A();
        qDebug()<< "Model A - The checksum matches. Please continue";
        return;
    }
    else {
        QMessageBox msgBox;
        msgBox.setText("Model A - The Checksum does not match. Please contact your OEM");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        qDebug()<< "Model A - The Checksum does not match. Please contact your OEM";
    }


}
void FirmwareUpdate::load_file_model_A()
{
    QString filename = "/home/vasanth/firmware_load/model_A.params";
    QFile file(filename);
    model_A_firmware_load =filename;
    emit firmware_load_model_AChanged();

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


void FirmwareUpdate::checksum_generation_process_model_B()

{
    QProcess code_checksum_process_model_B;
    code_checksum_process_model_B.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << "/home/vasanth/firmware_load/new_model_B.txt" << "/home/vasanth/firmware_load/model_B.params");
    qDebug() << "code checksum file generated with exit code";

    QString generated_checksum_cmd_model_B = "/home/vasanth/firmware_load/new_model_B.txt";


    QFile file(generated_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line = in.readAll();
        QStringList split_text = line.split( "=" );
        QString checksum_generated_model_B = split_text.value( split_text.length()-1);
        model_B_value1 = checksum_generated_model_B;
        qDebug()<<checksum_generated_model_B;

    }
    checksum_calculation_process_model_B();
    compare_file_model_B();
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
void FirmwareUpdate::checksum_calculation_process_model_B()
{

    QString calculated_checksum_cmd_model_B = "/home/vasanth/firmware_load/model_B_checksum.txt";
    QFile file(calculated_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString checksum_calculated_model_B = split_text.value( split_text.length()-1);
        model_B_value2 = checksum_calculated_model_B;
        qDebug()<<checksum_calculated_model_B;
    }
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

void FirmwareUpdate::compare_file_model_B()
{

    QString list1 = model_B_value1;
    QString list2 = model_B_value2;

    qDebug() << list1;
    qDebug() << list2;

    if(list1 == list2){

        QMessageBox msgBox;
        msgBox.setText("Model B - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        load_file_model_B();
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

void FirmwareUpdate::load_file_model_B()
{
    QString filename = "/home/vasanth/firmware_load/model_B.params";
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

