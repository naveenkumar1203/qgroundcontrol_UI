import QtQuick          2.12
import QtQuick.Layouts  1.2
import QtQuick.Controls 2.5
import QtQuick.Dialogs  1.3

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Controllers   1.0

import FirmwareUpdate 1.0


QGCPopupDialog{
    title:      qsTr("Load Checksum ")
    buttons:    StandardButton.Ok

    property var paramController

    ColumnLayout {
        spacing: ScreenTools.defaultDialogControlSpacing

    QGCLabel {
        Layout.preferredWidth:  mainGrid.visible ? mainGrid.width : ScreenTools.defaultFontPixelWidth * 40
        wrapMode:               Text.WordWrap

                    text:                   firmware.compare_file_model_A?
                                                qsTr("The checksum matches. Please continue.") :
                                                qsTr("The Checksum does not match. Please contact your OEM.")
                }
    }

               FirmwareUpdate{
                   id:firmware
               }
}

