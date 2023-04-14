#include "AWSOperations.h"
#include "SettingsManager.h"

#pragma push_macro("slots")
#undef slots
#include "Python.h"
#pragma pop_macro("slots")
//#include "Python.h"


QString user_text_file_name;
QString user_text_file_folder;
QStringList split_text;

AWSOperations::AWSOperations(QObject *parent)
    : QObject{parent}
{

}

void AWSOperations::s3_function(QString user_name,QString file_name,QString folder_location)
{
    qDebug()<<"inside s3 function";
    qDebug()<<"user name........"<<user_name;
    user_text_file_name = user_name;
    user_text_file_folder = folder_location;
    qDebug()<<user_name;
    qDebug()<<folder_location;
    qDebug()<<file_name;

    FILE* file;
    int argc;
    wchar_t * argv[3];

    argc = 3;

    //    std::wstring testWstring  = user_name.toStdWString();

    //    wchar_t *wc = reinterpret_cast<wchar_t *>(user_name.data());
    //    const wchar_t *cwc = reinterpret_cast<const wchar_t *>(user_name.utf16());

    auto usernameString = user_name.toStdWString();
    auto username = const_cast<wchar_t *>(usernameString.c_str());

    auto filenameString = file_name.toStdWString();
    auto filename = const_cast<wchar_t *>(filenameString.c_str());

    auto foldernameString = folder_location.toStdWString();
    auto foldername = const_cast<wchar_t *>(foldernameString.c_str());

    //argv[0] = L"mypy.py"
    //argv[0] = testWstring.c_str();
    argv[0] = username;
    argv[1] = filename;
    argv[2] = foldername;

    //Py_SetProgramName(argv[0]);
    Py_Initialize();
    PySys_SetArgv(argc, argv);
    //file = fopen("/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_folder.py","r");
    file = fopen("/home/vasanth/AWS/aws_s3_folder.py","r");
    //PyRun_SimpleFile(file, "/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_folder.py");
    PyRun_SimpleFile(file, "/home/vasanth/AWS/aws_s3_folder.py");

    Py_Finalize();
}

void AWSOperations::read_text_file(QString user_text_file,QString user_text_file_folder)
{
    qDebug()<<"inside read";
    qDebug()<<user_text_file << user_text_file_folder;
    user_text_file_name = user_text_file ;

    QString filepath = user_text_file_folder + "/" + user_text_file + ".txt";
    qDebug()<<filepath;

    //QString filepath = "/home/vinoth1/Documents/GoDrona GCS/Telemetry/Dude.txt";
    //QString filepath = telemetry_location + "/" + user_name + ".txt";

    QFile file(filepath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        qDebug()<<"error";
    }
    QTextStream in(&file);
    QString line;

    while (!file.atEnd()) {
        line = in.readLine();
        m_name << line.split(".csv");
        m_name.removeAll("");
        m_name.removeDuplicates();
    }

}

void AWSOperations::download_file(QString file_to_download,QString place_to_download)
{
    FILE* file;
    int argc;
    wchar_t * argv[2];

    argc = 2;

    QString aws_s3_location = user_text_file_name + "/" + file_to_download + ".csv";
    auto filenameString = aws_s3_location.toStdWString();
    auto filename = const_cast<wchar_t *>(filenameString.c_str());

    QString aws_s3_file_download_location = place_to_download + ".csv";
    auto foldernameString = aws_s3_file_download_location.toStdWString();
    auto foldername = const_cast<wchar_t *>(foldernameString.c_str());

    argv[0] = filename;
    argv[1] = foldername;

    //Py_SetProgramName(argv[0]);
    Py_Initialize();
    PySys_SetArgv(argc, argv);
    //file = fopen("/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_download.py","r");
    //PyRun_SimpleFile(file, "/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_download.py");
    file = fopen("/home/vasanth/AWS/aws_s3_download.py","r");
    PyRun_SimpleFile(file, "/home/vasanth/AWS/aws_s3_download.py");


    Py_Finalize();
}

QStringList AWSOperations::name() const
{
    return m_name;
    m_name.empty();
}

void AWSOperations::setName(const QStringList &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

