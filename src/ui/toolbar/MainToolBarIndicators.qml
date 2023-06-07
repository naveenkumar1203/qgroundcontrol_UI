/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.12
import QtQuick.Dialogs 1.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.MultiVehicleManager   1.0
//-------------------------------------------------------------------------
//-- Toolbar Indicators
Row {
    id:                 indicatorRow
    anchors.top:        parent.top
    anchors.bottom:     parent.bottom
    anchors.margins:    _toolIndicatorMargins
    spacing:            30 //ScreenTools.defaultFontPixelWidth * 1.5

    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

    Repeater {
        id:     appRepeater
        model:  QGroundControl.corePlugin.toolBarIndicators
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            visible:            item.showIndicator
        }
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.toolIndicators : []
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            //visible:            item.showIndicator
            visible: {
                if( _activeVehicle !== null && (rpadatabase.model === "Model A" && QGroundControl.multiVehicleManager.vehicleid_params ===1 ||
                 rpadatabase.model === "Model B" && QGroundControl.multiVehicleManager.vehicleid_params ===2))
                {
                 return true;
                }
                else{
                  wrong_controller.open()
                 return false;
                }
            }
        }
    }

    MessageDialog
    {
        id: wrong_controller
        text: qsTr("The Model and Controller does not match. Please contact OEM ")
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.modeIndicators : []
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            visible:            item.showIndicator
        }
    }
}
