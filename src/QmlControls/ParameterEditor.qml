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
    id:         drone_contents
    z:1

    property var    _controller:        controller


    ParameterEditorController {
        id: controller
    }
    RpaDatabase{
        id:rpa_database
    }

    //ExclusiveGroup { id: sectionGroup }

    //---------------------------------------------


    Row {
        spacing: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 25

        Rectangle{
            id:drone_image_container
            width: 75
            height: 75
            radius: width/2
            color: "#031C28"
            Image {
                id:drone_image
                source: "qrc:/qmlimages/drone_1.png" //""
                anchors.fill: drone_image_container
                fillMode: Image.PreserveAspectCrop
                anchors.centerIn: parent
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: drone_image
                }
            }
        }

        Column{
            spacing: 10
            Text {
                id: drone_image_text
                text: qsTr("Drone Image")
                color: "White"
                font.pointSize: 12
            }

            Button {
                id: browse_image_button
                width: 135
                height: 30

                contentItem :Text {
                    anchors.centerIn: parent
                    text: "Browse & Upload"
                    color: "white"
                }
                background: Rectangle {
                    height: 30
                    width:135
                    color: "#031C28"
                    border.color: "orange"
                    radius: 4
                }
                onClicked: {
                    choose_image_fileDialog.open()
                }
            }
        }
    }

    FileDialog {
        id: choose_image_fileDialog
        title: "Please Choose the Image file *png"
        folder: shortcuts.documents
        nameFilters: [ "png files (*.png)"]
        selectMultiple: false
        visible: false
        onAccepted: {
            console.log("png file accepted")
            drone_image.source = fileUrl.toString()
        }
        onRejected: {
            console.log("select the correct file format")
        }
    }

    Text {
        id: drone_type_text
        anchors.left: drone_contents.left
        anchors.leftMargin: 25
        anchors.top: drone_contents.top
        anchors.topMargin: 120
        text: qsTr("Drone Type")
        color: "White"
        font.pointSize: 10
    }

    Rectangle {
        id: drone_type_combo
        width: 200
        height: 35
        anchors.left: drone_contents.left
        anchors.leftMargin: 25
        anchors.top: drone_type_text.top
        anchors.topMargin: 25
        color: "#031C28"
        border.color: "cyan"
        border.width: 1
        radius: 4

        ComboBox {
            id:drone_type_list
            anchors.fill: parent
            currentIndex: -1
            anchors.margins: 4
            displayText: currentIndex === -1 ? "Select Drone Type" : currentText
            model: //["Nano", "Micro", "Small","Medium","Large"]
                   ListModel {
                ListElement{
                    text: "Nano"
                }
                ListElement{
                    text: "Micro"
                }
                ListElement{
                    text: "Small"
                }
                ListElement{
                    text: "Medium"
                }
                ListElement{
                    text: "Large"
                }

            }

            delegate: ItemDelegate {
                width: drone_type_list.width
                contentItem: Text {
                    text: modelData
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: drone_type_list.highlightedIndex === index
            }

            indicator: Canvas {
                //id: canvas
                x: drone_type_list.width - width - drone_type_list.rightPadding
                y: drone_type_list.topPadding + (drone_type_list.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = "white";/*"#17a81a" : "#21be2b"*/
                    context.fill();
                }
            }

            contentItem: Text {
                text: drone_type_list.displayText
                color: "white"
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#031C28"
            }

            popup: Popup {
                y: drone_type_list.height - 1
                width: drone_type_list.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: drone_type_list.popup.visible ? drone_type_list.delegateModel : null
                    currentIndex: drone_type_list.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }
            }
        }
    }
    Text {
        id: drone_model_text
        anchors.right: drone_contents.right
        anchors.rightMargin: 100
        anchors.top: drone_contents.top
        anchors.topMargin: 120
        text: qsTr("Name/Drone's Model Name")
        color: "White"
        font.pointSize: 10
    }

    Rectangle {
        id: drone_model_combo
        width: 200
        height: 35
        anchors.right: drone_contents.right
        anchors.rightMargin: 80
        anchors.top: drone_type_text.top
        anchors.topMargin: 25
        color: "#031C28"
        border.color: "cyan"
        border.width: 1
        radius: 4


        ComboBox {
            id:drone_model_list
            anchors.fill: parent
            anchors.margins: 4
            currentIndex: -1
            displayText: currentIndex === -1 ? "Select Drone Model" : currentText
            model: //["Model A", "Model B"]
                   ListModel {
                ListElement{
                    text: "Model A"
                }
                ListElement{
                    text: "Model B"
                }
            }

            delegate: ItemDelegate {
                width: drone_model_list.width
                contentItem: Text {
                    text: modelData
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: drone_model_list.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas1
                x: drone_model_list.width - width - drone_model_list.rightPadding
                y: drone_model_list.topPadding + (drone_model_list.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = "white";
                    context.fill();
                }
            }

            contentItem: Text {
                text: drone_model_list.displayText
                color: "white"
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#031C28"
            }

            popup: Popup {
                y: drone_model_list.height - 1
                width: drone_model_list.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: drone_model_list.popup.visible ? drone_model_list.delegateModel : null
                    currentIndex: drone_model_list.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }
            }
        }
    }

    Rectangle {
        id: rpa_text
        anchors.left: drone_contents.left
        anchors.leftMargin: 20
        anchors.top: drone_type_combo.top
        anchors.topMargin: 55
        height: 30
        width: drone_contents.width - 35
        color: "#031C28"
        radius: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: qsTr ("RPA INFORMATIONS")
            color: "white"
            font.pointSize: 10
        }
    }

    Text {
        id:basic_details_text
        anchors.left: drone_contents.left
        anchors.leftMargin: 25
        anchors.top: drone_type_combo.top
        anchors.topMargin: 100
        text: qsTr("Basic Details")
        font.bold: true
        font.pointSize: 11
        color: "white"
    }

    Text {
        id: drone_name_input
        anchors.left: drone_contents.left
        anchors.leftMargin: 25
        anchors.top: basic_details_text.top
        anchors.topMargin: 25
        text: qsTr("Drone Name")
        font.pointSize: 10
        color: "white"
    }

    Rectangle {
        id:drone_name_input_rect
        anchors.left: drone_contents.left
        anchors.leftMargin: 25
        anchors.top: drone_name_input.top
        anchors.topMargin: 25
        width: 200
        height: 35
        radius: 4

        TextField{
            id:drone_name_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            text: ''
            color: "white"
            background: Rectangle {
                color: "#031C28"
                radius: 4
                border.width: 1
                border.color: "cyan"
                implicitHeight: drone_name_input_rect.height
                implicitWidth: drone_name_input_rect.width
            }
        }
    }

    Text {
        id: uin_input
        anchors.right: drone_contents.right
        anchors.rightMargin: 255
        anchors.top: rpa_text.top
        anchors.topMargin: 70
        text: qsTr("UIN")
        font.pointSize: 10
        color: "white"
    }

    Rectangle {
        id:uin_input_rect
        anchors.right: drone_contents.right
        anchors.rightMargin: 80
        anchors.top: uin_input.top
        anchors.topMargin: 25
        width: 200
        height: 35
        color: "#031C28"

        TextField {
            id:uin_input_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            text: " "
            color: "white"
            background: Rectangle {
                color: "#031C28"
                radius: 4
                border.width: 1
                border.color: "cyan"
                implicitHeight: uin_input_rect.height
                implicitWidth: uin_input_rect.width
            }
        }
    }


    Row {
        spacing: 25
        anchors.left: drone_contents.left
        anchors.leftMargin: parent.width/3
        anchors.bottom: drone_contents.bottom
        anchors.bottomMargin: 20
        STYLE.Button {
            id:update_Button
            Text {
                anchors.centerIn: parent
                text: "Update"
                color:"white"
            }
            style: ButtonStyle {
                background: Rectangle {
                    implicitHeight: 35
                    implicitWidth: 100
                    radius: 4
                    color: "Green"
                }
            }
            onClicked: {
                if(drone_model_list.currentText === "Model A") {
                    firmware_load1.checksum_generation_process_model_A()

                }
                else if(drone_model_list.currentText === "Model B") {
                    firmware_load1.checksum_generation_process_model_B()
                }
                rpa_register_page.visible =  false
                rpaheader1.visible = true
                rpadatabase.addData(drone_type_list.currentText,drone_model_list.currentText,drone_name_text.text,uin_input_text.text)
                rpadatabase.callSql("SELECT * From RpaList")
                drone_type_list.text = " "
                drone_model_list.text = " "
                drone_name_text.text = " "
                uin_input_text.text = " "
            }
        }

        STYLE.Button {
            id: cancel_Button
            Text {
                anchors.centerIn: parent
                text: "Cancel"
                color:"white"
            }

            style: ButtonStyle {
                background: Rectangle {
                    implicitHeight: 35
                    implicitWidth: 100
                    radius: 4
                    color: "red"
                }
            }
            onClicked:{
                rpaheader1.visible = true
                rpa_register_page.visible = false
            }
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

//    RpaDatabase {

//    }


}






