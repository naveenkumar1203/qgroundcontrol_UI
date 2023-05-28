/*#include <iostream>
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

    //QString a_params_location = _toolbox->settingsManager()->appSettings()->telemetrySavePath() + "/model_A.params";
    //QString a_checksum_location = _toolbox->settingsManager()->appSettings()->telemetrySavePath() + "/new_model_A.txt";

    QString real_file_location = folder_location.remove("file://");
    QString a_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_A.params";
    QString a_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_model_A.txt";

    //qDebug()<<a_params_location;
    //qDebug()<<a_checksum_location;

    //code_checksum_process_model_A.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << "/home/vasanth/firmware_load/new_model_A.txt" << "/home/vasanth/firmware_load/arducopter_param_A.params");
    code_checksum_process_model_A.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << a_checksum_location << a_params_location);

    //qDebug() << "code checksum file generated with exit code";

    QString generated_checksum_cmd_model_A = a_checksum_location;


    QFile file(generated_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }

    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line = in.readAll();
        QStringList split_text = line.split( "=" );
        QString checksum_generated_model_A = split_text.value( split_text.length()-1);
        model_A_value1 = checksum_generated_model_A;
        //qDebug()<< "generated checksum" << checksum_generated_model_A;
    }
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

    //QString calculated_checksum_cmd_model_A = "/home/vasanth/firmware_load/model_A_checksum.txt";
    QString calculated_checksum_cmd_model_A =  real_file_location + "/GoDrona GCS/Telemetry/model_A_checksum.txt";
    //qDebug()<<"sdadasdf"<<calculated_checksum_cmd_model_A;
    QFile file(calculated_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    if(file.exists()){
        while (!file.atEnd()) {
            QString line1 = in.readAll();
            QStringList split_text = line1.split( "=" );
            QString checksum_calculated_model_A = split_text.value( split_text.length()-1);
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

        QMessageBox msgBox;
        msgBox.setText("Model A - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
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

    //QString b_params_location = "/home/vinoth1/Documents/GoDrona GCS/Telemetry/model_A.params";
    //QString b_checksum_location = "/home/vinoth1/Documents/GoDrona GCS/Telemetry/new_model_B.txt";

    //qDebug()<<b_params_location;
    //qDebug()<<b_checksum_location;

    //QString b_params_location = _toolbox->settingsManager()->appSettings()->telemetrySavePath(); //_toolbox->settingsManager()->appSettings()->telemetrySavePath() + "/model_B.params";
    //QString b_checksum_location = _toolbox->settingsManager()->appSettings()->telemetrySavePath(); // + "/new_model_B.txt";

    real_file_location = real_file_location.remove("file://");
    QString b_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";
    QString b_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_model_B.txt";

    qDebug()<<b_params_location;
    qDebug()<<b_checksum_location;

    //code_checksum_process_model_B.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << "/home/vasanth/firmware_load/new_model_B.txt" << "/home/vasanth/firmware_load/arducopter_param_B.params");
    code_checksum_process_model_B.execute("openssl",QStringList()<< "dgst" << "-sha256" << "-out" << b_checksum_location << b_params_location);

    //qDebug() << "code checksum file generated with exit code";

    QString generated_checksum_cmd_model_B = b_checksum_location;

    QFile file(generated_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    if(file.exists()){
        while (!file.atEnd()) {
            QString line = in.readAll();
            QStringList split_text = line.split( "=" );
            QString checksum_generated_model_B = split_text.value( split_text.length()-1);
            model_B_value1 = checksum_generated_model_B;
            qDebug()<<checksum_generated_model_B;

        }
        checksum_calculation_process_model_B(real_file_location);
    }
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

    //QString calculated_checksum_cmd_model_B = "/home/vasanth/firmware_load/model_B_checksum.txt";
    //QString calculated_checksum_cmd_model_B =  _toolbox->settingsManager()->appSettings()->telemetrySavePath() + "/model_B_checksum.txt";
    QString calculated_checksum_cmd_model_B =  real_file_location + "/GoDrona GCS/Telemetry/model_B_checksum.txt";

    QFile file(calculated_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString checksum_calculated_model_B = split_text.value( split_text.length()-1);
        model_B_value2 = checksum_calculated_model_B;
        //qDebug()<<checksum_calculated_model_B;
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

        QMessageBox msgBox;
        msgBox.setText("Model B - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
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
    //QString filename = "/home/vasanth/firmware_load/model_B_change.params";
    //QString filename = _toolbox->settingsManager()->appSettings()->telemetrySavePath() + "/model_B.params";;
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
}*/


#include <iostream>
#include <fstream>
#include <string>
#include "FirmwareUpdate.h"
#include "ParameterEditorController.h"
#include <QMessageBox>

QString data_model_A_value1="a";
QString data_model_A_value2= "b";
QString data_model_B_value1="c";
QString data_model_B_value2="d";

QString code_model_A_value1="e";
QString code_model_A_value2="f";
QString code_model_B_value1="g";
QString code_model_B_value2="h";

FirmwareUpdate::FirmwareUpdate(QObject *parent)
    : QObject{parent}
{

}
void FirmwareUpdate::checksum_generation_process_model_A(QString real_file_location)
{
    QProcess code_checksum_process_model_A;
    qDebug()<<"In checksum generation process model A";

    real_file_location = real_file_location.remove("file://");
    QString a_data_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_A.params";
    QString a_data_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_data_A_checksum.txt";

    QString a_code_location = real_file_location + "/GoDrona GCS/Telemetry/firmware_A.apj";
    QString a_code_checksum_location = real_file_location + "/GoDrona GCS/Telemetry/new_code_A_checksum.txt";

    qDebug()<<a_data_params_location;
    qDebug()<<a_data_checksum_location;


    QFile file(a_data_params_location);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << "hashData---->"<<hashData.toHex();
        data_model_A_value1 = hashData.toHex();
    }

    QFile file1(a_code_location);
    if (file1.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file1.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        code_model_A_value1 = hashData.toHex();
    }

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

    qDebug()<<"in checksum_calculation_process_model_A";
    QString calculated_data_checksum_cmd_model_A =  real_file_location + "/GoDrona GCS/Telemetry/data_A_checksum.txt";
    qDebug()<<"sdadasdf"<<calculated_data_checksum_cmd_model_A;
    QFile file(calculated_data_checksum_cmd_model_A);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString data_checksum_calculated_model_A = split_text.value( split_text.length()-1);
        data_model_A_value2 = data_checksum_calculated_model_A;
        qDebug()<<"existing checksum"<<data_checksum_calculated_model_A;
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
           // code_checksum_calculated_model_A = code_checksum_calculated_model_A.trimmed();
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

    qDebug()<<"comparing Model A";
    QString data_list1 = data_model_A_value1;
    QString data_list2 = data_model_A_value2;

    QString code_list1 = code_model_A_value1;
    QString code_list2 = code_model_A_value2;

    data_list2 = data_list2.remove("\n");
    data_list2 = data_list2.remove(" ");

    code_list2 = code_list2.remove("\n");
    code_list2 = code_list2.remove(" ");

    qDebug() <<"Model Generated"<< data_list1;
    qDebug() << "Model Calculated"<< data_list2;

    qDebug() << "Code Generated"<< code_list1;
    qDebug() << "Code Calculated"<< code_list2;

    if((data_list1 == data_list2) && (code_list1 == code_list2)){

        QMessageBox msgBox;
        msgBox.setText("Model A - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
        load_file_model_A(real_file_location);
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
void FirmwareUpdate::load_file_model_A(QString real_file_location)
{
    qDebug()<<"load file model A";
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
    qDebug()<<"In checksum generation process model B";

    real_file_location = real_file_location.remove("file://");

    QString b_data_params_location = real_file_location + "/GoDrona GCS/Telemetry/model_B.params";
    QString b_data_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_data_B_checksum.txt";

    QString b_code_location = real_file_location + "/GoDrona GCS/Telemetry/firmware_B.apj";
    QString b_code_checksum_location =  real_file_location + "/GoDrona GCS/Telemetry/new_code_B_checksum.txt";

    qDebug()<<b_data_params_location;
    qDebug()<<b_data_checksum_location;

    QFile file(b_data_params_location);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << "hashData---->"<<hashData.toHex();
        data_model_B_value1 = hashData.toHex();
    }

    QFile file2(b_code_location);
    if (file2.open(QIODevice::ReadOnly)) {
        QByteArray fileData = file2.readAll();
        QByteArray hashData = QCryptographicHash::hash(fileData, QCryptographicHash::Sha256);
        qDebug() << hashData.toHex();
        code_model_B_value1 = hashData.toHex();
    }

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

    qDebug()<<"in checksum calculation process model B";
    QString calculated_data_checksum_cmd_model_B =  real_file_location + "/GoDrona GCS/Telemetry/data_B_checksum.txt";
    qDebug()<<"sdadasdf"<<calculated_data_checksum_cmd_model_B;
    QFile file(calculated_data_checksum_cmd_model_B);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){

    }
    QTextStream in(&file);
    while (!file.atEnd()) {
        QString line1 = in.readAll();
        QStringList split_text = line1.split( "=" );
        QString data_checksum_calculated_model_B = split_text.value( split_text.length()-1);
        data_model_B_value2 = data_checksum_calculated_model_B;
        qDebug()<<data_checksum_calculated_model_B;
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
    qDebug()<<"in compare file model B";
    QString data_list1 = data_model_B_value1;
    QString data_list2 = data_model_B_value2;

    QString code_list1 = code_model_B_value1;
    QString code_list2 = code_model_B_value2;

    data_list2 = data_list2.remove("\n");
    data_list2 = data_list2.remove(" ");

    code_list2 = code_list2.remove("\n");
    code_list2 = code_list2.remove(" ");

    qDebug() <<"Model Generated"<< data_list1;
    qDebug() << "Model Calculated"<< data_list2;

    qDebug() << "Code Generated"<< code_list1;
    qDebug() << "Code Calculated"<< code_list2;

    if((data_list1 == data_list2) && (code_list1 == code_list2)){

        QMessageBox msgBox;
        msgBox.setText("Model B - The checksum matches. Please continue");
        msgBox.setStyleSheet("color:white;background:#05324D");
        msgBox.setDefaultButton(QMessageBox::Ok);
        msgBox.exec();
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
   qDebug()<<"load file model B";
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


