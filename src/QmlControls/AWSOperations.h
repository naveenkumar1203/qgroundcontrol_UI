#ifndef AWSOperations_H
#define AWSOperations_H

#include <QObject>
#include <QDebug>
#include <QFile>

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

signals:
    void listadded();

    void nameChanged();

private:
    QStringList m_name;
};

#endif // AWSOperations_H
