#include "AWSOperations.h"
#include "SettingsManager.h"

//#pragma push_macro("slots")
//#undef slots
//#include "Python.h"
//#pragma pop_macro("slots")

QString user_text_file_name;
QString user_text_file_folder;
QString user_download_path;
QString text_file_path;

const Aws::String AWS_ACCESS_KEY_ID = "";
const Aws::String AWS_SECRET_ACCESS_KEY = "";
static const char * ALLOCATION_TAG = " ";
std::string file_to_upload;
std::string file_name_aws;
std::string folder_name_aws;
//Aws::String aws_file_name(file_name_aws.c_str(), file_name_aws.size());;
//Aws::String file_to_upload_aws(file_to_upload.c_str(), file_to_upload.size());;

AWSOperations::AWSOperations(QObject *parent)
    : QObject{parent}
{

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

void AWSOperations::s3_function(QString user_name,QString file_name,QString folder_location)
{
    qDebug()<<"inside s3 function";
    user_text_file_name = user_name;
    qDebug()<<"user name........"<<user_name;
    qDebug()<<"file name........."<<file_name;
    qDebug()<<"folder location...."<<folder_location;

    Aws::SDKOptions options;

    Aws::InitAPI(options);
    {
    const Aws::String bucket_name = "trials3bucket-fileupload";

    qDebug()<<"1";
    QString aws_object = folder_location + "/" +file_name;
    file_to_upload = aws_object.toStdString();
    const Aws::String object_name(file_to_upload.c_str(), file_to_upload.size()); //user_name + "/" + "";

    qDebug()<<"2";
    //QString file_name_in_aws = folder_location.mid(file_name.lastIndexOf("/")+1);
    user_text_file_folder = file_name;
    //file_name_aws = file_name_in_aws.toStdString();

    qDebug()<<"3";
    //QString folder_name_in_aws = folder_location.mid(file_name.lastIndexOf("/")+1);
    //folder_name_aws = folder_name_in_aws.toStdString();

    qDebug()<<"4";
    Aws::Client::ClientConfiguration clientConfig;
    clientConfig.region = "ap-south-1";

    qDebug()<<"5";
    PutObject(bucket_name, object_name, clientConfig);

    }

    Aws::ShutdownAPI(options);
}
bool AWSOperations:: PutObject(const Aws::String &bucketName,
                           const Aws::String &fileName,
                           const Aws::Client::ClientConfiguration &clientConfig) {

    qDebug()<<"inside putobject";

    Aws::Auth::AWSCredentials credentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

    Aws::S3::S3Client s3_client(credentials,Aws::MakeShared<Aws::S3::S3EndpointProvider>(ALLOCATION_TAG),clientConfig);

    Aws::S3::Model::PutObjectRequest request;
    request.SetBucket(bucketName);
    //We are using the name of the file as the key for the object in the bucket.
    //However, this is just a string and can be set according to your retrieval needs.
    QString aws_user_name = user_text_file_name;
    std::string aws_create_folder = aws_user_name.toStdString();
    Aws::String aws_folder_name(aws_create_folder.c_str(), aws_create_folder.size());

    QString file_name = user_text_file_folder;
    std::string file_upload = file_name.toStdString();
    Aws::String aws_file_upload(file_upload.c_str(), file_upload.size());
    request.SetKey(aws_folder_name+ "/" + aws_file_upload);

    std::cerr << "aws file to be uploaded name " <<fileName;
    std::cerr << "aws folder name " <<aws_folder_name;
    std::cerr << "aws file uploaded name " <<aws_file_upload;


    std::shared_ptr<Aws::IOStream> inputData =
            Aws::MakeShared<Aws::FStream>("SampleAllocationTag",
                                          fileName.c_str(),
                                          std::ios_base::in | std::ios_base::binary);

    if (!*inputData) {
        std::cerr << "Error unable to read file " << fileName << std::endl;
        return false;
    }

    request.SetBody(inputData);

    Aws::S3::Model::PutObjectOutcome outcome =
            s3_client.PutObject(request);

    if (!outcome.IsSuccess()) {
        std::cerr << "Error: PutObject: " <<
                  outcome.GetError().GetMessage() << std::endl;
    }
    else {
        std::cout << "Added object '" << fileName << "' to bucket '"
                  << bucketName << "'.";
    }

    return outcome.IsSuccess();
}

void AWSOperations::read_text_file(QString user_text_file,QString user_text_file_folder)
{
    qDebug()<<"inside read";
    qDebug()<<user_text_file << user_text_file_folder;

    user_text_file_name = user_text_file;
    QString filepath = user_text_file_folder + "/" + user_text_file + ".txt";
    text_file_path = filepath;
    qDebug()<<filepath;

    //QString filepath = "/home/vinoth1/Documents/GoDrona GCS/Telemetry/Dude.txt";
    //QString filepath = telemetry_location + "/" + user_name + ".txt";

    QFile file(filepath);
    file.open(QIODevice::WriteOnly | QIODevice::ReadOnly | QIODevice::Text |QIODevice::Append);
    //if (!file.open(QIODevice::ReadOnly | QIODevice::Text | QIODevice::WriteOnly | QIODevice::Append)){
    //    m_name.clear();
    //    qDebug()<<"error in creating file";
    //}
    //else {
        qDebug()<<"inside else";
        m_name.clear();

        Aws::SDKOptions options;

        Aws::InitAPI(options);
        {
            const Aws::String bucket_name = "trials3bucket-fileupload";
            const Aws::String object_name = "/home/vinoth1/Downloads/Screenshot from 2023-04-14 19-35-07.png";

            const Aws::String objectName ="Quantum_communication.pdf";
            Aws::Client::ClientConfiguration clientConfig;
            clientConfig.region = "ap-south-1";

            const Aws::String bucket_name_list = "trials3bucket-fileupload";
            ListObjects(bucket_name_list, clientConfig);
        }
    //}

}

void AWSOperations::download_file(QString file_to_download,QString place_to_download){

    Aws::SDKOptions options;

    Aws::InitAPI(options);
    {
        const Aws::String bucket_name = "trials3bucket-fileupload";

        user_download_path = place_to_download;

        QString aws_folder_path = user_text_file_name + "/" + file_to_download  + ".csv";
        std::string aws_file_download = aws_folder_path.toStdString();
        const Aws::String objectName(aws_file_download.c_str(), aws_file_download.size());  //="Quantum_communication.pdf";

        std::cerr << "aws file to be downloaded name " <<objectName;


        Aws::Client::ClientConfiguration clientConfig;
        clientConfig.region = "ap-south-1";

        const Aws::String bucket_name_list = "trials3bucket-fileupload";
        GetObject(objectName, bucket_name, clientConfig);

    }

    Aws::ShutdownAPI(options);
}

bool AWSOperations::GetObject(const Aws::String &objectKey,
                           const Aws::String &fromBucket,
                           const Aws::Client::ClientConfiguration &clientConfig) {
    //Aws::S3::S3Client client(clientConfig);

    Aws::Auth::AWSCredentials credentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

    Aws::S3::S3Client s3_client(credentials,Aws::MakeShared<Aws::S3::S3EndpointProvider>(ALLOCATION_TAG),clientConfig);

    Aws::S3::Model::GetObjectRequest request;
    request.SetBucket(fromBucket);
    request.SetKey(objectKey);

    Aws::S3::Model::GetObjectOutcome outcome =
            s3_client.GetObject(request);

    if (!outcome.IsSuccess()) {
        const Aws::S3::S3Error &err = outcome.GetError();
        std::cerr << "Error: GetObject: " <<
                  err.GetExceptionName() << ": " << err.GetMessage() << std::endl;
    }
    else {
        std::cout << "Successfully retrieved '" << objectKey << "' from '"
                  << fromBucket << "'." << std::endl;

        QString user_location = user_download_path + ".csv";
        //std::string local_file_name = "/home/vinoth1/Downloads/aws/" + objectKey;
        std::string local_file_name = user_location.toStdString();
        qDebug()<<"download........."<<user_location;
        std::ofstream local_file(local_file_name, std::ios::binary);
        auto &retrieved = outcome.GetResult().GetBody();
        local_file << retrieved.rdbuf();
        std::cout << "Done!";
    }

    return outcome.IsSuccess();
}

bool AWSOperations::ListObjects(const Aws::String &bucketName,
                             const Aws::Client::ClientConfiguration &clientConfig) {
    //Aws::S3::S3Client s3_client(clientConfig);

    Aws::Auth::AWSCredentials credentials(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

    Aws::S3::S3Client s3_client(credentials,Aws::MakeShared<Aws::S3::S3EndpointProvider>(ALLOCATION_TAG),clientConfig);

    Aws::S3::Model::ListObjectsRequest request;
    //request.WithBucket(bucketName).WithDelimiter("").WithPrefix("aws_cpp/");
    QString search_in = user_text_file_name + "/";
    std::string aws_search_in =search_in.toStdString();
    const Aws::String aws_objectName(aws_search_in.c_str(), aws_search_in.size());  //="Quantum_communication.pdf";

    request.WithBucket(bucketName).WithDelimiter("").WithPrefix(aws_objectName);

    auto outcome = s3_client.ListObjects(request);

    if (!outcome.IsSuccess()) {
        std::cerr << "Error: ListObjects: " <<
                  outcome.GetError().GetMessage() << std::endl;
    }
    else {
        Aws::Vector<Aws::S3::Model::Object> objects =
                outcome.GetResult().GetContents();

        for (Aws::S3::Model::Object &object: objects) {
            std::cout << object.GetKey() << std::endl;
            std::string s(object.GetKey().c_str(), object.GetKey().size());
            QString s3file_with_slash = QString::fromUtf8(s.c_str());;
            QString s3file_without_slash = s3file_with_slash.mid(s3file_with_slash.lastIndexOf("/") + 1);
            qDebug()<<"write to file ....... "<<s3file_without_slash;
            QFile file(text_file_path);
            if (!file.open(QIODevice::Append)) {
                qDebug() << "unable to write";
            }

            QTextStream in(&file);
            in << s3file_without_slash;
//            QString line;

//            while (!file.atEnd()) {
//                line = in.readLine();
//                m_name << line.split(".csv");
//                m_name.removeAll("");
//                m_name.removeDuplicates();
//            }
        }
    }
    QFile file(text_file_path);

    QTextStream in(&file);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        qDebug()<<"error";
    }
    QString line;

    while (!file.atEnd()) {
        line = in.readLine();
        m_name << line.split(".csv");
        m_name.removeAll("");
        m_name.removeDuplicates();
    }

    return outcome.IsSuccess();
}









//void AWSOperations::s3_function(QString user_name,QString file_name,QString folder_location)
//{
//    qDebug()<<"inside s3 function";
//    qDebug()<<"user name........"<<user_name;
//    user_text_file_name = user_name;
//    user_text_file_folder = folder_location;

//    int argc;
//    wchar_t * argv[3];
//    argc = 3;

//    auto usernameString = user_name.toStdWString();
//    auto username = const_cast<wchar_t *>(usernameString.c_str());

//    auto filenameString = file_name.toStdWString();
//    auto filename = const_cast<wchar_t *>(filenameString.c_str());

//    auto foldernameString = folder_location.toStdWString();
//    auto foldername = const_cast<wchar_t *>(foldernameString.c_str());

//    argv[0] = username;
//    argv[1] = filename;
//    argv[2] = foldername;


//    Py_Initialize();
//    PySys_SetArgv(argc, argv);
//    PyRun_SimpleString("import io \n"
//                       "import boto3 \n"
//                       "from botocore.exceptions import ClientError \n"

//                       "ACCESS_SECRET = \"D4Tgd/cojcrbn3oiKhL5f7QnsDinmESmyIqDhDSO\" \n"
//                       "ACCESS_KEY = \"AKIAUJC3XHHYKL7RTI74\" \n"

//                       "s3_client = boto3.client(\'s3\', region_name=\'ap-south-1\', aws_access_key_id=ACCESS_KEY,aws_secret_access_key=ACCESS_SECRET) \n"

//                       "bucket_name = \"trials3bucket-fileupload\" \n"

//                       "directory_name = argv[0] \n"
//                       "s3_client.put_object(Bucket=bucket_name, Key=(directory_name+'/')) \n");
//    Py_Finalize();

//    //    FILE* file;
//    //    int argc;
//    //    wchar_t * argv[3];

//    //    argc = 3;

//    //    auto usernameString = user_name.toStdWString();
//    //    auto username = const_cast<wchar_t *>(usernameString.c_str());

//    //    auto filenameString = file_name.toStdWString();
//    //    auto filename = const_cast<wchar_t *>(filenameString.c_str());

//    //    auto foldernameString = folder_location.toStdWString();
//    //    auto foldername = const_cast<wchar_t *>(foldernameString.c_str());

//    //    argv[0] = username;
//    //    argv[1] = filename;
//    //    argv[2] = foldername;

//    //    //Py_SetProgramName(argv[0]);
//    //    Py_Initialize();
//    //    PySys_SetArgv(argc, argv);
//    //    file = fopen("/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_folder.py","r");
//    //    PyRun_SimpleFile(file, "/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_folder.py");
//    //    Py_Finalize();
//}

//void AWSOperations::download_file(QString file_to_download,QString place_to_download)
//{
//    FILE* file;
//    int argc;
//    wchar_t * argv[2];

//    argc = 2;

//    QString aws_s3_location = user_text_file_name + "/" + file_to_download + ".csv";
//    auto filenameString = aws_s3_location.toStdWString();
//    auto filename = const_cast<wchar_t *>(filenameString.c_str());

//    QString aws_s3_file_download_location = place_to_download + ".csv";
//    auto foldernameString = aws_s3_file_download_location.toStdWString();
//    auto foldername = const_cast<wchar_t *>(foldernameString.c_str());

//    argv[0] = filename;
//    argv[1] = foldername;

//    //Py_SetProgramName(argv[0]);
//    Py_Initialize();
//    PySys_SetArgv(argc, argv);
//    file = fopen("/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_download.py","r");
//    PyRun_SimpleFile(file, "/home/vinoth1/Projects/Ajay/DataBase/aws_s3_python_working/aws_s3_download.py");
//    Py_Finalize();
//}
