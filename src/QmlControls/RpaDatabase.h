#ifndef RPADATABASE_H
#define RPADATABASE_H

#include <QSqlRecord>
#include <QSqlField>
#include <QtSql>
#include <QObject>
#include <QSqlDatabase>
#include <QTableView>

class RpaDatabase : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit RpaDatabase(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void callSql(QString queryString);

    Q_INVOKABLE void addData(const QString &TYPE,const QString &MODEL_NAME, const QString &DRONE_NAME, const QString &UIN);

    Q_INVOKABLE void existingUIN(const QString &uin);

    Q_INVOKABLE void checkboxSqlfly(QString queryString);

    Q_INVOKABLE void checkboxSqledit(QString queryString);

    Q_INVOKABLE void update_table_contents(const QString &TYPE,const QString &MODEL_NAME, const QString &DRONE_NAME, const QString &UIN);

    Q_INVOKABLE void delete_table_contents(QString queryString);

    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)

    Q_PROPERTY(QString model READ model WRITE setModel NOTIFY modelChanged)

    Q_PROPERTY(QString uin READ uin WRITE setUin NOTIFY uinChanged)

    Q_PROPERTY(QString droneName READ droneName WRITE setDroneName NOTIFY droneNameChanged)


    QString type() const;
    void setType(const QString &newType);

    QString model() const;
    void setModel(const QString &newModel);

    QString uin() const;
    void setUin(const QString &newUin);

    QString droneName() const;
    void setDroneName(const QString &newDroneName);

private :
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;

    QString m_type;

    QString m_model;

    QString m_droneName;

    QString m_uin;

signals:
    void uin_record_found();
    void uin_record_notfound();
    void modelChanged();
    void typeChanged();
    void uinChanged();
    void droneNameChanged();
};

#endif // RPADATABASE_H
