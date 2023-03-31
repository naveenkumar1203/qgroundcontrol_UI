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
import RpaDatabase 1.0

Item{
    id:         _root
    z:1

    property var    _controller:        controller


    ParameterEditorController {
        id: controller
    }

    RpaDatabase{
        id:rpadatabase
    }

    //ExclusiveGroup { id: sectionGroup }

    //---------------------------------------------

    STYLE.Button {
        Text {
            anchors.centerIn: parent
            text: "Back to Fly"
            color:"white"
        }
        style: ButtonStyle {
            background: Rectangle {
                implicitHeight: 35
                implicitWidth: 130
                border.width: 1
                border.color: "#F25822"
                radius: 4
                color: "#F25822"
            }
        }
        onClicked: {

            if(check_box.checked === true){
               rpadatabase.checkboxSql("select MODEL_NAME from RpaList limit 1")

                if(rpadatabase.model == "Model A") {
                   firmware_load1.checksum_generation_process_model_A()
                   flightView.visible = true
                   toolbar.visible =true
                   landing_page_rectangle.visible = false

               }
               else if(rpadatabase.model == "Model B"){
                    firmware_load1.checksum_generation_process_model_B()
                    flightView.visible = true
                    toolbar.visible =true
                    landing_page_rectangle.visible = false

                }
            }
            else if(check_box1.checked === true){
                rpadatabase.checkboxSql("select MODEL_NAME from RpaList limit 1 offset 1")
                if(rpadatabase.model == "Model A") {
                   firmware_load1.checksum_generation_process_model_A()
                   flightView.visible = true
                   toolbar.visible =true
                   landing_page_rectangle.visible = false

               }
               else if(rpadatabase.model == "Model B"){
                    firmware_load1.checksum_generation_process_model_B()
                    flightView.visible = true
                    toolbar.visible =true
                    landing_page_rectangle.visible = false

                }
            }
            else if(check_box2.checked === true){
                rpadatabase.checkboxSql("select MODEL_NAME from RpaList limit 1 offset 2")
                if(rpadatabase.model == "Model A") {
                   firmware_load1.checksum_generation_process_model_A()
                   flightView.visible = true
                   toolbar.visible =true
                   landing_page_rectangle.visible = false

               }
               else if(rpadatabase.model == "Model B"){
                    firmware_load1.checksum_generation_process_model_B()
                    flightView.visible = true
                    toolbar.visible =true
                    landing_page_rectangle.visible = false

                }
            }
            else if(check_box3.checked === true){
                rpadatabase.checkboxSql("select MODEL_NAME from RpaList limit 1 offset 3")
                if(rpadatabase.model == "Model A") {
                   firmware_load1.checksum_generation_process_model_A()
                   flightView.visible = true
                   toolbar.visible =true
                   landing_page_rectangle.visible = false

               }
               else if(rpadatabase.model == "Model B"){
                    firmware_load1.checksum_generation_process_model_B()
                    flightView.visible = true
                    toolbar.visible =true
                    landing_page_rectangle.visible = false

                }
            }
            else if(check_box4.checked === true){
                rpadatabase.checkboxSql("select MODEL_NAME from RpaList limit 1 offset 4")
                if(rpadatabase.model == "Model A") {
                   firmware_load1.checksum_generation_process_model_A()
                   flightView.visible = true
                   toolbar.visible =true
                   landing_page_rectangle.visible = false

               }
               else if(rpadatabase.model == "Model B"){
                    firmware_load1.checksum_generation_process_model_B()
                    flightView.visible = true
                    toolbar.visible =true
                    landing_page_rectangle.visible = false

                }
            }
            /*if(drone_model_list.currentText === "Model A") {
                firmware_load1.checksum_generation_process_model_A()

            }
            else if(drone_model_list.currentText === "Model B") {
                firmware_load1.checksum_generation_process_model_B()
            }
            else if (uin_input_text.text !== ""){
                rpadatabase.existingUIN(uin_input_text.text)
                //uin_input_text.text=""
            }*/

        }
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






