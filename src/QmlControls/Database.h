#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>

#include <QtSql>
#include <QSqlDatabase>
#include <QDebug>
#include "Vehicle.h"

class Vehicle;

class AjayDatabase : public QObject
{
    Q_OBJECT
public:
    explicit AjayDatabase(QObject *parent = nullptr);

    Q_INVOKABLE void newUserData(const QString &industry,
                                 const QString &name,
                                 const QString &mail,
                                 const QString &number,
                                 const QString &address,
                                 const QString &locality,
                                 const QString &password);

    Q_INVOKABLE void loginExistingUser(const QString &mail,
                                       const QString &password);

    Q_INVOKABLE void change_password(const QString &mail,
                                     const QString &newPassword);

    Q_INVOKABLE void signupExistingUsername(const QString &name);

    Q_INVOKABLE void signupExistingUsermail(const QString &mail);

    Q_INVOKABLE void signupExistingUsernumber(const QString &number);

//    Q_INVOKABLE void existingUserProfilename(const QString &name);

    Q_INVOKABLE void existingUserProfilemail(const QString &mail);

//    Q_INVOKABLE void existingUserProfilenumber(const QString &number);

    Q_INVOKABLE void forgotPasswordmail(const QString &mail);

    Q_INVOKABLE void update_profile_contents(const QString &name,
                                             const QString &mail,
                                             const QString &number,
                                             const QString &address,
                                             const QString &locality,
                                             const QString &password);

    Q_INVOKABLE void logout();

    void username_database(const QString &mail);

    Q_PROPERTY(QString industry READ industry WRITE setIndustry NOTIFY industryChanged)

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

    Q_PROPERTY(QString mail READ mail WRITE setMail NOTIFY mailChanged)

    Q_PROPERTY(QString number READ number WRITE setNumber NOTIFY numberChanged)

    Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)

    Q_PROPERTY(QString locality READ locality WRITE setLocality NOTIFY localityChanged)

    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)

    Q_PROPERTY(QString awsname READ awsname WRITE setAwsname NOTIFY awsnameChanged)

    QString name() const;
    void setName(const QString &newName);

    QString mail() const;
    void setMail(const QString &newMail);

    QString number() const;
    void setNumber(const QString &newNumber);

    QString address() const;
    void setAddress(const QString &newAddress);

    QString locality() const;
    void setLocality(const QString &newLocality);

    QString password() const;
    void setPassword(const QString &newPassword);

    QString industry() const;
    void setIndustry(const QString &newIndustry);

    QString awsname() const;
    void setAwsname(const QString &newAwsname);

signals:
    //void connection_not_established();
    void record_found();
    void incorrect_password();
    void no_record_found();
    void userChanged();
    void name_record_found();
    void mail_record_found();
    void number_record_found();
    void close_database();
    void nameChanged();
    void mailChanged();
    void numberChanged();
    void addressChanged();
    void localityChanged();
    void passwordChanged();
    void industryChanged();
    void connectionNotopened();
    void forgotmail_record_notfound();

    void awsnameChanged();

public slots:

private:
    QString m_user;
    QString m_name;
    QString m_mail;
    QString m_number;
    QString m_address;
    QString m_locality;
    QString m_password;
    QString m_industry;
    QString m_awsname;
};

#endif // DATABASE_H
