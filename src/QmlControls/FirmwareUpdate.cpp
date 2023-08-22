#include <iostream>
#include <fstream>
#include <string>
#include "FirmwareUpdate.h"
#include <QMessageBox>

QString data_model_value1 = "a";
QString data_model_value2 = "b";
QString code_model_value1 = "c";
QString code_model_value2 = "d";

int sound_flag = 0;
bool checksum_match = false;

FirmwareUpdate::FirmwareUpdate(QObject *parent)
    : QObject{parent}
{

}
void FirmwareUpdate::checksum_generation_process_model(QString real_file_location)
{
    QProcess code_checksum_process_model;
    QString modelName = obj1.model();

    real_file_location = real_file_location.remove("file:///");

    QString data_params_location = real_file_location + "/GoDrona GCS/Telemetry/" + modelName + ".params";
    QString data_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_data_" + modelName + "_checksum.txt";

    QString code_location = real_file_location + "/GoDrona GCS/Telemetry/firmware_" + modelName + ".apj";
    QString code_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_code_" + modelName + "_checksum.txt";

    QFile dataFile(data_params_location);
    if (dataFile.open(QIODevice::ReadOnly)) {
        QByteArray fileData = dataFile.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << "Data Hash for" << modelName << ":" << hashData.toHex();
        data_model_value1 = hashData.toHex();
        dataFile.close();
    } else {
        qWarning() << "Unable to open data file for" << modelName;
    }

    QFile codeFile(code_location);
    if (codeFile.open(QIODevice::ReadOnly)) {
        QByteArray fileData = codeFile.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << "Code Hash for" << modelName << ":" << hashData.toHex();
        code_model_value1 = hashData.toHex();
        codeFile.close();
    } else {
        qWarning() << "Unable to open code file for" << modelName;
    }

    checksum_calculation_process_model(real_file_location);
}

QString FirmwareUpdate::checksum_generation_model()
{
    return model_generated_checksum;
}

void FirmwareUpdate::setgenerated_checksum_model(const QString &newgenerated_checksum_model)
{
    if (model_generated_checksum == newgenerated_checksum_model)
        return;
    model_generated_checksum = newgenerated_checksum_model;
    emit generation_checksum_modelChanged();
}

void FirmwareUpdate::checksum_calculation_process_model(QString real_file_location)
{
    QString modelName = obj1.model();
    QString calculated_data_checksum_cmd_model =  real_file_location + "/GoDrona GCS/Telemetry/data_" + modelName + "_checksum.txt";
    QFile file(calculated_data_checksum_cmd_model);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString data_checksum_calculated_model = split_text.value( split_text.length()-1);
        data_model_value2 = data_checksum_calculated_model;
    }

    QString calculated_code_checksum_cmd_model =  real_file_location + "/GoDrona GCS/Telemetry/code_"+ modelName + "_checksum.txt";

    QFile file1(calculated_code_checksum_cmd_model);
    if (!file1.open(QIODevice::ReadOnly | QIODevice::Text)){

    }

    QTextStream in1(&file1);
    while (!file1.atEnd()) {
        QString line1 = in1.readAll();
        QStringList split_text = line1.split( "=" );
        QString code_checksum_calculated_model = split_text.value( split_text.length()-1);
        code_model_value2 = code_checksum_calculated_model;
    }
    file.close();
    file1.close();
    compare_file_model(real_file_location);
}
QString FirmwareUpdate::checksum_calculation_model()
{
    return model_calculated_checksum;
}

void FirmwareUpdate::setcalculated_checksum_model(const QString &newcalculated_checksum_model)
{
    if (model_calculated_checksum == newcalculated_checksum_model)
        return;
    model_calculated_checksum = newcalculated_checksum_model;
    emit calculation_checksum_modelChanged();
}

void FirmwareUpdate::compare_file_model(QString real_file_location)
{
    QString data_list1 = data_model_value1;
    QString data_list2 = data_model_value2;

    QString code_list1 = code_model_value1;
    QString code_list2 = code_model_value2;

    data_list2 = data_list2.remove("\n");
    data_list2 = data_list2.remove(" ");

    code_list2 = code_list2.remove("\n");
    code_list2 = code_list2.remove(" ");

    QString modelName = obj1.model();

    if((data_list1 == data_list2) && (code_list1 == code_list2)){

        checksum_match = true;
        QMessageBox msgBox;
        msgBox.setText(QString("%1 - The checksum matches. Please continue").arg(modelName));
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        load_file_model(real_file_location);
        return;
    }
    else {
        checksum_match = false;
        QMessageBox msgBox;
        msgBox.setText(QString("%1 - The Checksum does not match. Please contact your OEM").arg(modelName));
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
    }
}
void FirmwareUpdate::load_file_model(QString real_file_location)
{
    QString modelName = obj1.model();
    QString filename = real_file_location + "/GoDrona GCS/Telemetry/" + modelName + ".params";
    QFile file(filename);
    if(file.exists()){
        model_firmware_load =filename;
        emit firmware_load_modelChanged();
    }
    else {

    }
}
QString FirmwareUpdate::firmware_load_model()
{
    return model_firmware_load;
}

void FirmwareUpdate::setfirmware_load_model(const QString &newfirmware_load_model)
{
    if (model_firmware_load == newfirmware_load_model)
        return;
    model_firmware_load = newfirmware_load_model;
}

int FirmwareUpdate::mute_sound(int audio_flag)
{
    sound_flag = audio_flag;

    return 1;
}
