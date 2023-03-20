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

    property Fact   _editorDialogFact: Fact { }
    property int    _rowHeight:         ScreenTools.defaultFontPixelHeight * 2
    property int    _rowWidth:          10 // Dynamic adjusted at runtime
    //property bool   _searchFilter:      searchText.text.trim() != "" || controller.showModifiedOnly  ///< true: showing results of search
    property var    _searchResults      ///< List of parameter names from search results
    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    //property bool   _showRCToParam:     _activeVehicle.px4Firmware
    property var    _appSettings:       QGroundControl.settingsManager.appSettings
    property var    _controller:        controller



    ParameterEditorController {
        id: controller
    }
    RpaDatabase{
        id:rpa_database
    }

    //ExclusiveGroup { id: sectionGroup }

    //---------------------------------------------

    Text {
        id: drone_model_text
        text: qsTr("Name/Drone's Model Name")
        color: "White"
        font.pointSize: 10
    }

    Rectangle {
        id: drone_model_combo
        width: 200
        height: 35
        anchors.top: drone_model_text.top
        anchors.leftMargin: 10
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

            onCurrentTextChanged :{

                if(currentText == "Model A") {
                    firmware_load1.checksum_generation_process_model_A()

                }
                else if(currentText == "Model B") {
                        firmware_load1.checksum_generation_process_model_B()
                }

            }

            delegate:ItemDelegate {
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






