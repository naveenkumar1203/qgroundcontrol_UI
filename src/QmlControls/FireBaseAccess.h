#ifndef FIREBASEACCESS_H
#define FIREBASEACCESS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonObject>
#include <QJsonDocument>
#include <QByteArray>

class FireBaseAccess : public QObject
{
    Q_OBJECT
public:
    explicit FireBaseAccess(QObject *parent = nullptr);
    ~FireBaseAccess();

    void new_user_account_creation(const QString &email, const QString &password);
    void new_user_POST(const QString &url,const QJsonDocument &payload);
    void newUser_parseResponse(const QByteArray &response);

    void registered_user_signup(const QString &email, const QString &password);
    void registered_user_POST(const QString &url,const QJsonDocument &payload);
    void registeredUser_parseResponse(const QByteArray &response);

    void userDetails_parseResponse(const QByteArray &response);

    void password_reset_POST(const QString &url,const QJsonDocument &payload);
    void password_reset_parseResponse(const QByteArray &response);


    Q_INVOKABLE void new_user_registration(const QString &industry,
                                           const QString &name,
                                           const QString &mail,
                                           const QString &number,
                                           const QString &address,
                                           const QString &locality,
                                           const QString &password);

    Q_INVOKABLE void registered_user(const QString &mail,
                                     const QString &password);


    Q_INVOKABLE void reset_password(const QString &mail);

    Q_PROPERTY(QString industry READ industry WRITE setindustry NOTIFY industryChanged)
    Q_PROPERTY(QString mail READ mail WRITE setMail NOTIFY mailChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(QString locality READ locality WRITE setLocality NOTIFY localityChanged)

    Q_PROPERTY(QString firebasejsonname READ firebasejsonname WRITE setFirebasejsonname NOTIFY firebasejsonnameChanged)

    QString name() const;
    void setName(const QString &newName);

    QString firebasejsonname() const;
    void setFirebasejsonname(const QString &newFirebasejsonname);

    QString industry() const;
    void setindustry(const QString &newIndustry);

    QString mail() const;
    void setMail(const QString &newMail);

    QString number() const;
    void setNumber(const QString &newNumber);

    QString address() const;
    void setAddress(const QString &newAddress);

    QString locality() const;
    void setLocality(const QString &newLocality);

public slots:
    void new_user_network_reply_read();
    void registered_user_network_reply_read();
    void reset_password_network_reply_read();
    void rds_data_network_reply_read();
    void user_details_network_reply_read();

signals:
    void userRegisteredSuccessfully();
    void mailAlreadyExists();
    void emailNotFound();
    void successfullLogin();
    void incorrectPassword();
    void resetMailFound();
    void resetMailNotFound();

    void nameChanged();

    void firebasejsonnameChanged();

    void industryChanged();

    void mailChanged();

    void numberChanged();

    void addressChanged();

    void localityChanged();

private:
    QString m_apikey = "AIzaSyAg_vERDdSdzA6cIjCq7VrDKPqoihAFEDU";
    QNetworkAccessManager *m_NetworkAccessManager;
    QNetworkAccessManager *m_NetworkAccessManager1;
    QNetworkReply *m_NetworkReply;
    QNetworkReply *m_NetworkReply1;

    QString m_name;
    QString m_firebasejsonname;
    QString m_industry;
    QString m_mail;
    QString m_number;
    QString m_address;
    QString m_locality;
};

#endif // FIREBASEACCESS_H
