#ifndef AWSOperations_H
#define AWSOperations_H

#include <QObject>
#include <QDebug>
#include <QFile>

#include <iostream>
#include <fstream>
#include <sys/stat.h>
#include <aws/core/Aws.h>
#include <aws/s3/S3Client.h>
#include <aws/s3/model/PutObjectRequest.h>
#include "aws/core/auth/AWSCredentialsProvider.h"
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/ListObjectsRequest.h>
using namespace Aws::Auth;

class AWSOperations : public QObject
{
    Q_OBJECT
public:
    explicit AWSOperations(QObject *parent = nullptr);

    Q_INVOKABLE void s3_function(QString user_name,QString file_name,QString folder_location);
    Q_INVOKABLE void read_text_file(QString user_text_file_name,QString user_text_file_folder);
    Q_INVOKABLE void download_file(QString file_to_download,QString place_to_download);

    Q_PROPERTY(QStringList name READ name WRITE setName NOTIFY nameChanged)

    QStringList name() const;
    void setName(const QStringList &newName);

    bool PutObject(const Aws::String &bucketName,
                               const Aws::String &fileName,
                               const Aws::Client::ClientConfiguration &clientConfig);

    bool GetObject(const Aws::String &objectKey,
                               const Aws::String &fromBucket,
                               const Aws::Client::ClientConfiguration &clientConfig);


    bool ListObjects(const Aws::String &bucketName,
                                 const Aws::Client::ClientConfiguration &clientConfig);

//    QString user_text_file_name;
//    QString user_text_file_folder;
//    QStringList split_text;

signals:
    void listadded();

    void nameChanged();

private:
    QStringList m_name;
};

#endif // AWSOperations_H
