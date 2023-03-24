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

    void username_database(const QString &mail);

signals:
    void record_found();
    void incorrect_password();
    void no_record_found();
    void userChanged();
    void name_record_found();
    void mail_record_found();
    void number_record_found();
    void name_mail_record_found();

public slots:

private:
    QString m_user;

};

#endif // DATABASE_H
