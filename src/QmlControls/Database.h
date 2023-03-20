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

    Q_PROPERTY(QString user READ user WRITE setUser NOTIFY userChanged)

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

    QString user() const;
    void setUser(const QString &newUser);

    void vehicleData(const QString &time, const QString &rollValue);

signals:
    void record_found();
    void incorrect_password();
    void no_record_found();
    void userChanged();

public slots:

private:
    QString m_user;

};

#endif // DATABASE_H
