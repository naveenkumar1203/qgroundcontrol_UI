#ifndef FIRMWAREUPDATE_H
#define FIRMWAREUPDATE_H

#include <QObject>
#include <QProcess>
#include <QDebug>
#include <QFileInfo>
#include <QFileDialog>
#include "QGCToolbox.h"
#include "RpaDatabase.h"

extern int sound_flag;
extern bool checksum_match;


class FirmwareUpdate : public QObject
{
    Q_OBJECT

    TableModel obj1;

public:
    explicit FirmwareUpdate(QObject *parent = nullptr);

    QGCToolbox* _toolbox = nullptr;

    Q_INVOKABLE int mute_sound(int audio_flag);

    Q_PROPERTY(QString checksum_generation_model READ checksum_generation_model WRITE setgenerated_checksum_model NOTIFY generation_checksum_modelChanged)
    Q_PROPERTY(QString checksum_calculation_model READ checksum_calculation_model WRITE setcalculated_checksum_model NOTIFY calculation_checksum_modelChanged)
    Q_PROPERTY(QString firmware_load_model READ firmware_load_model WRITE setfirmware_load_model NOTIFY firmware_load_modelChanged)

    Q_INVOKABLE void checksum_generation_process_model(QString folder_location);
    Q_INVOKABLE void checksum_calculation_process_model(QString real_file_location);
    Q_INVOKABLE void compare_file_model(QString real_file_location);
    Q_INVOKABLE void load_file_model(QString real_file_location);

    QString checksum_generation_model();
    QString checksum_calculation_model();
    QString firmware_load_model();

    void setgenerated_checksum_model(const QString &newgenerated_checksum_model);
    void setcalculated_checksum_model(const QString &newcalculated_checksum_model);
    void setfirmware_load_model(const QString &newfirmware_load_model);

signals:
   void generation_checksum_modelChanged();
   void calculation_checksum_modelChanged();
   void firmware_load_modelChanged();

private:
    QString model_generated_checksum;
    QString model_calculated_checksum;
    QString model_firmware_load;
};

#endif // FIRMWAREUPDATE_H
