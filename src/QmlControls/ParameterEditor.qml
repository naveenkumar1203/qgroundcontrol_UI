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

    //STYLE.Button {
    Button {
        Text {
            anchors.centerIn: parent
            text: "Fly View"
            color:"white"
        }
        background: Rectangle {
            id: fly_button
            implicitHeight: 35
            implicitWidth: 130
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
            if(check_box.checked === false && check_box1.checked === false && check_box2.checked === false && check_box3.checked === false && check_box4.checked === false){
                select_the_modelDialog.open()
                console.log("model not selected")
            }
            if(check_box.checked === true){
               rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList limit 1")

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
                rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList limit 1 offset 1")
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
                rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList limit 1 offset 2")
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
                rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList limit 1 offset 3")
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
                rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList limit 1 offset 4")
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
            /*else if(check_box.checked === true || check_box1.checked === true || check_box2.checked === true || check_box3.checked === true ||check_box4.checked === true){
                console.log("model not selected------>")
                rpadatabase.checkboxSqlfly("select MODEL_NAME,UIN from RpaList")
                if(rpadatabase.model === ""){
                    select_the_modelDialog.open()
                    console.log("model not selected")
                }
            }
            else if(check_box.checked !== true || check_box1.checked !== true || check_box2.checked !== true || check_box3.checked !== true ||check_box4.checked !== true){
                console.log("check_box is not selected")
                select_the_checkboxDialog.open()
            }

            if(drone_model_list.currentText === "Model A") {
                firmware_load1.checksum_generation_process_model_A()

            }
            else if(drone_model_list.currentText === "Model B") {
                firmware_load1.checksum_generation_process_model_B()
            }
            else if (uin_input_text.text !== ""){
                rpadatabase.existingUIN(uin_input_text.text)
                //uin_input_text.text=""
            }
*/

            check_box.checked = false
            check_box1.checked = false
            check_box2.checked = false
            check_box3.checked = false
            check_box4.checked = false

        }
    }
//    Dialog {
//        id: select_the_modelDialog
//        width: 200
//        height: 50
//        title: "Select the Model"
//        Label {
//            text: "Please Select the Model."
//        }
//    }
    Dialog {
        id: select_the_modelDialog
        width: 200
        height: 50
        title: "Model not Selected"
        Label {
            text: "You have to select the model before you fly."
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






