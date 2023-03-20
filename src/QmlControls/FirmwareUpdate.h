#ifndef FIRMWAREUPDATE_H
#define FIRMWAREUPDATE_H

#include <QObject>
#include <QProcess>
#include <QDebug>
#include <QFileInfo>
#include <QFileDialog>


class FirmwareUpdate : public QObject
{
    Q_OBJECT
public:
    explicit FirmwareUpdate(QObject *parent = nullptr);

    Q_PROPERTY(QString checksum_generation_model_A READ checksum_generation_model_A WRITE setgenerated_checksum_model_A NOTIFY generation_checksum_model_AChanged)
    Q_PROPERTY(QString checksum_calculation_model_A READ checksum_calculation_model_A WRITE setcalculated_checksum_model_A NOTIFY calculation_checksum_model_AChanged)
    Q_PROPERTY(QString firmware_load_model_A READ firmware_load_model_A WRITE setfirmware_load_model_A NOTIFY firmware_load_model_AChanged)

    Q_INVOKABLE void checksum_generation_process_model_A();
    Q_INVOKABLE void checksum_calculation_process_model_A();
    Q_INVOKABLE void compare_file_model_A();
    Q_INVOKABLE void load_file_model_A();

    QString checksum_generation_model_A();
    QString checksum_calculation_model_A();
    QString firmware_load_model_A();

    void setgenerated_checksum_model_A(const QString &newgenerated_checksum_model_A);
    void setcalculated_checksum_model_A(const QString &newcalculated_checksum_model_A);
    void setfirmware_load_model_A (const QString &newfirmware_load_model_A);



    Q_PROPERTY(QString checksum_generation_model_B READ checksum_generation_model_B WRITE setgenerated_checksum_model_B NOTIFY generation_checksum_model_BChanged)
    Q_PROPERTY(QString checksum_calculation_model_B READ checksum_calculation_model_B WRITE setcalculated_checksum_model_B NOTIFY calculation_checksum_model_BChanged)
    Q_PROPERTY(QString firmware_load_model_B READ firmware_load_model_B WRITE setfirmware_load_model_B NOTIFY firmware_load_model_BChanged)


    Q_INVOKABLE void checksum_generation_process_model_B();
    Q_INVOKABLE void checksum_calculation_process_model_B();
    Q_INVOKABLE void compare_file_model_B();
    Q_INVOKABLE void load_file_model_B();

    QString checksum_generation_model_B();
    QString checksum_calculation_model_B();
    QString firmware_load_model_B();

    void setgenerated_checksum_model_B(const QString &newgenerated_checksum_model_B);
    void setcalculated_checksum_model_B(const QString &newcalculated_checksum_model_B);
    void setfirmware_load_model_B(const QString &newfirmware_load_model_B);


signals:
   void generation_checksum_model_AChanged();
   void calculation_checksum_model_AChanged();
   void firmware_load_model_AChanged();


   void generation_checksum_model_BChanged();
   void calculation_checksum_model_BChanged();
   void firmware_load_model_BChanged();

private:
    QString model_A_generated_checksum;
    QString model_A_calculated_checksum;
    QString model_A_firmware_load;



    QString model_B_generated_checksum;
    QString model_B_calculated_checksum;
    QString model_B_firmware_load;
};

#endif // FIRMWAREUPDATE_H
