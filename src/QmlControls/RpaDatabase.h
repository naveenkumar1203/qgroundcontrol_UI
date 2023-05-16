#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QNetworkAccessManager>
#include <QNetworkAccessManagerWithPatch.h>
#include <QNetworkReply>
#include <QDebug>
#include <QVariantMap>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QJsonObject>

class TableModel : public QAbstractTableModel
{
    Q_OBJECT
public:
    enum Roles {
        CheckBoxRole = Qt::UserRole + 1,
        TypeRole,
        ModelRole,
        DroneRole,
        UinRole,
        SqlEditRole
    };

    explicit TableModel(QObject *parent = 0);
    ~TableModel();

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex & parent = QModelIndex()) const override;
    Q_INVOKABLE QVariant data (const QModelIndex & index, int role) const override;

    virtual bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE void delete_query(const QString &name, const QString &number);

    Q_INVOKABLE void existingUIN(const QString &userName,const QString &uinText);

    Q_INVOKABLE void add_rpa(const QString &droneType,const QString &droneModel,const QString &droneName,const QString &uinText);

    Q_INVOKABLE void getData();

    Q_INVOKABLE void manageRpaClicked(const QString &userName);

    Q_INVOKABLE void modelSelected(const QString &number);

    Q_INVOKABLE void firmwareupgrade_data();

    void modelSelected_list();

    void firmware_apply_read_addData(const QByteArray &response);

    Q_INVOKABLE void edit_rpa(const QString &name, const QString &number);

    Q_INVOKABLE void update_rpa(const QString &droneType,const QString &droneModel,const QString &droneName,const QString &uinText);

    Q_PROPERTY(QString droneName READ droneName WRITE setDroneName NOTIFY droneNameChanged)
    Q_PROPERTY(QString uin READ uin WRITE setUin NOTIFY uinChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(QStringList firmwarelog_list READ firmwarelog_list WRITE setFirmwarelog_list NOTIFY firmwarelog_listChanged)

    QString droneName() const;
    void setDroneName(const QString &newDroneName);

    QString uin() const;
    void setUin(const QString &newUin);

    QString type() const;
    void setType(const QString &newType);

    QString model() const;
    void setModel(const QString &newModel);

    QStringList firmwarelog_list() const;
    void setFirmwarelog_list(const QStringList &newFirmwarelog_list);

protected:
    QHash<int, QByteArray> roleNames() const override;
private:
    QList<QString> typelist;
    QList<QString> modellist;
    QList<QString> dronelist;
    QList<QString> uinlist;
    QHash<int, QByteArray> m_roleNames;
    QNetworkReply *m_networkreply;
    QNetworkAccessManager *m_networkAccessManager;
    QNetworkAccessManagerWithPatch *m_networkAccessManagerWithPatch;


    QString m_droneName;

    QString m_uin;

    QString m_type;

    QString m_model;

    QStringList m_firmwarelog_list;

public slots:
    void network_reply_read();
    void network_reply_read_addData();
    void network_reply_read_getData();
    void firmwarelog_contain_data();
    void get_updated_rpaData();

signals:
    void uinFound();
    void uinNotFound();
    void dataAdded();
    void showTable();
    void dataDeleted();

    void droneNameChanged();
    void uinChanged();
    void typeChanged();
    void modelChanged();
    void firmwarelog_listChanged();
    void rpa_data_update();

};

#endif // TABLEMODEL_H
