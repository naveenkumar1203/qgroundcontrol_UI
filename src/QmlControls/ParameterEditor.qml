/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.3
import QtQuick.Controls             1.2
import QtQuick.Dialogs              1.2
import QtQuick.Layouts              1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import FirmwareUpdate               1.0
import TableModel                   1.0

Item {
    id:         _root

    property var      _activeVehicle:      QGroundControl.multiVehicleManager.activeVehicle
    property var      _appSettings:        QGroundControl.settingsManager.appSettings
    property var      _controller:         controller
    property int      model_index_value:   rpadatabase.modelIndex
    property string   model_index_name:    rpadatabase.model
    property int      new_vehicle_id:       QGroundControl.multiVehicleManager.vehicleid_params
    property int      new_model_index_value: model_index_value+1



    ParameterEditorController {
        id: controller
    }

    TableModel{
        id:rpadatabase
    }

    ExclusiveGroup { id: sectionGroup }

    //---------------------------------------------
    //-- Header

    QGCButton{
        id:flash_firmware
        text: "Flash Parameter"
        onClicked: {
            if(new_model_index_value === new_vehicle_id){
            firmware_load1.checksum_generation_process_model(file_Dialog.shortcuts.documents)
             }
             else{
             }
        }
    }

    FileDialog{
        id: file_Dialog
        folder: shortcuts.documents
    }

    FirmwareUpdate {
        id: firmware_load1

        onFirmware_load_modelChanged: {
            console.log("model index value is:", model_index_value);
            console.log("model name is:", model_index_name);
            console.log("new vehicle id value is",new_vehicle_id);
            console.log("new model index value is",new_model_index_value);

            if (new_model_index_value === new_vehicle_id) {
                if (controller.buildDiffFromFile(firmware_load1.firmware_load_model)) {
                    mainWindow.showPopupDialogFromComponent(parameterDiffDialog);
                }
            } else {

            }
        }
    }

    Component {
        id: parameterDiffDialog

        ParameterDiffDialog {
            paramController: _controller
        }
    }
}




