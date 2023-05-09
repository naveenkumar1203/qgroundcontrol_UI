/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4 as STYLE
import Qt.labs.qmlmodels 1.0
import QtGraphicalEffects 1.0
import QtQuick 2.15
import QtQuick.Window 2.15

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import FirmwareUpdate 1.0
import TableModel 1.0


Item{
    id:         _root
    z:1

    property var    _controller:        controller


    ParameterEditorController
    {
        id: controller
    }

    TableModel{
        id: rpadatabase
    }

    //ExclusiveGroup { id: sectionGroup }

    //---------------------------------------------

    //STYLE.Button {
    Button {
        Text {
            anchors.centerIn: parent
            text: "Fly View"
            color:"white"
            font.bold: true
            font.pointSize:ScreenTools.smallFontPointSize
        }
        background: Rectangle {
            id: fly_button
            implicitHeight: mainWindow.height/20
            implicitWidth:  mainWindow.width/8
            border.width: 1
            border.color: "#F25822"
            radius: 4
            color: "#F25822"
        }
        onPressed: {
            fly_button.color = "#05324D"
        }
        onReleased: {
            fly_button.color = "#F25822"
        }
        onClicked: {
                    if(checkBoxState === 0){
                                    select_the_modelDialog.open()
                                    console.log("model not selected")
                                }
                                else if(checkBoxState === 1){
                                    console.log("model is selected")
                                    console.log(checkBoxNumber)
                                    //rpadatabase.modelSelected(checkBoxNumber)
                                    flightView.visible = true
                                    toolbar.visible =true
                                    landing_page_rectangle.visible = false
                                    checkBoxState = 0

                                }
                                else{
                                    console.log("no checkboxstate")
                                }
                }
    }

    MessageDialog {
        id: select_the_modelDialog
        title: "Model not Selected"
        text: "You have to select the model before you fly."
    }


    FirmwareUpdate{
        id:firmware_load1

        onGeneration_checksum_model_AChanged: {
        }
        onGeneration_checksum_model_BChanged: {
        }
        onFirmware_load_model_AChanged:{
            if (controller.buildDiffFromFile(firmware_load1.firmware_load_model_A)) {
                mainWindow.showPopupDialogFromComponent(parameterDiffDialog)
                console.log("mainroot" + firmware_load1.firmware_load_model_A)
            }
        }
        onFirmware_load_model_BChanged:{
            if (controller.buildDiffFromFile(firmware_load1.firmware_load_model_B)) {
                mainWindow.showPopupDialogFromComponent(parameterDiffDialog)
                console.log("mainroot" + firmware_load1.firmware_load_model_B)
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






