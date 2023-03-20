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
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

import AjayDatabase 1.0
import RpaDatabase 1.0


/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
ApplicationWindow {
    id:             mainWindow
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true

    AjayDatabase{
        id: database
        onRecord_found: {
            login_page_rectangle.z = -1
            login_page_rectangle.visible = false
        }
        onNo_record_found: {
            no_recordDialog.open()
        }
        onIncorrect_password: {
            incorrect_password_Dialog.open()
        }
    }

    function showPanel(button, qmlSource) {
            if (mainWindow.preventViewSwitch()) {
                return
            }
            button.checked = true
            panelLoader.setSource(qmlSource)
        }

    Rectangle{
        id: login_page_rectangle
        anchors.fill: parent
        z:1
        color: "#031C28"
        Image {
            id: login_page_godrona_image
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: 90
            height: 90
            //source: "qrc:/../../../../Downloads/godrona-logo.png"
        }
        Column{
            id: login_page_label
            spacing: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: login_page_godrona_image.bottom
            anchors.topMargin: 60
            Label{
                text: "LOGIN ACCOUNT"
                color: "white"
                font.bold: true
                font.pixelSize: 20
            }
            Label{
                text: "- Hello, Welcome back to GoDrona"
                color: "#F25822"
                font.bold: true
                font.pixelSize: 20
            }
        }
        Column{
            id: login_page_label_email_column
            spacing: 10
            anchors.top: login_page_label.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                text: "Email Address*"
                color: "white"
            }
            TextField{
                id: login_page_email_textfield
                width: 300
                height: 35
                text: ""
                color: "white"
                leftPadding: 50
                onTextChanged: {
                    login_page_email.border.color = "#C0C0C0"
                }
                background: Rectangle
                {
                    id: login_page_email
                    anchors.fill: parent
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1.5
                }
                Image {
                    width: 25
                    height: 25
                    fillMode: Image.PreserveAspectFit
                    //source: "qrc:/../../../../Downloads/mailLogo.png"
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        Column{
            id: login_page_label_password_column
            spacing: 10
            anchors.top: login_page_label_email_column.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                text: "Password*"
                color: "white"
            }
            TextField{
                id: login_page_password_textfield
                width: 300
                height: 35
                text: ""
                color: "white"
                leftPadding: 50
                rightPadding: 50
                echoMode: TextInput.Password
                onTextChanged: {
                    login_page_password.border.color = "#C0C0C0"
                }
                background: Rectangle
                {
                    id: login_page_password
                    anchors.fill: parent
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1.5
                }
                Image {
                    width: 23
                    height: 23
                    fillMode: Image.PreserveAspectFit
                    //source: "qrc:/../../../../Downloads/password.png"
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    id: password_hide_image
                    width: 25
                    height: 25
                    fillMode: Image.PreserveAspectFit
                    //source: "qrc:/../../../../Downloads/password_hide.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            password_hide_image.visible = false
                            password_show_image.visible = true
                            login_page_password_textfield.echoMode = TextInput.Normal
                        }
                    }
                }
                Image {
                    id: password_show_image
                    visible: false
                    width: 25
                    height: 25
                    fillMode: Image.PreserveAspectFit
                    //source: "qrc:/../../../../Downloads/password_show.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            password_show_image.visible = false
                            password_hide_image.visible = true
                            login_page_password_textfield.echoMode = TextInput.Password
                        }
                    }
                }
            }
        }
        Button {
            anchors.top: login_page_label_password_column.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                text: "Login Now ->"
                font.pixelSize: 15
                anchors.centerIn: parent
                color: "white"
            }
            background: Rectangle {
                id: login_button
                implicitWidth: 200
                implicitHeight: 40
                color: "#F25822"
                radius: 4
            }
            onPressed: {
                login_button.color = "#05324D"
            }
            onReleased: {
                login_button.color = "#F25822"
            }
            onClicked: {
                database.loginExistingUser(login_page_email_textfield.text,login_page_password_textfield.text)
                landing_page_rectangle.visible =true
            }
        }
        Column{
            spacing: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.left: parent.left
            anchors.leftMargin: 20
            Label{
                text: "New to GoDrona ?"
                color: "white"
                Image{
                    id: new_user_logo
                    anchors.bottom: parent.top
                    width: 50
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/res/action.svg" //"qrc:/../../../../Downloads/new_member.png"

                }
                MouseArea{
                    anchors.fill: new_user_logo
                    onClicked: {
                        new_user_first_page.visible = true
                        first_user_details_page.visible = true
                    }
                }
            }
        }
        Column{
            spacing: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 20
            Label{
                text: "Forgot Password ?"
                color: "white"
                Image{
                    id: forgot_password_logo
                    anchors.bottom: parent.top
                    width: 50
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/res/action.svg" //"qrc:/../../../../Downloads/forgotpassword.png"
                }
                MouseArea{
                    anchors.fill: forgot_password_logo
                    onClicked: {
                        login_page_rectangle.visible = false
                        forgot_password_page_rectangle.visible = true
                    }
                }
            }
        }
    }

    Rectangle{
        id: forgot_password_page_rectangle
        visible: false
        anchors.fill: parent
        color: "#031C28"
        z: 1
        Label{
            text: "<- Forgot Password"
            font.pixelSize: 20
            color: "white"
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 30
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    forgot_password_page_rectangle.visible = false
                    login_page_rectangle.visible = true
                }
            }
        }
        Column{
            anchors.centerIn: parent
            spacing: 40
            Label{
                text: "Enter your registered email address to"
                color: "white"
                Label{
                    anchors.top: parent.bottom
                    text: "Reset your password"
                    color: "#00FFFF"
                }
            }
            Column{
                spacing: 10
                Label{
                    text: "Email Address*"
                    color: "white"
                }
                TextField{
                    id: forgot_password_mail_text
                    width: 300
                    height: 35
                    text: ""
                    color: "white"
                    leftPadding: 50
                    onTextChanged: {
                        forgot_password_page_email.border.color = "#C0C0C0"
                    }
                    background: Rectangle
                    {
                        id: forgot_password_page_email
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                    Image {
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/mailLogo.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: "Submit ->"
                    font.pixelSize: 15
                    anchors.centerIn: parent
                    color: "white"
                }
                background: Rectangle {
                    id: submit_button
                    implicitWidth: 200
                    implicitHeight: 40
                    color: "#F25822"
                    radius: 4
                }
                onPressed: {
                    submit_button.color = "#05324D"
                }
                onReleased: {
                    submit_button.color = "#F25822"
                }
                onClicked: {
                    forgot_password_page_rectangle.visible = false
                    reset_password_page_rectangle.visible = true
                }
            }
            Label{
                text: "Reset Password"
                color: "#00FFFF"
                Label{
                    anchors.left: parent.right
                    anchors.leftMargin: 3
                    text: "Link will be sent to your"
                    color: "white"
                }
                Label{
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    text: "registered email address"
                    color: "white"
                }
            }
        }
        Image{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 40
            width: 75
            height: 75
            //source: "qrc:/../../../../Downloads/backtologin-removebg-preview.png"
            Label{
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Back to Login"
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    forgot_password_page_rectangle.visible = false
                    login_page_rectangle.visible = true
                }
            }
        }
    }
    Rectangle{
        id: reset_password_page_rectangle
        visible: false
        z:1
        anchors.fill: parent
        color: "#031C28"
        Label{
            text: "<- Reset Password"
            font.pixelSize: 20
            color: "white"
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 30
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    reset_password_page_rectangle.visible = false
                    forgot_password_page_rectangle.visible = true
                }
            }
        }
        Column{
            anchors.centerIn: parent
            spacing: 40
            Label{
                text: "Create your"
                color: "white"
                Label{
                    anchors.left: parent.right
                    anchors.leftMargin: 3
                    text: "New password"
                    color: "#00FFFF"
                }
            }
            Column{
                spacing: 10
                Label{
                    text: "Create New Password*"
                    color: "white"
                }
                TextField{
                    id: new_password_textfield
                    width: 300
                    height: 35
                    text: ""
                    color: "white"
                    leftPadding: 50
                    rightPadding: 50
                    echoMode: TextInput.Password
                    onTextChanged: {
                        new_password.border.color = "#C0C0C0"
                    }
                    background: Rectangle
                    {
                        id: new_password
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                    Image {
                        width: 23
                        height: 23
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: new_password_hide_image
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password_hide.png"
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                new_password_hide_image.visible = false
                                new_password_show_image.visible = true
                                new_password_textfield.echoMode = TextInput.Normal
                            }
                        }
                    }
                    Image {
                        id: new_password_show_image
                        visible: false
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password_show.png"
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                new_password_show_image.visible = false
                                new_password_hide_image.visible = true
                                new_password_textfield.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }
            Column{
                spacing: 10
                Label{
                    text: "Confirm Password*"
                    color: "white"
                }
                TextField{
                    id: confirm_password_textfield
                    width: 300
                    height: 35
                    text: ""
                    color: "white"
                    leftPadding: 50
                    rightPadding: 50
                    echoMode: TextInput.Password
                    onTextChanged: {
                        confirm_password.border.color = "#C0C0C0"
                    }
                    background: Rectangle
                    {
                        id: confirm_password
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                    Image {
                        width: 23
                        height: 23
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: confirm_password_hide_image
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password_hide.png"
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                confirm_password_hide_image.visible = false
                                confirm_password_show_image.visible = true
                                confirm_password_textfield.echoMode = TextInput.Normal
                            }
                        }
                    }
                    Image {
                        id: confirm_password_show_image
                        width: 25
                        height: 25
                        visible: false
                        fillMode: Image.PreserveAspectFit
                        //source: "qrc:/../../../../Downloads/password_show.png"
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                confirm_password_show_image.visible = false
                                confirm_password_hide_image.visible = true
                                confirm_password_textfield.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: "Submit ->"
                    font.pixelSize: 15
                    anchors.centerIn: parent
                    color: "white"
                }
                background: Rectangle {
                    id: reset_submit_button
                    implicitWidth: 200
                    implicitHeight: 40
                    color: "#F25822"
                    radius: 4
                }
                onPressed: {
                    reset_submit_button.color = "#05324D"
                }
                onReleased: {
                    reset_submit_button.color = "#F25822"
                }
                onClicked: {
                    if(new_password_textfield.text != confirm_password_textfield.text){
                        password_mismatch.open()
                    }
                    else{
                        database.change_password(forgot_password_mail_text.text,new_password_textfield.text)
                        reset_password_page_rectangle.visible = false
                        login_page_rectangle.visible = true
                    }
                }
            }
        }
    }
    Rectangle{
        id: new_user_first_page
        anchors.fill: parent
        z: 1
        visible: false
        color: "#031C28"
        Label{
            id: new_user_first_page_label
            text: "<- Registration"
            font.pixelSize: 20
            color: "white"
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 30
            Label{
                anchors.top: parent.bottom
                anchors.topMargin: 20
                text: "- Lets get the access for our best service"
                color: "#F25822"
                font.pixelSize: 15
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    new_user_first_page.visible = false
                    login_page_rectangle.visible = true
                }
            }
        }
        Row{
            id: circle_row
            anchors.top: new_user_first_page_label.bottom
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: first_circle
                width: 50
                height: 50
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#F25822"
                Text{
                    id: first_circle_text
                    text: "1"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
            Repeater{
                model: 5
                Text{
                    text: "-"
                    color: "white"
                    anchors.verticalCenter: circle_row.verticalCenter
                }
            }
            Rectangle{
                id: second_circle
                width: 50
                height: 50
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#031C28"
                Text{
                    id: second_circle_text
                    text: "2"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
            Repeater{
                model: 5
                Text{
                    text: "-"
                    color: "white"
                    anchors.verticalCenter: circle_row.verticalCenter
                }
            }
            Rectangle{
                id: third_circle
                width: 50
                height: 50
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#031C28"
                Text{
                    id: third_circle_text
                    text: "3"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }
        Rectangle{
            id: first_user_details_page
            width: parent.width
            anchors.top: circle_row.bottom
            anchors.topMargin: 20
            height: parent.height
            color: "#031C28"
            Column{
                spacing: 20
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    text: "Select your industry type*"
                    color: "white"
                }
                ComboBox {
                    id: control
                    model: ["Drone Education & Training","Asset Inspection","Security & Surveillance","Public Survey","Oil & Gas Inspection","Industrial Inspection","Agricultural Usage","Goods Delivery"]
                    width: 200
                    delegate: ItemDelegate {
                        width: control.width
                        contentItem: Text {
                            text: control.textRole
                                  ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole])
                                  : modelData
                            color: "black"
                            font: control.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: control.highlightedIndex === index
                    }
                    indicator: Canvas {
                        id: canvas
                        x: control.width - width - control.rightPadding
                        y: control.topPadding + (control.availableHeight - height) / 2
                        width: 12
                        height: 8
                        contextType: "2d"
                        Connections {
                            target: control
                            function onPressedChanged() { canvas.requestPaint(); }
                        }
                        onPaint: {
                            context.reset();
                            context.moveTo(0, 0);
                            context.lineTo(width, 0);
                            context.lineTo(width / 2, height);
                            context.closePath();
                            context.fillStyle = "white"
                            context.fill();
                        }
                    }
                    contentItem: Text {
                        id: combobox_text
                        leftPadding: 30
                        rightPadding: control.indicator.width + control.spacing
                        text: control.displayText
                        font: control.font
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        onTextChanged: {
                            if(combobox_text.text == "Drone Education & Training"){
                                organization_image.visible = true
                            }
                            else{
                                organization_image.visible = false
                            }
                        }
                        Image{
                            id: organization_image
                            width: 25
                            height: 25
                            anchors.verticalCenter: parent.verticalCenter
                            //source: "qrc:/../../../../Downloads/organization.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 40
                        color: "#031C28"
                        border.color: "#00FFFF"
                        border.width: control.visualFocus ? 2 : 1
                        radius: 2
                    }
                    popup: Popup {
                        y: control.height - 1
                        width: control.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 1
                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: control.popup.visible ? control.delegateModel : null
                            currentIndex: control.highlightedIndex

                            ScrollIndicator.vertical: ScrollIndicator { }
                        }
                        background: Rectangle {
                            border.color: "#00FFFF"
                            radius: 2
                        }
                    }
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: "Next Step ->"
                        font.pixelSize: 15
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: next_step_submit_button
                        implicitWidth: 200
                        implicitHeight: 40
                        color: "#F25822"
                        radius: 4
                    }
                    onPressed: {
                        next_step_submit_button.color = "#05324D"
                    }
                    onReleased: {
                        next_step_submit_button.color = "#F25822"
                    }
                    onClicked: {
                        back_to_login_logo.visible = false
                        first_user_details_page.visible = false
                        second_user_details_page.visible = true
                        first_circle_text.text = "/"
                        first_circle.color = "green"
                        second_circle.color = "#F25822"
                    }
                }
            }
        }
        Rectangle{
            id: second_user_details_page
            visible: false
            width: parent.width
            anchors.top: circle_row.bottom
            anchors.topMargin: 20
            height: parent.height
            color: "#031C28"
            Rectangle{
                id: user_image
                width: 75
                height: 75
                radius: width / 2
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                Image{
                    width: 25
                    height: 25
                    anchors.left: user_image.left
                    anchors.leftMargin: user_image.radius + 20
                    anchors.verticalCenter: parent.verticalCenter
                    //source: "qrc:/../../../../Downloads/user_photo.png"
                }
                Image{
                    anchors.fill: parent
                    width: 75
                    height: 75
                    //source: image_file_dialog.fileUrl
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        image_file_dialog.open()
                    }
                }
            }
            ScrollView {
                id: scrollview
                width: parent.width
                height: parent.height / 2
                anchors.top: user_image.bottom
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                Column{
                    id: column
                    spacing: 30
                    anchors.left: parent.left
                    anchors.leftMargin: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    Column{
                        spacing: 10
                        Label{
                            text: "Full Name*"
                            color: "white"
                        }
                        TextField{
                            id: user_name_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            onTextChanged: {
                                user_name.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_name
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 23
                                height: 23
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/user_image.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        Label{
                            text: "Email Address*"
                            color: "white"
                        }
                        TextField{
                            id: user_mail_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            onTextChanged: {
                                user_mail.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_mail
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/mailLogo.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        Label{
                            text: "Mobile Number*"
                            color: "white"
                        }
                        TextField{
                            id: user_number_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            onTextChanged: {
                                user_number.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_number
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/user_phone.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        Label{
                            text: "Address Line*"
                            color: "white"
                        }
                        TextField{
                            id: user_address_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            onTextChanged: {
                                user_address.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_address
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 30
                                height: 30
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/user_location.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        Label{
                            text: "Locality*"
                            color: "white"
                        }
                        TextField{
                            id: user_locality_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            onTextChanged: {
                                user_locality.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_locality
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/user_locality.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Column{
                        spacing: 10
                        Label{
                            text: "Password*"
                            color: "white"
                        }
                        TextField{
                            id: user_password_text
                            width: 300
                            height: 35
                            text: ""
                            color: "white"
                            leftPadding: 50
                            rightPadding: 50
                            echoMode: TextInput.Password
                            onTextChanged: {
                                user_password.border.color = "#C0C0C0"
                            }
                            background: Rectangle
                            {
                                id: user_password
                                anchors.fill: parent
                                color: "#031C28"
                                border.color: "#05324D"
                                border.width: 1.5
                            }
                            Image {
                                width: 23
                                height: 23
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/password.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Image {
                                id: password_hide_image1
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/password_hide.png"
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        password_hide_image1.visible = false
                                        password_show_image1.visible = true
                                        user_password_text.echoMode = TextInput.Normal
                                    }
                                }
                            }
                            Image {
                                id: password_show_image1
                                visible: false
                                width: 25
                                height: 25
                                fillMode: Image.PreserveAspectFit
                                //source: "qrc:/../../../../Downloads/password_show.png"
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        password_show_image1.visible = false
                                        password_hide_image1.visible = true
                                        user_password_text.echoMode = TextInput.Password
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Column{
                anchors.top: scrollview.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Button {
                    Text{
                        text: "Verify Account ->"
                        font.pixelSize: 15
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: verify_account_button
                        implicitWidth: 200
                        implicitHeight: 40
                        color: "#F25822"
                        radius: 4
                    }
                    onPressed: {
                        verify_account_button.color = "#05324D"
                    }
                    onReleased: {
                        verify_account_button.color = "#F25822"
                    }
                    onClicked: {
                        if(user_name_text.text == ""
                                || user_mail_text.text == ""
                                || user_number_text.text == ""
                                || user_address_text.text == ""
                                || user_locality_text.text == ""
                                || user_password_text.text == ""){
                            enter_all_fields.open()
                        }
                        else{
                            second_user_details_page.visible = false
                            third_user_details_page.visible = true
                            second_circle_text.text = "/"
                            second_circle.color = "green"
                            third_circle.color = "#F25822"
                            user_name_text.text == ""
                            user_mail_text.text == ""
                            user_number_text.text == ""
                            user_address_text.text == ""
                            user_locality_text.text == ""
                            user_password_text.text == ""
                        }
                    }
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PREVIOUS STEP"
                    font.bold: true
                    color: "white"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            first_circle_text.text = "1"
                            second_circle_text.text = "2"
                            first_circle.color = "#F25822"
                            second_circle.color = "#031C28"
                            second_user_details_page.visible = false
                            first_user_details_page.visible = true
                        }
                    }
                }
            }
        }
        Rectangle{
            id: third_user_details_page
            visible: false
            width: parent.width
            anchors.top: circle_row.bottom
            anchors.topMargin: 20
            height: parent.height
            color: "#031C28"
            Label{
                id: otp_label
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 20
                text: "Please enter the"
                color: "white"
                Label{
                    anchors.left: parent.right
                    anchors.leftMargin: 3
                    text: "One Time Password"
                    color: "#00FFFF"
                }
            }
            Row{
                id: otp_row
                spacing: 20
                anchors.top: otp_label.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp1.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp1
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp2.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp2
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp3.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp3
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp4.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp4
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
                TextField{
                    width: 30
                    height: 30
                    text: ""
                    color: "white"
                    maximumLength: 1
                    onTextChanged: {
                        otp5.border.color = "green"
                    }
                    background: Rectangle
                    {
                        id: otp5
                        anchors.fill: parent
                        color: "#031C28"
                        border.color: "#05324D"
                        border.width: 1.5
                    }
                }
            }
            Row{
                id: otp_error
                spacing: 20
                anchors.top: otp_row.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    text: "Didn't get the OTP"
                    color: "white"
                }
                Label{
                    text: "Reset Code"
                    color: "#F25822"
                }
            }
            Column{
                id: otp_column
                spacing: 100
                anchors.top: otp_error.bottom
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    text: "OTP has been sent to your Mobile"
                    color: "white"
                    Label{
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        text: "Registered with Go Drona"
                        color: "white"
                    }
                }
                Button {
                    Text{
                        text: "Verify Now ->"
                        font.pixelSize: 15
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: verify_now_button
                        implicitWidth: 200
                        implicitHeight: 40
                        color: "#F25822"
                        radius: 4
                    }
                    onPressed: {
                        verify_now_button.color = "#05324D"
                    }
                    onReleased: {
                        verify_now_button.color = "#F25822"
                    }
                    onClicked: {

                        database.newUserData(combobox_text.text,user_name_text.text,user_mail_text.text,user_number_text.text,user_address_text.text,user_locality_text.text,user_password_text.text)
                        new_user_first_page.visible = false
                        third_user_details_page.visible = false
                        second_user_details_page.visible = false
                        first_circle.color = "#F25822"
                        second_circle.color = "#031C28"
                        third_circle.color = "#031C28"
                        first_circle_text.text = "1"
                        second_circle_text.text = "2"
                        login_page_rectangle.visible = true
                    }
                }
            }
            Label{
                anchors.top: otp_column.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                text: "PREVIOUS STEP"
                font.bold: true
                color: "white"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        second_circle_text.text = "2"
                        second_circle.color = "#031C28"
                        third_circle.color = "#031C28"
                        third_user_details_page.visible = false
                        second_user_details_page.visible = true
                    }
                }
            }
        }
        Image{
            id: back_to_login_logo
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 40
            width: 75
            height: 75
            //source: "qrc:/../../../../Downloads/backtologin-removebg-preview.png"
            Label{
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Already have an account ?"
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    new_user_first_page.visible = false
                    login_page_rectangle.visible = true
                }
            }
        }
    }
    FileDialog {
        id: image_file_dialog
        title: "Please choose an image file"
        folder: shortcuts.documents
        nameFilters: [ "(*.png *.jpg)"]
        selectMultiple: false
    }
    Rectangle{
        id: welcome_page
        anchors.fill: parent
        visible: false
        color: "red"
        Text{
            anchors.centerIn: parent
            text: "Welcome"
            color: "white"
            font.bold: true
        }
    }
    Dialog {
        id: no_recordDialog
        width: 200
        height: 100
        title: "No record exists"
        Label {
            text: "We think your are a new user"
            Label{
                anchors.top: parent.bottom
                anchors.topMargin: 3
                text: "So kindly create a new account"
            }
        }
        standardButtons: Dialog.Ok
    }
    Dialog {
        id: incorrect_password_Dialog
        width: 260
        height: 160
        title: "Password is wrong"
        Label {
            text: "Entered password is incorrect"
            Label{
                anchors.top: parent.bottom
                anchors.topMargin: 3
                text: "Please enter the correct password."
                Label{
                    anchors.top: parent.bottom
                    anchors.topMargin: 3
                    text: "If you have forgot the password,"
                    Label{
                        anchors.top: parent.bottom
                        anchors.topMargin: 3
                        text: "click the Forgot Password option."
                    }
                }
            }
        }
        standardButtons: Dialog.Ok
    }
    Dialog {
        id: enter_all_fields
        width: 200
        height: 50
        title: "Somefield not filled"
        Label {
            text: "Please fill all the details"
        }
    }
    Dialog {
        id: password_mismatch
        width: 200
        height: 50
        title: "Mismatch"
        Label {
            text: "Both passwords donot match"
        }
    }

    Component.onCompleted: {
        //-- Full screen on mobile or tiny screens
        if (ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
            mainWindow.showFullScreen()
        } else {
            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
        }

        // Start the sequence of first run prompt(s)
        firstRunPromptManager.nextPrompt()
    }

    QtObject {
        id: firstRunPromptManager

        property var currentDialog:     null
        property var rgPromptIds:       QGroundControl.corePlugin.firstRunPromptsToShow()
        property int nextPromptIdIndex: 0

        onRgPromptIdsChanged: console.log(QGroundControl.corePlugin, QGroundControl.corePlugin.firstRunPromptsToShow())

        function clearNextPromptSignal() {
            if (currentDialog) {
                currentDialog.closed.disconnect(nextPrompt)
            }
        }

        function nextPrompt() {
            if (nextPromptIdIndex < rgPromptIds.length) {
                currentDialog = showPopupDialogFromSource(QGroundControl.corePlugin.firstRunPromptResource(rgPromptIds[nextPromptIdIndex]))
                currentDialog.closed.connect(nextPrompt)
                nextPromptIdIndex++
            } else {
                currentDialog = null
                showPreFlightChecklistIfNeeded()
            }
        }
    }

    property var                _rgPreventViewSwitch:       [ false ]

    readonly property real      _topBottomMargins:          ScreenTools.defaultFontPixelHeight * 0.5

    //-------------------------------------------------------------------------
    //-- Global Scope Variables

    QtObject {
        id: globals

        readonly property var       activeVehicle:                  QGroundControl.multiVehicleManager.activeVehicle
        readonly property real      defaultTextHeight:              ScreenTools.defaultFontPixelHeight
        readonly property real      defaultTextWidth:               ScreenTools.defaultFontPixelWidth
        readonly property var       planMasterControllerFlyView:    flightView.planController
        readonly property var       guidedControllerFlyView:        flightView.guidedController

        property var                planMasterControllerPlanView:   null
        property var                currentPlanMissionItem:         planMasterControllerPlanView ? planMasterControllerPlanView.missionController.currentPlanViewItem : null
    }

    /// Default color palette used throughout the UI
    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    //-------------------------------------------------------------------------
    //-- Actions

    signal armVehicleRequest
    signal forceArmVehicleRequest
    signal disarmVehicleRequest
    signal vtolTransitionToFwdFlightRequest
    signal vtolTransitionToMRFlightRequest
    signal showPreFlightChecklistIfNeeded

    //-------------------------------------------------------------------------
    //-- Global Scope Functions

    /// Prevent view switching
    function pushPreventViewSwitch() {
        _rgPreventViewSwitch.push(true)
    }

    /// Allow view switching
    function popPreventViewSwitch() {
        if (_rgPreventViewSwitch.length == 1) {
            console.warn("mainWindow.popPreventViewSwitch called when nothing pushed")
            return
        }
        _rgPreventViewSwitch.pop()
    }

    /// @return true: View switches are not currently allowed
    function preventViewSwitch() {
        return _rgPreventViewSwitch[_rgPreventViewSwitch.length - 1]
    }

    function viewSwitch(currentToolbar) {
        toolDrawer.visible      = false
        toolDrawer.toolSource   = ""
        flightView.visible      = false
        planView.visible        = false
        toolbar.currentToolbar  = currentToolbar
    }

    function showFlyView() {
        if (!flightView.visible) {
            mainWindow.showPreFlightChecklistIfNeeded()
        }
        viewSwitch(toolbar.flyViewToolbar)
        flightView.visible = true
    }

    function showPlanView() {
        viewSwitch(toolbar.planViewToolbar)
        planView.visible = true
    }

    function showTool(toolTitle, toolSource, toolIcon) {
        toolDrawer.backIcon     = flightView.visible ? "/qmlimages/PaperPlane.svg" : "/qmlimages/Plan.svg"
        toolDrawer.toolTitle    = toolTitle
        toolDrawer.toolSource   = toolSource
        toolDrawer.toolIcon     = toolIcon
        toolDrawer.visible      = true
    }

    function showAnalyzeTool() {
        showTool(qsTr("Analyze Tools"), "AnalyzeView.qml", "/qmlimages/Analyze.svg")
    }

    function showSetupTool() {
        showTool(qsTr("Vehicle Setup"), "SetupView.qml", "/qmlimages/Gears.svg")
    }

    function showSettingsTool() {
        //showTool(qsTr("Application Settings"), "AppSettings.qml", "/res/QGCLogoWhite")
        showTool(qsTr("Application Settings"), "AppSettings.qml", " ")
    }

    //-------------------------------------------------------------------------
    //-- Global simple message dialog

    function showMessageDialog(dialogTitle, dialogText) {
        showPopupDialogFromComponent(simpleMessageDialog, { title: dialogTitle, text: dialogText })
    }

    Component {
        id: simpleMessageDialog

        QGCPopupDialog {
            title:      dialogProperties.title
            buttons:    StandardButton.Ok

            ColumnLayout {
                QGCLabel {
                    id:                     textLabel
                    wrapMode:               Text.WordWrap
                    text:                   dialogProperties.text
                    Layout.fillWidth:       true
                    Layout.maximumWidth:    mainWindow.width / 2
                }
            }
        }
    }

    /// Saves main window position and size
    MainWindowSavedState {
        window: mainWindow
    }

    //-------------------------------------------------------------------------
    //-- Global complex dialog

    /// Shows a QGCViewDialogContainer based dialog
    ///     @param component The dialog contents
    ///     @param title Title for dialog
    ///     @param charWidth Width of dialog in characters
    ///     @param buttons Buttons to show in dialog using StandardButton enum

    readonly property int showDialogFullWidth:      -1  ///< Use for full width dialog
    readonly property int showDialogDefaultWidth:   40  ///< Use for default dialog width

    function showComponentDialog(component, title, charWidth, buttons) {
        var dialogWidth = charWidth === showDialogFullWidth ? mainWindow.width : ScreenTools.defaultFontPixelWidth * charWidth
        var dialog = dialogDrawerComponent.createObject(mainWindow, { width: dialogWidth, dialogComponent: component, dialogTitle: title, dialogButtons: buttons })
        mainWindow.pushPreventViewSwitch()
        dialog.open()
    }

    Component {
        id: dialogDrawerComponent
        QGCViewDialogContainer {
            y:          mainWindow.header.height
            height:     mainWindow.height - mainWindow.header.height
            onClosed:   mainWindow.popPreventViewSwitch()
        }
    }

    // Dialogs based on QGCPopupDialog

    function showPopupDialogFromComponent(component, properties) {
        var dialog = popupDialogContainerComponent.createObject(mainWindow, { dialogComponent: component, dialogProperties: properties })
        dialog.open()
        return dialog
    }

    function showPopupDialogFromSource(source, properties) {
        var dialog = popupDialogContainerComponent.createObject(mainWindow, { dialogSource: source, dialogProperties: properties })
        dialog.open()
        return dialog
    }

    Component {
        id: popupDialogContainerComponent
        QGCPopupDialogContainer { }
    }

    property bool _forceClose: false

    function finishCloseProcess() {
        _forceClose = true
        // For some reason on the Qml side Qt doesn't automatically disconnect a signal when an object is destroyed.
        // So we have to do it ourselves otherwise the signal flows through on app shutdown to an object which no longer exists.
        firstRunPromptManager.clearNextPromptSignal()
        QGroundControl.linkManager.shutdown()
        QGroundControl.videoManager.stopVideo();
        mainWindow.close()
    }

    // On attempting an application close we check for:
    //  Unsaved missions - then
    //  Pending parameter writes - then
    //  Active connections
    onClosing: {
        if (!_forceClose) {
            unsavedMissionCloseDialog.check()
            close.accepted = false
        }
    }

    MessageDialog {
        id:                 unsavedMissionCloseDialog
        title:              qsTr("%1 close").arg(QGroundControl.appName)
        text:               qsTr("You have a mission edit in progress which has not been saved/sent. If you close you will lose changes. Are you sure you want to close?")
        standardButtons:    StandardButton.Yes | StandardButton.No
        modality:           Qt.ApplicationModal
        visible:            false
        onYes:              pendingParameterWritesCloseDialog.check()
        function check() {
            if (globals.planMasterControllerPlanView && globals.planMasterControllerPlanView.dirty) {
                unsavedMissionCloseDialog.open()
            } else {
                pendingParameterWritesCloseDialog.check()
            }
        }
    }

    MessageDialog {
        id:                 pendingParameterWritesCloseDialog
        title:              qsTr("%1 close").arg(QGroundControl.appName)
        text:               qsTr("You have pending parameter updates to a vehicle. If you close you will lose changes. Are you sure you want to close?")
        standardButtons:    StandardButton.Yes | StandardButton.No
        modality:           Qt.ApplicationModal
        visible:            false
        onYes:              activeConnectionsCloseDialog.check()
        function check() {
            for (var index=0; index<QGroundControl.multiVehicleManager.vehicles.count; index++) {
                if (QGroundControl.multiVehicleManager.vehicles.get(index).parameterManager.pendingWrites) {
                    pendingParameterWritesCloseDialog.open()
                    return
                }
            }
            activeConnectionsCloseDialog.check()
        }
    }

    MessageDialog {
        id:                 activeConnectionsCloseDialog
        title:              qsTr("%1 close").arg(QGroundControl.appName)
        text:               qsTr("There are still active connections to vehicles. Are you sure you want to exit?")
        standardButtons:    StandardButton.Yes | StandardButton.Cancel
        modality:           Qt.ApplicationModal
        visible:            false
        onYes:              finishCloseProcess()
        function check() {
            if (QGroundControl.multiVehicleManager.activeVehicle) {
                activeConnectionsCloseDialog.open()
            } else {
                finishCloseProcess()
            }
        }
    }

    //-------------------------------------------------------------------------
    /// Main, full window background (Fly View)
    background: Item {
        id:             rootBackground
        anchors.fill:   parent
    }

    //-------------------------------------------------------------------------
    /// Toolbar
    header: MainToolBar {
        id:         toolbar
        height:     ScreenTools.toolbarHeight
        visible:    (login_page_rectangle.z != 1) && (landing_page_rectangle.z != 1) && !QGroundControl.videoManager.fullScreen
    }

    footer: LogReplayStatusBar {
        visible: QGroundControl.settingsManager.flyViewSettings.showLogReplayStatusBar.rawValue
    }

    function showToolSelectDialog() {
        if (!mainWindow.preventViewSwitch()) {
            showPopupDialogFromComponent(toolSelectDialogComponent)
        }
    }

    Component {
        id: toolSelectDialogComponent

        QGCPopupDialog {
            id:         toolSelectDialog
            title:      qsTr("Select Tool")
            buttons:    StandardButton.Close

            property real _toolButtonHeight:    ScreenTools.defaultFontPixelHeight * 3
            property real _margins:             ScreenTools.defaultFontPixelWidth

            ColumnLayout {
                width:  innerLayout.width + (_margins * 2)
                height: innerLayout.height + (_margins * 2)

                ColumnLayout {
                    id:             innerLayout
                    Layout.margins: _margins
                    spacing:        ScreenTools.defaultFontPixelWidth

                    SubMenuButton {
                        id:                 setupButton
                        height:             _toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Vehicle Setup")
                        imageColor:         qgcPal.text
                        imageResource:      "/qmlimages/Gears.svg"
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.hideDialog()
                                mainWindow.showSetupTool()
                            }
                        }
                    }

                    SubMenuButton {
                        id:                 analyzeButton
                        height:             _toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Analyze Tools")
                        imageResource:      "/qmlimages/Analyze.svg"
                        imageColor:         qgcPal.text
                        visible:            QGroundControl.corePlugin.showAdvancedUI
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.hideDialog()
                                mainWindow.showAnalyzeTool()
                            }
                        }
                    }

                    SubMenuButton {
                        id:                 settingsButton
                        height:             _toolButtonHeight
                        Layout.fillWidth:   true
                        text:               qsTr("Application Settings")
                        //imageResource:      "/res/QGCLogoFull"
                        imageResource:      "/res/goDrona"
                        imageColor:         "transparent"
                        visible:            !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onClicked: {
                            if (!mainWindow.preventViewSwitch()) {
                                toolSelectDialog.hideDialog()
                                mainWindow.showSettingsTool()
                            }
                        }
                    }

                    ColumnLayout {
                        width:      innerLayout.width
                        spacing:    0

                        QGCLabel {
                            id:                     versionLabel
                            text:                   qsTr("%1 Version").arg(QGroundControl.appName)
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WordWrap
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter
                        }

                        //                        QGCLabel {
                        //                            text:                   QGroundControl.qgcVersion
                        //                            font.pointSize:         ScreenTools.smallFontPointSize
                        //                            wrapMode:               QGCLabel.WrapAnywhere
                        //                            Layout.maximumWidth:    parent.width
                        //                            Layout.alignment:       Qt.AlignHCenter

                        //                            QGCMouseArea {
                        //                                id:                 easterEggMouseArea
                        //                                anchors.topMargin:  -versionLabel.height
                        //                                anchors.fill:       parent

                        //                                onClicked: {
                        //                                    if (mouse.modifiers & Qt.ControlModifier) {
                        //                                        QGroundControl.corePlugin.showTouchAreas = !QGroundControl.corePlugin.showTouchAreas
                        //                                    } else if (mouse.modifiers & Qt.ShiftModifier) {
                        //                                        if(!QGroundControl.corePlugin.showAdvancedUI) {
                        //                                            advancedModeConfirmation.open()
                        //                                        } else {
                        //                                            QGroundControl.corePlugin.showAdvancedUI = false
                        //                                        }
                        //                                    }
                        //                                }

                        //                                MessageDialog {
                        //                                    id:                 advancedModeConfirmation
                        //                                    title:              qsTr("Advanced Mode")
                        //                                    text:               QGroundControl.corePlugin.showAdvancedUIMessage
                        //                                    standardButtons:    StandardButton.Yes | StandardButton.No
                        //                                    onYes: {
                        //                                        QGroundControl.corePlugin.showAdvancedUI = true
                        //                                        advancedModeConfirmation.close()
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                    }
                }
            }
        }
    }

    FlyView {
        id:             flightView
        anchors.fill:   parent
        visible :false
    }

    PlanView {
        id:             planView
        anchors.fill:   parent
        visible:        false
    }

    Drawer {
        id:             toolDrawer
        width:          mainWindow.width
        height:         mainWindow.height
        edge:           Qt.LeftEdge
        dragMargin:     0
        closePolicy:    Drawer.NoAutoClose
        interactive:    false
        visible:        false

        property alias backIcon:    backIcon.source
        property alias toolTitle:   toolbarDrawerText.text
        property alias toolSource:  toolDrawerLoader.source
        property alias toolIcon:    toolIcon.source

        Rectangle {
            id:             toolDrawerToolbar
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    parent.top
            height:         ScreenTools.toolbarHeight
            color:          qgcPal.toolbarBackground

            RowLayout {
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth
                anchors.left:       parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    id:                     backIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:     backTextLabel
                    text:   qsTr("Back")
                }

                QGCLabel {
                    font.pointSize: ScreenTools.largeFontPointSize
                    text:           "<"
                }

                QGCColoredImage {
                    id:                     toolIcon
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  qgcPal.text
                }

                QGCLabel {
                    id:             toolbarDrawerText
                    font.pointSize: ScreenTools.largeFontPointSize
                }
            }

            QGCMouseArea {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                x:                  parent.mapFromItem(backIcon, backIcon.x, backIcon.y).x
                width:              (backTextLabel.x + backTextLabel.width) - backIcon.x
                onClicked: {
                    toolDrawer.visible      = false
                    toolDrawer.toolSource   = ""
                }
            }
        }

        Loader {
            id:             toolDrawerLoader
            anchors.left:   parent.left
            anchors.right:  parent.right
            anchors.top:    toolDrawerToolbar.bottom
            anchors.bottom: parent.bottom

            Connections {
                target:                 toolDrawerLoader.item
                ignoreUnknownSignals:   true
                onPopout:               toolDrawer.visible = false
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Critical Vehicle Message Popup

    property var    _vehicleMessageQueue:      []
    property string _vehicleMessage:     ""

    function showCriticalVehicleMessage(message) {
        indicatorPopup.close()
        if (criticalVehicleMessagePopup.visible || QGroundControl.videoManager.fullScreen) {
            _vehicleMessageQueue.push(message)
        } else {
            _vehicleMessage = message
            criticalVehicleMessagePopup.open()
        }
    }

    Popup {
        id:                 criticalVehicleMessagePopup
        y:                  ScreenTools.defaultFontPixelHeight
        x:                  Math.round((mainWindow.width - width) * 0.5)
        width:              mainWindow.width  * 0.55
        height:             ScreenTools.defaultFontPixelHeight * 6
        modal:              false
        focus:              true
        closePolicy:        Popup.CloseOnEscape

        background: Rectangle {
            anchors.fill:   parent
            color:          qgcPal.alertBackground
            radius:         ScreenTools.defaultFontPixelHeight * 0.5
            border.color:   qgcPal.alertBorder
            border.width:   2
        }

        onOpened: {
            criticalVehicleMessageText.text = mainWindow._vehicleMessage
        }

        onClosed: {
            //-- Are there messages in the waiting queue?
            if(mainWindow._vehicleMessageQueue.length) {
                mainWindow._vehicleMessage = ""
                //-- Show all messages in queue
                for (var i = 0; i < mainWindow._vehicleMessageQueue.length; i++) {
                    var text = mainWindow._vehicleMessageQueue[i]
                    if(i) mainWindow._vehicleMessage += "<br>"
                    mainWindow._vehicleMessage += text
                }
                //-- Clear it
                mainWindow._vehicleMessageQueue = []
                criticalVehicleMessagePopup.open()
            } else {
                mainWindow._vehicleMessage = ""
            }
        }

        Flickable {
            id:                 criticalVehicleMessageFlick
            anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
            anchors.fill:       parent
            contentHeight:      criticalVehicleMessageText.height
            contentWidth:       criticalVehicleMessageText.width
            boundsBehavior:     Flickable.StopAtBounds
            pixelAligned:       true
            clip:               true
            TextEdit {
                id:             criticalVehicleMessageText
                width:          criticalVehicleMessagePopup.width - criticalVehicleMessageClose.width - (ScreenTools.defaultFontPixelHeight * 2)
                anchors.centerIn: parent
                readOnly:       true
                textFormat:     TextEdit.RichText
                font.pointSize: ScreenTools.defaultFontPointSize
                font.family:    ScreenTools.demiboldFontFamily
                wrapMode:       TextEdit.WordWrap
                color:          qgcPal.alertText
            }
        }

        //-- Dismiss Vehicle Message
        QGCColoredImage {
            id:                 criticalVehicleMessageClose
            anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
            anchors.top:        parent.top
            anchors.right:      parent.right
            width:              ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight
            height:             width
            sourceSize.height:  width
            source:             "/res/XDelete.svg"
            fillMode:           Image.PreserveAspectFit
            color:              qgcPal.alertText
            MouseArea {
                anchors.fill:       parent
                anchors.margins:    -ScreenTools.defaultFontPixelHeight
                onClicked: {
                    criticalVehicleMessagePopup.close()
                }
            }
        }

        //-- More text below indicator
        QGCColoredImage {
            anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
            anchors.bottom:     parent.bottom
            anchors.right:      parent.right
            width:              ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight
            height:             width
            sourceSize.height:  width
            source:             "/res/ArrowDown.svg"
            fillMode:           Image.PreserveAspectFit
            visible:            criticalVehicleMessageText.lineCount > 5
            color:              qgcPal.alertText
            MouseArea {
                anchors.fill:   parent
                onClicked: {
                    criticalVehicleMessageFlick.flick(0,-500)
                }
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Indicator Popups

    function showIndicatorPopup(item, dropItem) {
        indicatorPopup.currentIndicator = dropItem
        indicatorPopup.currentItem = item
        indicatorPopup.open()
    }

    function hideIndicatorPopup() {
        indicatorPopup.close()
        indicatorPopup.currentItem = null
        indicatorPopup.currentIndicator = null
    }

    Popup {
        id:             indicatorPopup
        padding:        ScreenTools.defaultFontPixelWidth * 0.75
        modal:          true
        focus:          true
        closePolicy:    Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property var    currentItem:        null
        property var    currentIndicator:   null
        background: Rectangle {
            width:  loader.width
            height: loader.height
            color:  Qt.rgba(0,0,0,0)
        }
        Loader {
            id:             loader
            onLoaded: {
                var centerX = mainWindow.contentItem.mapFromItem(indicatorPopup.currentItem, 0, 0).x - (loader.width * 0.5)
                if((centerX + indicatorPopup.width) > (mainWindow.width - ScreenTools.defaultFontPixelWidth)) {
                    centerX = mainWindow.width - indicatorPopup.width - ScreenTools.defaultFontPixelWidth
                }
                indicatorPopup.x = centerX
            }
        }
        onOpened: {
            loader.sourceComponent = indicatorPopup.currentIndicator
        }
        onClosed: {
            loader.sourceComponent = null
            indicatorPopup.currentIndicator = null
        }
    }

    /**************************Landing Page**********************************/

    Rectangle {
        id: landing_page_rectangle
        anchors.fill: parent
        z:1
        visible: false
        color: "#031C28"
            RpaDatabase {
            id:rpadatabase
        }

        Row {
            anchors.fill: parent
            Component.onCompleted: {
                rpadatabase.callSql("USE RpaInformation")
                rpadatabase.callSql("SELECT * From RpaList")
            }

            Rectangle {
                id: first_rectangle
                color: "#031C28"
                width: screen.width/5
                height:parent.height

                ColumnLayout {
                    id: menu_column
                    spacing: 12

                    Image {
                        id: brand_logo
                        Layout.alignment: Qt.AlignCenter
                        Layout.topMargin: 15
                        Layout.preferredHeight: 80
                        Layout.preferredWidth: 80
                        source: "/res/goDrona.png"
                    }

                    Rectangle {
                        id: menu_rect_1
                        color: "#05324D"
                        height: 25
                        width: first_rectangle.width - 2
                        Layout.alignment: Qt.AlignLeft

                        Image {
                            id: home_image
                            source: "/res/home.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: menu_rect_1.left
                            anchors.leftMargin: 30
                        }

                        Text {
                            id:landing_page_text
                            text: "LANDING PAGE"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: home_image.left
                            anchors.leftMargin: 30
                        }
                    }

                    Text{
                        id: management
                        text: "Management"
                        color : "white"
                        font.pointSize: 10
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 17
                        Layout.topMargin: 12
                    }

                    Rectangle{
                        id: dashboard_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: dashboard_image
                            source: "/res/dashboard.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "DASHBOARD";
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            anchors.fill: dashboard_button
                            onClicked: {
                                second_rectangle.visible = true
                                dashboard_button.color ="#F25822" || "#031C28"
                                managerpa_button.color = "#031C28"
                                second_rec_division1.visible = false
                            }
                        }
                    }

                    Rectangle{
                        id: managerpa_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: landingrpa_image
                            source: "/res/manage_rpa.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: managerpa_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "MANAGE RPA";
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: landingrpa_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            anchors.fill: managerpa_button
                            onClicked: {
                                second_rec_division1.visible = true
                                second_rectangle.visible = false
                                dashboard_button.color = "#031C28"
                                managerpa_button.color = "#F25822"
                                //rpaheader1.visible = true
                                //table_item.visible = false
                            }
                        }
                    }

                    /*===========add when necessary============*/

                    Rectangle{
                        id: customers_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: customers_image
                            source: "/res/customers.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: customers_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "MANAGE CUSTOMERS";
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: customers_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: customers_button
                            onClicked: {

                            }
                        }
                    }

                    Rectangle{
                        id: remote_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: remote_image
                            source: "/res/remote.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: remote_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "REMOTE PILOTS"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: remote_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: remote_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: missions_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: mission_image
                            source: "/res/mission.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: missions_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "MISSIONS"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mission_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: missions_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: manual_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: manual_mission_image
                            source: "/res/manual_mission.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: manual_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "MANUAL MISSIONS"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: manual_mission_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: manual_button
                            onClicked: {

                            }
                        }
                    }

                    Text{
                        id: insights
                        text: "Insights"
                        color : "white"
                        font.pointSize: 10
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 17
                        Layout.topMargin: 12

                    }
                    Rectangle{
                        id: profile_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: settings_image
                            source: "/res/settings.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: profile_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "PROFILE SETTINGS"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: settings_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: profile_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: notification_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: notification_image
                            source: "/res/notification.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: notification_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "NOTIFICATIONS"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: notification_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: notification_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: logout_button
                        width: menu_rect_1.width -15
                        height: 25
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: logout_image
                            source: "/res/logout.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: logout_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "LOGOUT"
                            color: "white"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: logout_image.left
                            anchors.leftMargin: 30
                         }

                        MouseArea{
                            anchors.fill: logout_button
                            onClicked: {

                            }
                        }
                    }
    /*=================== until here===========*/

                }
            }

            Rectangle {
                id: second_rectangle
                anchors.left: first_rectangle.Left
                width: parent.width/1.8
                height: parent.height
                visible: false
                color: "#031C28"
                border.color: "#05324D"
                border.width: 2

                Column {
                    id: second_rec_column1

                    Rectangle {
                        id: header
                        color: "#031C28"
                        height: 50
                        width: second_rectangle.width
                        border.color: "#05324D"
                        border.width: 1

                        Image {
                            id: hamburger_image
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text
                            text: "DASHBOARD"
                            color: "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Rectangle{
                        id: header2
                        color: "#031C28"
                        height: 300
                        width: second_rectangle.width
                        border.color: "#05324D"
                        border.width: 2
                        Text{
                            id: name
                            text: "Hi,"
                            color : "white"
                            font.pointSize: 8
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 20

                        }
                        Text{
                            id: name_1
                            text: "Chris Hemsworth"
                            color : "#F25822"
                            font.pointSize: 8
                            font.bold: true
                            anchors.left: parent.left
                            anchors.leftMargin: 35
                            anchors.top: parent.top
                            anchors.topMargin: 20

                        }
                        Text{
                            id: name2
                            text: "Welcome back to GoDrona"
                            color : "white"
                            font.pointSize: 10
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 50
                        }
                        Text{
                            id: name3
                            text: "OVERVIEW"
                            color : "white"
                            font.pointSize: 8
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 100

                        }

                        Row{
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 130
                            Row {
                                spacing: 15
                                Rectangle {
                                    color: "#05324D"
                                    width: 155; height: 120
                                    Text {
                                        id: flightlog
                                        text: qsTr("FLIGHT LOG")
                                        font.pointSize: 8
                                        anchors.centerIn: parent
                                        color: "white"
                                    }

                                }
                                Rectangle {
                                    color: "#05324D"
                                    width: 155; height: 120
                                    Text {
                                        id: firmware_update
                                        text: qsTr("FIRMWARE UPDATE")
                                        font.pointSize: 8
                                        anchors.centerIn: parent
                                        color: "white"
                                    }
                                }
                                Rectangle {
                                    color: "#05324D"
                                    width: 155; height: 120
                                    Text {
                                        id: backto_fly
                                        text: qsTr("BACK TO FLY")
                                        font.pointSize: 8
                                        anchors.centerIn: parent
                                        color: "white"
                                    }
                                }
                            }

                        }
                    }
                }
            }

            Rectangle {
                id: second_rec_division1
                width: second_rectangle.width
                height: second_rectangle.height
                anchors.left: first_rectangle.right
                color: "#031C28"
                visible: false
                border.color: "#05324D"
                border.width: 2

                ColumnLayout {
                    id: second_rec_column2
                    anchors.left: parent.left
                    anchors.top: parent.top
                    spacing: 5

                    Column{
                        Rectangle {
                            id:rpaheader
                            color: "#031C28"
                            height: 50
                            width: second_rec_division1.width
                            visible: true
                            border.color: "#05324D"
                            border.width: 2

                            Image {
                                id: hamburger_image_rpa
                                source: "/res/hamburger_menu.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: rpaheader.left
                                anchors.leftMargin: 20
                            }

                            Text {
                                id: managerpat_text
                                text: "MANAGE RPA"
                                color: "white"
                                font.pointSize: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: hamburger_image_rpa.left
                                anchors.leftMargin: 25
                            }

                            Image {
                                id: search_image_rpa
                                source: "/res/search.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: rpaheader.right
                                anchors.rightMargin: 180
                            }
                            Text{
                                id: search_rpa
                                text: "Search"
                                color : "white"
                                font.pointSize: 10
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: rpaheader.right
                                anchors.rightMargin: 100
                            }
                        }
                    }

                    Column{
                        id: rpa_list_column
                        Rectangle {
                            id:rpaheader1
                            color: "#031C28"
                            visible:false || true
                            height: parent.height-50
                            width: second_rec_division1.width
                            border.color: "#05324D"
                            border.width: 2

                            Text{
                                id: list_of_rpa_text
                                text: "LIST OF RPA"
                                color : "white"
                                font.pointSize: 10
                                font.bold: true
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 25
                            }

                            STYLE.Button {
                                id:register_rpa_button
                                anchors.right: rpaheader1.right
                                anchors.rightMargin: 30
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                Text {
                                    anchors.centerIn: parent
                                    text: "Register RPA"
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
                                    rpaheader1.visible = false
                                    rpa_register_page.visible = true
                                }
                            }

                            Item {
                                id: table_item
                                anchors.left: rpaheader1.left
                                anchors.leftMargin: 20
                                anchors.top: list_of_rpa_text.bottom
                                anchors.topMargin: 30
                                width: rpaheader1.width
                                height: rpaheader1.height + 400
                                visible: true

                                TableView {
                                    id: rpa_list_table
                                    topMargin: 35
                                    columnWidthProvider: function (modelData) { return 177; }
                                    rowHeightProvider: function (modelData) { return 50; }
                                    width: table_item.width - 50
                                    height: parent.height
                                    boundsBehavior: Flickable.StopAtBounds
                                    clip: true
                                    ScrollBar.vertical: ScrollBar {
                                        id: tableVerticalBar;
                                        policy:ScrollBar.AsNeeded
                                    }

                                    ScrollBar.horizontal: ScrollBar {
                                        policy: ScrollBar.AsNeeded
                                    }
                                    property int selectedRowIndex

                                    model: rpadatabase

                                    // Table Header
                                    Row {
                                        id: columnsHeader
                                        y: rpa_list_table.contentY
                                        z: 2

                                        Repeater {
                                            id: repeater_model
                                            model: rpa_list_table.columns > 0 ? rpa_list_table.columns : 1
                                            Rectangle {
                                                width: rpa_list_table.columnWidthProvider(modelData)
                                                height: 30
                                                color: "#031C28"

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: rpadatabase.headerData(modelData, Qt.Horizontal)
                                                    //anchors.verticalCenter: parent.verticalCenter
                                                    //anchors.horizontalCenter: parent.horizontalCenter
                                                    color: "White"
                                                }
                                            }
                                        }
                                    }

                                    //Table body

                                    delegate: Rectangle {
                                        id:rowrectcolumnsHeader
                                        y: 35
                                        color: "#031C28"

                                        TextArea{
                                            text: display // This is set in rpa_database.cpp roleNames()
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            color: 'white'
                                            font.pixelSize: 15
                                            verticalAlignment: Text.AlignVCenter
                                            //horizontalAlignment: Text.AlignHCenter
                                            wrapMode: Text.WordWrap
                                        }
                                    }

                                }
                            }
                        }
                    }

                    Column{
                        Rectangle{
                            id: rpa_register_page
                            color: "#031C28"
                            visible: false
                            height: parent.height - 100
                            width: rpaheader1.width
                            border.color: "#05324D"
                            border.width: 1

                            Rectangle {
                                id: back_arrow_button
                                anchors.left: rpa_register_page.left
                                anchors.leftMargin: 20
                                anchors.top: rpa_register_page.top
                                anchors.topMargin: 20

                                Image {
                                    source: "/res/back_arrow.png"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked : {
                                            rpa_register_page.visible =  false
                                            rpaheader1.visible = true
                                            //rpadatabase.callSql("USE QGC_User_Login")
                                            //rpadatabase.callSql("SELECT * From UsersLoginInfo")
                                            //rpadatabase.callSql("USE RpaInformation")
                                            //rpadatabase.callSql("SELECT * From RpaList")
                                        }
                                    }
                                }
                            }

                            Text{
                                id: add_edit_rpa_text
                                text: "ADD / EDIT RPA"
                                color : "white"
                                font.pointSize: 10
                                font.bold: true
                                anchors.left: back_arrow_button.left
                                anchors.leftMargin: 25
                                anchors.top: parent.top
                                anchors.topMargin: 20
                            }

                            Rectangle {
                                id: drone_contents
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 60
                                width: parent.width - 50
                                height: 450
                                color: "#05324D"
                                radius: 4

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
                                        //anchors.centerIn: parent
                                        Image {
                                            id:drone_image
                                            source: ""//"drone.png"
                                            anchors.fill: drone_image_container
                                            anchors.centerIn: parent
                                            layer.enabled: true
                                            layer.effect: OpacityMask {
                                                maskSource: drone_image
                                            }
                                        }
                                    }

                                    Text {
                                        id: drone_image_text
                                        anchors.left: drone_image_container.right
                                        anchors.leftMargin: 10
                                        text: qsTr("Drone Image")
                                        color: "White"
                                        font.pointSize: 12
                                    }

                                    Button {
                                        id: browse_image_button
                                        anchors.left: drone_image_container.right
                                        anchors.leftMargin: 10
                                        anchors.top:drone_image_text.bottom
                                        anchors.topMargin: 15

                                        contentItem :Text {
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
                                        //drone_image_container.color = "#031C28"
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
//                                            id: canvas
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
                                    anchors.rightMargin: 115
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
                                        anchors.leftMargin: 10
                                        text: qsTr ("RPA INFORMATIONS")
                                        color: "white"
                                        font.pointSize: 10
                                    }
                                }

                                Text {
                                    id:basic_details_text
                                    anchors.left: drone_contents.left
                                    anchors.leftMargin: 30
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
                                    anchors.leftMargin: 30
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
                                    anchors.rightMargin: 250
                                    anchors.top: drone_model_combo.top
                                    anchors.topMargin: 125
                                    text: qsTr("UIN")
                                    font.pointSize: 10
                                    color: "white"
                                }

                                Rectangle {
                                    id:uin_input_rect
                                    anchors.right: drone_contents.right
                                    anchors.rightMargin: 80
                                    anchors.top: drone_name_input.top
                                    anchors.topMargin: 25
                                    width: 200
                                    height: 35
                                    color: "#031C28"

                                    TextField {
                                        id:uin_input_text
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.margins: 5
                                        text: ''
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
                            }

                            Row {
                                spacing: 25
                                //anchors.left: drone_contents.horizontalCenter
                                anchors.left: drone_contents.left
                                anchors.leftMargin: parent.width/3.5
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
                                            //border.width: 1
                                            radius: 4
                                            color: "Green"
                                        }
                                    }
                                    onClicked: {
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
                                            //border.width: control.activeFocus ? 2 : 1
                                            //border.color: "#2c1608"
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
                        }


                    }
                }

            }
        }

    }




}
