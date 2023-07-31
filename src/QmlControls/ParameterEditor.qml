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

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property var    _appSettings:       QGroundControl.settingsManager.appSettings
    property var    _controller:        controller

    ParameterEditorController {
        id: controller
    }
    //    FirmwareUpdate{
    //        id:firmware_load1
    //    }
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
            if(rpadatabase.model == "Model A"){
                console.log("model a is selected")
                firmware_load1.checksum_generation_process_model_A(file_Dialog.shortcuts.documents)
            }
            else if(rpadatabase.model == "Model B"){
                console.log("model b is selected")
                firmware_load1.checksum_generation_process_model_B(file_Dialog.shortcuts.documents)
            }
        }
    }

    FileDialog{
        id: file_Dialog
        folder: shortcuts.documents
    }

    FirmwareUpdate{
        id:firmware_load1
        onFirmware_load_model_AChanged:{
            console.log("I REACHED AFTER ACTIVE VEHICLE");
            if(rpadatabase.model === "Model A" && QGroundControl.multiVehicleManager.vehicleid_params === 1)
            {
                if (controller.buildDiffFromFile(firmware_load1.firmware_load_model_A)) {
                    {
                        mainWindow.showPopupDialogFromComponent(parameterDiffDialog)
                        console.log("mainroot_modelA" + firmware_load1.firmware_load_model_A)
                    }
                }
            }
            else{
            }
        }
        onFirmware_load_model_BChanged:{
            if(rpadatabase.model === "Model B" && QGroundControl.multiVehicleManager.vehicleid_params === 2)
            {
                if (controller.buildDiffFromFile(firmware_load1.firmware_load_model_B)) {
                    {
                        mainWindow.showPopupDialogFromComponent(parameterDiffDialog)
                        console.log("mainroot_ModelB" + firmware_load1.firmware_load_model_B)
                    }
                }
            }
            else{
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
