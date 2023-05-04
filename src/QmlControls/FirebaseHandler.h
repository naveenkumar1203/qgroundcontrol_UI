#ifndef FIREBASEHANDLER_H
#define FIREBASEHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkAccessManagerWithPatch.h>

class FirebaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit FirebaseHandler(QObject *parent = nullptr);
    ~FirebaseHandler();

    Q_INVOKABLE void access_firebase(const QString &text, const QString &model_name, const QString &drone_name, const QString &uin);


signals:

public slots:
    void network_reply_read();

private:
    QNetworkReply *m_networkreply;
    QNetworkAccessManager *m_networkAccessManager;
    QNetworkAccessManagerWithPatch *m_networkAccessManagerWithPatch;
};

#endif // FIREBASEHANDLER_H
