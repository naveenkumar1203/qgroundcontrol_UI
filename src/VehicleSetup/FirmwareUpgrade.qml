/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.MultiVehicleManager 1.0
import TableModel 1.0

SetupPage {
    id:             firmwarePage
    pageComponent:  firmwarePageComponent
    pageName:       qsTr("Firmware")
    showAdvanced:   globals.activeVehicle && globals.activeVehicle.apmFirmware

    Component {
        id: firmwarePageComponent

        ColumnLayout {
            width:   availableWidth
            height:  availableHeight
            spacing: ScreenTools.defaultFontPixelHeight

            // Those user visible strings are hard to translate because we can't send the
            // HTML strings to translation as this can create a security risk. we need to find
            // a better way to hightlight them, or use less highlights.

            // User visible strings
            readonly property string title:             qsTr("Firmware Setup") // Popup dialog title
            readonly property string highlightPrefix:   "<font color=\"" + qgcPal.warningText + "\">"
            readonly property string highlightSuffix:   "</font>"
            readonly property string welcomeText:       qsTr("%1 can upgrade the firmware on Pixhawk devices, SiK Radios and PX4 Flow Smart Cameras.").arg(QGroundControl.appName)
            readonly property string welcomeTextSingle: qsTr("Update the autopilot firmware to the latest version")
            readonly property string plugInText:        "<big>" + highlightPrefix + qsTr("Plug in your device") + highlightSuffix + qsTr(" via USB to ") + highlightPrefix + qsTr("start") + highlightSuffix + qsTr(" firmware upgrade.") + "</big>"
            readonly property string flashFailText:     qsTr("If upgrade failed, make sure to connect ") + highlightPrefix + qsTr("directly") + highlightSuffix + qsTr(" to a powered USB port on your computer, not through a USB hub. ") +
                                                        qsTr("Also make sure you are only powered via USB ") + highlightPrefix + qsTr("not battery") + highlightSuffix + "."
            readonly property string qgcUnplugText1:    qsTr("All %1 connections to vehicles must be ").arg(QGroundControl.appName) + highlightPrefix + qsTr(" disconnected ") + highlightSuffix + qsTr("prior to firmware upgrade.")
            readonly property string qgcUnplugText2:    highlightPrefix + "<big>" + qsTr("Please unplug your Pixhawk and/or Radio from USB.") + "</big>" + highlightSuffix

            readonly property int _defaultFimwareTypePX4:   12
            readonly property int _defaultFimwareTypeAPM:   3

            property var    _firmwareUpgradeSettings:   QGroundControl.settingsManager.firmwareUpgradeSettings
            property var    _defaultFirmwareFact:       _firmwareUpgradeSettings.defaultFirmwareType
            property bool   _defaultFirmwareIsPX4:      true
            property string firmwareWarningMessage
            property bool   firmwareWarningMessageVisible:  false
            property bool   initialBoardSearch:             true
            property string firmwareName
            property string firmwareFilePath
            property bool _singleFirmwareMode:          QGroundControl.corePlugin.options.firmwareUpgradeSingleURL.length != 0   ///< true: running in special single firmware download mode
            property int      model_index_value:   rpadatabase.modelIndex
            property string   model_index_name:    rpadatabase.model
            property int      new_vehicle_id:       QGroundControl.multiVehicleManager.vehicleid_params
            property int      new_model_index_value:  model_index_value + 1


            function cancelFlash() {
                statusTextArea.append(highlightPrefix + qsTr("Upgrade cancelled") + highlightSuffix)
                statusTextArea.append("------------------------------------------")
                controller.cancel()
            }

            function setupPageCompleted() {
                controller.startBoardSearch()
                _defaultFirmwareIsPX4 = _defaultFirmwareFact.rawValue === _defaultFimwareTypePX4 // we don't want this to be bound and change as radios are selected
            }

            TableModel {
                id: rpadatabase
            }
            FirmwareUpgradeController {
                id:             controller
                progressBar:    progressBar
                statusLog:      statusTextArea

                property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

                onActiveVehicleChanged: {
                    if (!globals.activeVehicle) {
                        statusTextArea.append(plugInText)
                    }
                }

                onNoBoardFound: {
                    initialBoardSearch = false
                    if (!QGroundControl.multiVehicleManager.activeVehicleAvailable) {
                        statusTextArea.append(plugInText)
                    }
                }

                onBoardGone: {
                    initialBoardSearch = false
                    if (!QGroundControl.multiVehicleManager.activeVehicleAvailable) {
                        statusTextArea.append(plugInText)
                    }
                }

                onBoardFound: {
                    if (initialBoardSearch) {
                        // Board was found right away, so something is already plugged in before we've started upgrade
                        statusTextArea.append(qgcUnplugText1)
                        statusTextArea.append(qgcUnplugText2)

                        var availableDevices = controller.availableBoardsName()
                        if (availableDevices.length > 1) {
                            statusTextArea.append(highlightPrefix + qsTr("Multiple devices detected! Remove all detected devices to perform the firmware upgrade."))
                            statusTextArea.append(qsTr("Detected [%1]: ").arg(availableDevices.length) + availableDevices.join(", "))
                        }
                        if (QGroundControl.multiVehicleManager.activeVehicle) {
                            QGroundControl.multiVehicleManager.activeVehicle.vehicleLinkManager.autoDisconnect = true
                        }
                    } else {
                        if(new_model_index_value == new_vehicle_id)
                        {
                            // We end up here when we detect a board plugged in after we've started upgrade
                            statusTextArea.append(highlightPrefix + qsTr("Found device") + highlightSuffix + ": " + controller.boardType)
                        }
                    }
                }
                onShowFirmwareSelectDlg: {
                    if(new_model_index_value == new_vehicle_id)
                    {
                        mainWindow.showComponentDialog(firmwareSelectDialogComponent, title, mainWindow.showDialogDefaultWidth, StandardButton.Ok | StandardButton.Cancel)
                    }
                }
                onError: statusTextArea.append(flashFailText)
            }

            Component {
                id: firmwareSelectDialogComponent

                QGCViewDialog {
                    id: pixhawkFirmwareSelectDialog

                    property bool showFirmwareTypeSelection:    _advanced.checked
                    property bool px4Flow:                      controller.px4FlowBoard

                    function firmwareVersionChanged(model) {
                        firmwareWarningMessageVisible = false
                        // All of this bizarre, setting model to null and index to 1 and then to 0 is to work around
                        // strangeness in the combo box implementation. This sequence of steps correctly changes the combo model
                        // without generating any warnings and correctly updates the combo text with the new selection.
                        firmwareBuildTypeCombo.model = null
                        firmwareBuildTypeCombo.model = model
                        firmwareBuildTypeCombo.currentIndex = 1
                        firmwareBuildTypeCombo.currentIndex = 0
                    }

                    function updatePX4VersionDisplay() {
                        var versionString = ""
                        if (_advanced.checked) {
                            switch (controller.selectedFirmwareBuildType) {
                            case FirmwareUpgradeController.StableFirmware:
                                versionString = controller.px4StableVersion
                                break
                            case FirmwareUpgradeController.BetaFirmware:
                                versionString = controller.px4BetaVersion
                                break
                            }
                        } else {
                            versionString = controller.px4StableVersion
                        }
                        px4FlightStackRadio.text = qsTr("PX4 Pro ") + versionString
                        //px4FlightStackRadio2.text = qsTr("PX4 Pro ") + versionString
                    }

                    Component.onCompleted: {
//                        firmwarePage.advanced = false
                        firmwarePage.showAdvanced = false
                        updatePX4VersionDisplay()
                    }

                    Connections {
                        target:     controller
                        onError:    reject()
                    }

                    function accept() {
                        controller.flashFirmwareUrl(firmwareFilePath);
                        hideDialog();
                    }

                    function reject() {
                        hideDialog()
                        cancelFlash()
                    }

                    ListModel {
                        id: firmwareBuildTypeList

                        ListElement {
                            text:           qsTr("Standard Version (stable)")
                            firmwareType:   FirmwareUpgradeController.StableFirmware
                        }
                        ListElement {
                            text:           qsTr("Beta Testing (beta)")
                            firmwareType:   FirmwareUpgradeController.BetaFirmware
                        }
                        ListElement {
                            text:           qsTr("Developer Build (master)")
                            firmwareType:   FirmwareUpgradeController.DeveloperFirmware
                        }
                        ListElement {
                            text:           qsTr("Custom firmware file...")
                            firmwareType:   FirmwareUpgradeController.CustomFirmware
                        }
                    }

                    ListModel {
                        id: px4FlowFirmwareList

                        ListElement {
                            text:           qsTr("PX4 Pro")
                            stackType:   FirmwareUpgradeController.PX4FlowPX4
                        }
                        ListElement {
                            text:           qsTr("ArduPilot")
                            stackType:   FirmwareUpgradeController.PX4FlowAPM
                        }
                    }

                    ListModel {
                        id: px4FlowTypeList

                        ListElement {
                            text:           qsTr("Standard Version (stable)")
                            firmwareType:   FirmwareUpgradeController.StableFirmware
                        }
                        ListElement {
                            text:           qsTr("Custom firmware file...")
                            firmwareType:   FirmwareUpgradeController.CustomFirmware
                        }
                    }

                    ListModel {
                        id: singleFirmwareModeTypeList

                        ListElement {
                            text:           qsTr("Standard Version")
                            firmwareType:   FirmwareUpgradeController.StableFirmware
                        }
                        ListElement {
                            text:           qsTr("Custom firmware file...")
                            firmwareType:   FirmwareUpgradeController.CustomFirmware
                        }
                    }

                    QGCFlickable {
                        anchors.fill:   parent
                        contentHeight:  mainColumn.height

                        QGCButton {
                            id:customFirmwareDialog
                            text: "Flash Firmware"

                            onClicked:{
                                if(new_model_index_value == new_vehicle_id){
                                firmwareFilePath = QGroundControl.settingsManager.appSettings.telemetrySavePath + "/firmware_" + model_index_name + ".apj";
                                text.visible = true;
                                }
                                else{

                                }
                            }
                        }

                        Text {
                            id: text
                            text: qsTr("You are about to flash %1 Firmware.\nClick OK to continue").arg(model_index_name)
                            color: "white"
                            anchors.top: customFirmwareDialog.bottom
                            font.pointSize: ScreenTools.defaultFontPointSize
                            anchors.topMargin: 25
                            visible: false
                        }
                    } // QGCFLickable
                } // QGCViewDialog
            } // Component - firmwareSelectDialogComponent

            Component {
                id: firmwareWarningDialog

                QGCViewMessage {
                    message: firmwareWarningMessage

                    function accept() {
                        hideDialog()
                        controller.doFirmwareUpgrade();
                    }
                }
            }

//            ProgressBar {
//                id:                     progressBar
//                Layout.preferredWidth:  parent.width
//                visible:                !flashBootloaderButton.visible
//            }

//            QGCButton {
//                id:         flashBootloaderButton
//                text:       qsTr("Flash ChibiOS Bootloader")
//                visible:    firmwarePage.advanced
//                onClicked:  globals.activeVehicle.flashBootloader()
//            }

            TextArea {
                id:                 statusTextArea
                Layout.preferredWidth:              parent.width
                Layout.fillHeight:  true
                readOnly:           true
                frameVisible:       false
                font.pointSize:     ScreenTools.defaultFontPointSize
                textFormat:         TextEdit.RichText
                text:               _singleFirmwareMode ? welcomeTextSingle : welcomeText

                style: TextAreaStyle {
                    textColor:          qgcPal.text
                    backgroundColor:    qgcPal.windowShade
                }
            }
        } // ColumnLayout
    } // Component
} // SetupPage
