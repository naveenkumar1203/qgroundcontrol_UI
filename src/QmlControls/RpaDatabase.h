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

    Q_INVOKABLE void checkboxSql(QString queryString);

    Q_PROPERTY(QString model READ model WRITE setModel NOTIFY modelChanged)

    QString model() const;
    void setModel(const QString &newModel);

private :
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;


    QString m_model;

signals:
    void uin_record_found();
    void uin_record_notfound();

    void modelChanged();
};

#endif // RPADATABASE_H
