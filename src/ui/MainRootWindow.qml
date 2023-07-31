/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick.Controls 2.4
import QtQuick.Controls 2.15
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4 as STYLE
import Qt.labs.qmlmodels 1.0
import QtGraphicalEffects 1.0
import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel 2.1

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.MultiVehicleManager   1.0

import TableModel                   1.0
import FireBaseAccess               1.0
import FirmwareUpdate               1.0

/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
ApplicationWindow {
    id:             mainWindow
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true

    property int  checkBoxNumber
    property var  newWindowObject
    property var  image_upload
    property int  updateButton   : 1
    property bool editUin        : true
    property int  number         : 0
    property real rectangleWidth : (table_rect.width - 40) / 5
    property int  checkBoxState  : 0
    property var _activeVehicle  : QGroundControl.multiVehicleManager.activeVehicle
    property var  group          : buttonGroup

    ButtonGroup {
        id: buttonGroup
        exclusive: true
    }

    FontLoader {
        id: fixedFont
        source: "/fonts/design.graffiti.mistral"
    }

    FirmwareUpdate{
        id: firmware_load1
    }

    FireBaseAccess{
        id: database_access
        onNameChanged:{
            profile_timer.start()
        }

        onAddressChanged: {
            address_field.text = database_access.address
        }

        onLocalityChanged: {
            locality_field.text = database_access.locality
        }

        onProfile_updated:{
            database_access.get_profile_update();
        }
        onSuccessfullLogin: {
            login_page_rectangle.z = -1
            landing_page_rectangle.visible    = true
            dashboard_rectangle.visible       = true
            landing_page_rectangle.visible    = true
            dashboard_rectangle.visible       = true
            users_profile_header1.visible     = true
            login_page_rectangle.visible      = false
            manage_rpa_rectangle.visible      = false
            flight_log_rectangle.visible      = false
            firmware_log_rectangle.visible    = false
            users_information_header1.visible = false
            rpa_register_page.visible         = false
            dashboard_button.color            = "#F25822"
            managerpa_button.color            = "#031C28"
            flight_log_button.color           = "#031C28"
            logout_button.color               = "#031C28"
            firmware_button.color             = "#031C28"
            profile_button.color              = "#031C28"
        }
        onEmailNotFound:{
            no_recordDialog.open()
        }
        onIncorrectPassword: {
            incorrect_password_Dialog.open()
        }
        onUserRegisteredSuccessfully: {
            rpadatabase.upload_function("user_profile.jpg",database_access.storagename, image_upload)
            userRegisteredDialog.open()
            login_page_rectangle.visible     = true
            new_user_first_page.visible      = false
            third_user_details_page.visible  = false
            second_user_details_page.visible = false
            first_circle.color               = "#F25822"
            second_circle.color              = "#031C28"
            third_circle.color               = "#031C28"
            first_circle_text.text           = "1"
            second_circle_text.text          = "2"

        }
        onMailAlreadyExists: {
            mailrecord_Dialog.open()
        }
        onResetMailFound: {
            password_updated.open()
            forgot_password_page_rectangle.visible = false
            login_page_rectangle.visible           = true
            forgot_password_mail_text.text         = ""
        }
        onResetMailNotFound: {
            password_mismatch.open()
            forgot_password_mail_text.text = ""
        }
    }

    TableModel{
        property int i : 0
        property var oldTableObject: null
        id: rpadatabase
        onUinFound:{
            uinrecord_Dialog.open()
        }
        onUinNotFound:{
            rpadatabase.add_rpa(drone_type_list.currentText,drone_model_list.currentText,drone_name_text.text,uin_input_text.text)
            i = 1
        }

        onDataAdded: {
            if(i == 1){
                rpadatabase.getData()
            }
            manage_rpa_header1.visible    = true
            rpa_register_page.visible     = false
            drone_type_list.currentIndex  = -1
            drone_model_list.currentIndex = -1
            drone_name_text.text          = ""
            uin_input_text.text           = ""

            if (oldTableObject !== null) {
                oldTableObject.destroy()
                oldTableObject = null
            }

            const newObject = Qt.createQmlObject(`
                                                 import QtQuick 2.0
                                                 import QtQuick.Controls 1.5
                                                 import QtQuick.Controls.Styles 1.2
                                                 import QtQuick.Controls.Styles 1.4
                                                 import QtQuick.Controls 2.15
                                                 TableView {
                                                 id: table
                                                 anchors.fill: parent
                                                 clip:true
                                                 anchors.top: table_rect.top
                                                 backgroundVisible: false
                                                 model:  rpadatabase
                                                 style: TableViewStyle {
                                                 headerDelegate: Rectangle {
                                                 height: textItem.implicitHeight * 2
                                                 width: textItem.implicitWidth
                                                 color: "#031C28"
                                                 border.width: 1
                                                 border.color: "#05324D"
                                                 Text {
                                                 id: textItem
                                                 anchors.centerIn: parent
                                                 text: styleData.value
                                                 font.pointSize: ScreenTools.smallFontPointSize
                                                 font.bold:true
                                                 elide: Text.ElideRight
                                                 color: '#F25822'
                                                 renderType: Text.NativeRendering
                                                 }
                                                 }
                                                 }
                                                 itemDelegate: Rectangle {
                                                 anchors.fill:parent
                                                 color: "#031C28"
                                                 border.width: 1
                                                 border.color: "#05324D"
                                                 Text {
                                                 anchors.centerIn:parent
                                                 color: "white"
                                                 text: styleData.value
                                                 font.pointSize: ScreenTools.smallFontPointSize
                                                 }
                                                 }
                                                 TableViewColumn {
                                                 id: checkbox
                                                 width: parent.width / 8
                                                 title: "Select"
                                                 movable: false
                                                 resizable: false
                                                 role: "checkbox"
                                                 delegate: Rectangle{
                                                 color: "#031C28"
                                                 border.width: 1
                                                 border.color:"#05324D"
                                                 CheckBox {
                                                 id: delegate_checkbox
                                                 anchors.centerIn: parent
                                                 checked: {((model.index === checknumber) && (checkBoxState===1)) ? true : false}
                                                 enabled: { _activeVehicle ? false:true }
                                                 indicator: Rectangle{
                                                 implicitWidth: 30
                                                 implicitHeight: 30
                                                 radius: 2
                                                 color: "#031C28"
                                                 border.width:0.5
                                                 border.color: "#F25822"
                                                 anchors.centerIn: parent
                                                 Rectangle {
                                                 color: delegate_checkbox.checked ? "#F25822" : "#031C28"
                                                 radius: 1
                                                 anchors.margins: 2
                                                 anchors.fill: parent
                                                 }
                                                 }
                                                 onCheckedChanged: {
                                                 if(delegate_checkbox.checked == true){
                                                 checkBoxState = 1
                                                 checkBoxNumber = model.index
                                                 checknumber = model.index
                                                 ButtonGroup.group = mainWindow.group
                                                 }
                                                 }
                                                 }
                                                 }
                                                 }
                                                 TableViewColumn {
                                                 width: (parent.width - checkbox.width)/4
                                                 id: type_column
                                                 title: "Type"
                                                 movable: false
                                                 resizable: false
                                                 role: "type"
                                                 }
                                                 TableViewColumn{
                                                 width: (parent.width - checkbox.width)/4
                                                 role: "model_name"
                                                 title: "Model Name"
                                                 movable: false
                                                 resizable: false
                                                 }
                                                 TableViewColumn{
                                                 width: (parent.width - checkbox.width)/4
                                                 role: "drone_name"
                                                 title: "Drone Name"
                                                 movable: false
                                                 resizable: false
                                                 }
                                                 TableViewColumn{
                                                 width: (parent.width - checkbox.width)/4
                                                 title: "UIN"
                                                 movable: false
                                                 resizable: false
                                                 role: "uin_number"
                                                 }
                                                 }
                                                 `,
                                                 table_rect,
                                                 "myDynamicSnippet"
                                                 );
            i = 0
            mainWindow.newWindowObject = newObject
            oldTableObject = newObject

        }
    }

    Rectangle{
        id: login_page_rectangle
        anchors.fill: parent
        z:1
        color: "#031C28"

        Image {
            id : login_page_godrona_image
            anchors.top : parent.top
            anchors.topMargin : 40
            anchors.horizontalCenter : parent.horizontalCenter
            width : 200
            height : 200
            source : "/res/godrona-logo.png"
        }
        Column{
            id: login_page_label
            spacing: 10
            anchors.left: mainWindow.left
            anchors.leftMargin: 20
            anchors.top: login_page_godrona_image.bottom
            anchors.topMargin: 20
            Label{
                text: "LOGIN/SIGN-IN ACCOUNT"
                color: "white"
                font.bold: true
                font.pointSize: ScreenTools.defaultFontPointSize * 1.1
            }
            Label{
                text: "- Hello, Welcome back to GoDrona"
                color: "#F25822"
                font.bold: true
                font.pointSize:ScreenTools.defaultFontPointSize
            }
        }
        Column{
            id: login_page_label_email_column
            spacing: 10
            anchors.top: login_page_label.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                text: "Email Address*"
                color: "white"
            }
            TextField{
                id: login_page_email_textfield
                width: mainWindow.width/3
                height: mainWindow.height/10
                text: ""
                color: "white"
                leftPadding: 70
                focus: true
                placeholderText: qsTr("example@gmail.com")
                inputMethodHints: Qt.ImhEmailCharactersOnly
                validator: RegExpValidator{regExp: /.+/}
                onTextChanged: {
                    login_page_email.border.color = "#C0C0C0"
                }
                Keys.onReturnPressed: {
                    login_page_password_textfield.forceActiveFocus()  // Move focus to the next text field
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
                    fillMode: Image.PreserveAspectFit
                    source: "/res/mailLogo.png"//"qrc:/../../../../Downloads/mailLogo.png"
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
                width: mainWindow.width/3
                height: mainWindow.height/10
                text: ""
                color: "white"
                focus: true
                placeholderText: qsTr("Password")
                leftPadding: 70
                rightPadding: 50
                validator: RegExpValidator { regExp: /.+/ }
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhNoPredictiveText
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
                    fillMode: Image.PreserveAspectFit
                    source: "/res/password.png"
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    id: password_hide_image
                    fillMode: Image.PreserveAspectFit
                    source: "/res/password_hide.png"
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
                    fillMode: Image.PreserveAspectFit
                    source: "/res/password_show.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            password_show_image.visible            = false
                            password_hide_image.visible            = true
                            login_page_password_textfield.echoMode = TextInput.Password
                        }
                    }
                }
            }

        }
        Button {

            anchors.top: login_page_label_password_column.bottom
            anchors.topMargin: 35
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                text: "Login Now ->"
                font.pointSize:ScreenTools.defaultFontPointSize
                font.bold: true
                anchors.centerIn: parent
                color: "white"

            }
            background: Rectangle {
                id: login_button
                implicitWidth: mainWindow.width/3
                implicitHeight: mainWindow.height/10
                color: "#F25822"
                radius: 4
            }
            MessageDialog{
                id:messagedialog1
                text:qsTr("Please enter your details correctly")
            }
            onPressed: {
                login_button.color = "#05324D"
            }
            onReleased: {
                login_button.color = "#F25822"
            }
            onClicked: {
                if (login_page_email_textfield.text !== "" && login_page_password_textfield.text !== "") {
                    database_access.registered_user(login_page_email_textfield.text,login_page_password_textfield.text)
                } else {
                    messagedialog1.visible = true
                }
                rpadatabase.download_function_firmware(QGroundControl.settingsManager.appSettings.telemetrySavePath)
                rpadatabase.image_function("user_profile.jpg",database_access.firebasejsonname)
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
                font.pointSize:ScreenTools.defaultFontPointSize
                color: "white"
                Image{
                    id: new_user_logo
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/res/new_member.png" //"qrc:/../../../../Downloads/new_member.png"

                }
                MouseArea{
                    anchors.fill: new_user_logo
                    onClicked: {
                        password_hide_image.visible            = true
                        password_show_image.visible            = false
                        new_user_first_page.visible            = true
                        first_user_details_page.visible        = true
                        login_page_email_textfield.text        = ""
                        login_page_password_textfield.text     = ""
                        login_page_password_textfield.echoMode = TextInput.Password
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
                font.pointSize:ScreenTools.defaultFontPointSize
                color: "white"
                Image{
                    id: forgot_password_logo
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/res/forgotpassword.png"
                }
                MouseArea{
                    anchors.fill: forgot_password_logo
                    onClicked: {
                        password_hide_image.visible            = true
                        password_show_image.visible            = false
                        login_page_rectangle.visible           = false
                        forgot_password_page_rectangle.visible = true
                        login_page_email_textfield.text        = ""
                        login_page_password_textfield.text     = ""
                        login_page_password_textfield.echoMode = TextInput.Password
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
            font.pointSize: ScreenTools.defaultFontPointSize
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
                    login_page_rectangle.visible           = true
                    forgot_password_mail_text.text         = ""
                    password_hide_image.visible            = true
                    password_show_image.visible            = false
                    login_page_password_textfield.echoMode = TextInput.Password
                }
            }
        }
        Column{
            anchors.centerIn: parent
            spacing: 60
            Label{
                text: qsTr("Enter your registered email address to")
                color: "white"
                font.pointSize:ScreenTools.defaultFontPointSize
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
                    width: mainWindow.width/3
                    height: mainWindow.height/10
                    text: ""
                    color: "white"
                    placeholderText: qsTr("example@gmail.com")
                    inputMethodHints: Qt.ImhEmailCharactersOnly
                    leftPadding: 70
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
                        fillMode: Image.PreserveAspectFit
                        source: "/res/mailLogo.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text: qsTr("Submit ->")
                    font.pointSize:ScreenTools.defaultFontPointSize
                    anchors.centerIn: parent
                    color: "white"
                }
                background: Rectangle {
                    id: submit_button
                    implicitWidth: mainWindow.width/3
                    implicitHeight: mainWindow.height/10
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
                    database_access.reset_password(forgot_password_mail_text.text)

                }
            }
            Label{
                text: qsTr("Reset Password")
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
                    text: qsTr("registered email address")
                    color: "white"
                }
            }
        }
        Image{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 70
            width: 90
            height: 90
            source: "/res/backtologin-removebg-preview.png"
            Label{
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Back to Login")
                color: "white"
                font.pointSize: ScreenTools.defaultFontPointSize
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    forgot_password_page_rectangle.visible = false
                    login_page_rectangle.visible           = true
                    user_name_text.text                    = ""
                    user_mail_text.text                    = ""
                    user_number_text.text                  = ""
                    user_address_text.text                 = ""
                    user_locality_text.text                = ""
                    user_password_text.text                = ""
                    forgot_password_mail_text.text         = ""
                    password_show_image.visible            = false
                    password_hide_image.visible            = true
                    login_page_password_textfield.echoMode = TextInput.Password
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
                    reset_password_page_rectangle.visible  = false
                    forgot_password_page_rectangle.visible = true
                    new_password_hide_image.visible        = true
                    new_password_show_image.visible        = false
                    confirm_password_hide_image.visible    = true
                    confirm_password_show_image.visible    = false
                    password_hide_image.visible            = true
                    password_show_image.visible            = false
                    new_password_textfield.echoMode        = TextInput.Password
                    confirm_password_textfield.echoMode    = TextInput.Password
                    new_password_textfield.text            = ""
                    confirm_password_textfield.text        = ""
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
                    placeholderText: qsTr("password")
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
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: new_password_hide_image
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_hide.png"
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
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_show.png"
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
                    placeholderText: qsTr("password")
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
                        source: "/res/password.png"//"qrc:/../../../../Downloads/password.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: confirm_password_hide_image
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_hide.png"
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
                        visible: false
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_show.png"
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
                        new_password_textfield.text     = ""
                        confirm_password_textfield.text = ""
                    }
                    else{
                        password_updated.open()
                        reset_password_page_rectangle.visible = false
                        login_page_rectangle.visible          = true
                        new_password_hide_image.visible       = true
                        new_password_show_image.visible       = false
                        new_password_textfield.echoMode       = TextInput.Password
                        confirm_password_textfield.echoMode   = TextInput.Password
                        confirm_password_hide_image.visible   = true
                        confirm_password_show_image.visible   = false
                        new_password_textfield.text           = ""
                        confirm_password_textfield.text       = ""
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
            text: qsTr("<- Registration")
            font.pointSize:ScreenTools.defaultFontPointSize
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
                font.pointSize:ScreenTools.defaultFontPointSize
            }


            MouseArea{
                anchors.fill: parent
                onClicked: {
                    new_user_first_page.visible  = false
                    login_page_rectangle.visible = true
                    password_hide_image.visible  = true
                    password_show_image.visible  = false
                    password_show_image1.visible = false
                    password_hide_image1.visible = true
                    user_name_text.text          = ""
                    user_mail_text.text          = ""
                    user_number_text.text        = ""
                    user_address_text.text       = ""
                    user_locality_text.text      = ""
                    user_password_text.text      = ""
                    control.currentIndex         = -1
                    control_role.currentIndex    = -1

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
                width: 60
                height: 60
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#F25822"
                Text{
                    id: first_circle_text
                    text: "1"
                    font.pointSize:ScreenTools.defaultFontPointSize
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
                width: 60
                height: 60
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#031C28"
                Text{
                    id: second_circle_text
                    text: "2"
                    font.pointSize:ScreenTools.defaultFontPointSize
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
                width: 60
                height: 60
                radius: width / 2
                border.color: "#C0C0C0"
                border.width: 1.5
                color: "#031C28"
                Text{
                    id: third_circle_text
                    text: "3"
                    color: "white"
                    font.pointSize:ScreenTools.defaultFontPointSize
                    anchors.centerIn: parent
                }
            }
        }
        Rectangle{
            id: first_user_details_page
            width: parent.width
            anchors.top: circle_row.bottom
            anchors.topMargin: 50
            height: parent.height
            color: "#031C28"
            Column{
                spacing: 20
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    text: "Select Your Industry Type*"
                    color: "white"
                    font.pointSize:ScreenTools.defaultFontPointSize
                }
                ComboBox {
                    id: control
                    model: ["Drone Education & Training","Asset Inspection","Security & Surveillance","Public Survey","Oil & Gas Inspection","Industrial Inspection","Agricultural Usage","Goods Delivery"]
                    width: mainWindow.width/3
                    height: mainWindow.height/10
                    currentIndex: -1
                    displayText: currentIndex === -1 ? "Select Industry Type" : currentText
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
                        width: 20
                        height: 20
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
                        leftPadding: 80
                        rightPadding: control.indicator.width + control.spacing
                        text: control.displayText
                        font: control.font
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        Image{
                            id: organization_image
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            source: "/res/organization.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: mainWindow.width/3
                        implicitHeight: mainWindow.height/10
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
                Label{
                    text: "Select Your Role*"
                    color: "white"
                    font.pointSize:ScreenTools.defaultFontPointSize
                }
                ComboBox {
                    id: control_role
                    model: ["OEM","PILOT","OPERTAOR"]
                    width: mainWindow.width/3
                    height: mainWindow.height/10
                    currentIndex: -1
                    displayText: currentIndex === -1 ? "Select Role" : currentText
                    delegate: ItemDelegate {
                        width: control_role.width
                        contentItem: Text {
                            text: control_role.textRole
                                  ? (Array.isArray(control_role.model) ? modelData[control_role.textRole] : model[control_role.textRole])
                                  : modelData
                            color: "black"
                            font: control_role.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: control_role.highlightedIndex === index
                    }
                    indicator: Canvas {
                        id: canvas_role
                        x: control_role.width - width - control_role.rightPadding
                        y: control_role.topPadding + (control_role.availableHeight - height) / 2
                        width: 20
                        height: 20
                        contextType: "2d"
                        Connections {
                            target: control_role
                            function onPressedChanged() { canvas_role.requestPaint(); }
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
                        id: combobox_role_text
                        leftPadding: 80
                        rightPadding: control_role.indicator.width + control_role.spacing
                        text: control_role.displayText
                        font: control_role.font
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        Image{
                            id: role_image
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            source: "/res/role.png"//"qrc:/../../../../Downloads/organization.png"
                        }
                    }
                    background: Rectangle {
                        implicitWidth: mainWindow.width/3
                        implicitHeight: mainWindow.height/10
                        color: "#031C28"
                        border.color: "#00FFFF"
                        border.width: control_role.visualFocus ? 2 : 1
                        radius: 2
                    }
                    popup: Popup {
                        y: control_role.height - 1
                        width: control_role.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 1
                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: control_role.popup.visible ? control_role.delegateModel : null
                            currentIndex: control_role.highlightedIndex

                            ScrollIndicator.vertical: ScrollIndicator { }
                        }
                        background: Rectangle {
                            border.color: "#00FFFF"
                            radius: 2
                        }
                    }
                }
                Button {
                    anchors.top: first_user_details_page.bottom
                    anchors.topMargin: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        text: "Next Step ->"
                        font.pointSize:ScreenTools.defaultFontPointSize
                        font.bold: true
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: next_step_submit_button
                        implicitWidth:  mainWindow.width/3
                        implicitHeight: mainWindow.height/10
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
                        if(combobox_text.text === "Select Industry Type" || control.currentIndex === -1){
                            selectIndustryDialog.open()
                        }
                        else if(combobox_role_text.text == "Select Role" || control_role.currentIndex == -1){
                            selectRoleDialog.open()
                        }

                        else{
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
        }
        Rectangle{
            id: second_user_details_page
            visible: false
            width: parent.width
            anchors.top: circle_row.bottom
            anchors.topMargin: 20
            height: parent.height
            color: "#031C28"
            Label {
                text: "Upload Your Image*"
                anchors.left: user_image.right
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 25
                color: "white"
            }
            Rectangle{
                id: user_image
                height: mainWindow.height/10
                width: height
                radius: width / 2
                color: "white"
                clip: true
                anchors.horizontalCenter: parent.horizontalCenter
                Image{
                    anchors.fill: user_image
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/res/user_photo.png"

                }
                Image{
                    id:user_profile_image
                    anchors.fill: user_image
                    width: 75
                    height: 75
                    visible: true
                    source: image_file_dialog.fileUrl
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: user_image
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        image_file_dialog.open()
                    }
                }
            }

            Rectangle{
                id: scrollview
                width: parent.width
                height: parent.height / 2
                anchors.top: user_image.bottom
                anchors.topMargin: 2
                border.width: 1
                border.color: "#05324D"
                color: "#031C28"
                ScrollView {
                    anchors.fill: parent
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    contentWidth: parent.width
                    Column{
                        id: column
                        spacing: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 750
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label{
                            text: "Full Name*"
                            color: "white"
                        }
                        TextField{
                            id: user_name_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            placeholderText: qsTr("Your Name")
                            leftPadding: 70
                            onTextChanged: {
                                user_name.border.color = "#C0C0C0"
                            }
                            Keys.onReturnPressed: {
                                user_mail_text.forceActiveFocus()
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
                                fillMode: Image.PreserveAspectFit
                                source: "/res/user_image.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Label{
                            text: "Email Address*"
                            color: "white"
                        }
                        TextField{
                            id: user_mail_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            placeholderText: qsTr("example@gmail.com")
                            inputMethodHints: Qt.ImhEmailCharactersOnly
                            //validator: RegExpValidator{regExp:/[A-Z0-9a-z._-]{1,}@(\\w+)(\\.(\\w+))(\\.(\\w+))?(\\.(\\w+))?$"*/}
                            leftPadding: 70
                            onTextChanged: {
                                user_mail.border.color = "#C0C0C0"
                            }
                            Keys.onReturnPressed: {
                                user_number_text.forceActiveFocus()
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
                                fillMode: Image.PreserveAspectFit
                                source: "/res/mailLogo.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Label{
                            text: "Mobile Number*"
                            color: "white"
                        }
                        TextField{
                            id: user_number_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            maximumLength: 10
                            placeholderText: qsTr("Your Mobile Number")
                            leftPadding: 160
                            validator: RegExpValidator{regExp: /[0-9,/]*/}
                            onTextChanged: {
                                user_number.border.color = "#C0C0C0"
                            }
                            Keys.onReturnPressed: {
                                user_address_text.forceActiveFocus()
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
                                id:image
                                fillMode: Image.PreserveAspectFit
                                source: "/res/user_phone.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                anchors.left: image.right
                                anchors.leftMargin:3
                                anchors.verticalCenter: parent.verticalCenter
                                text: "+91"
                                color: "white"
                            }
                        }

                        Label{
                            text: "Address Line*"
                            color: "white"
                        }
                        TextField{
                            id: user_address_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            placeholderText: qsTr("Your Address")
                            leftPadding: 70
                            onTextChanged: {
                                user_address.border.color = "#C0C0C0"
                            }
                            Keys.onReturnPressed: {
                                user_locality_text.forceActiveFocus()
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
                                fillMode: Image.PreserveAspectFit
                                source: "/res/user_location.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Label{
                            text: "Locality*"
                            color: "white"
                        }
                        TextField{
                            id: user_locality_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            placeholderText: qsTr("Your Locality")
                            leftPadding: 70
                            onTextChanged: {
                                user_locality.border.color = "#C0C0C0"
                            }
                            Keys.onReturnPressed: {
                                user_password_text.forceActiveFocus()
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
                                fillMode: Image.PreserveAspectFit
                                source: "/res/user_locality.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Label{
                            text: "Password*"
                            color: "white"
                        }
                        TextField{
                            id: user_password_text
                            width: mainWindow.width/3
                            height: mainWindow.height/10
                            text: ""
                            color: "white"
                            placeholderText: qsTr("password")
                            leftPadding: 70
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
                                fillMode: Image.PreserveAspectFit
                                source: "/res/password.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Image {
                                id: password_hide_image1
                                fillMode: Image.PreserveAspectFit
                                source: "/res/password_hide.png"
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        password_hide_image1.visible = false
                                        password_show_image1.visible = true
                                        user_password_text.echoMode  = TextInput.Normal
                                    }
                                }
                            }
                            Image {
                                id: password_show_image1
                                visible: false
                                fillMode: Image.PreserveAspectFit
                                source: "/res/password_show.png"
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        password_show_image1.visible = false
                                        password_hide_image1.visible = true
                                        user_password_text.echoMode  = TextInput.Password
                                    }
                                }
                            }
                        }
                        Label{
                            text: "*Password must be at least 6 characters"
                            color: "white"
                            font.pointSize:ScreenTools.smallFontPointSize
                        }
                    }
                }
            }
            Column{
                anchors.top: scrollview.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Button {
                    Text{
                        text: "Verify Account ->"
                        font.pointSize: ScreenTools.defaultFontPointSize
                        font.bold: true
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: verify_account_button
                        implicitWidth: mainWindow.width/4
                        implicitHeight:  mainWindow.height/10
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
                        if(user_name_text.text               == ""
                                || user_mail_text.text       == ""
                                || user_number_text.text     == ""
                                || user_address_text.text    == ""
                                || user_locality_text.text   == ""
                                || user_password_text.text   == ""
                                || user_profile_image.source == ""){
                            enter_all_fields.open()
                        }
                        else{
                            if(user_password_text.text.length < 6){
                                password_length_error_dialog.open()
                            }
                            else{
                                second_user_details_page.visible = false
                                third_user_details_page.visible  = true
                                second_circle_text.text          = "/"
                                second_circle.color              = "green"
                                third_circle.color               = "#F25822"
                                password_hide_image1.visible     = true
                                password_show_image1.visible     = false
                            }
                        }
                    }
                }
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "PREVIOUS STEP"
                    font.pointSize:ScreenTools.defaultFontPointSize
                    font.bold: true
                    color: "white"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            first_circle_text.text           = "1"
                            second_circle_text.text          = "2"
                            first_circle.color               = "#F25822"
                            second_circle.color              = "#031C28"
                            second_user_details_page.visible = false
                            first_user_details_page.visible  = true
                            password_hide_image1.visible     = true
                            password_show_image1.visible     = false
                            user_name_text.text              == ""
                            user_mail_text.text              == ""
                            user_number_text.text            == ""
                            user_address_text.text           == ""
                            user_locality_text.text          == ""
                            user_password_text.text          == ""
                            control.currentIndex             = -1
                            control_role.currentIndex        = -1
                            user_image.color                 = "white"
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
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 20
                text: "Please enter the"
                color: "white"
                font.pointSize:ScreenTools.defaultFontPointSize
                Label{
                    anchors.left: parent.right
                    anchors.leftMargin: 3
                    text: "One Time Password"
                    color: "#00FFFF"
                    font.pointSize:ScreenTools.defaultFontPointSize
                }
            }
            Row{
                id: otp_row
                spacing: 30
                anchors.top: otp_label.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
                TextField{
                    height: mainWindow.height/12
                    width: height
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
                        border.width: 2
                    }
                }
            }
            Row{
                id: otp_error
                spacing: 110
                anchors.top: otp_row.bottom
                anchors.topMargin: 40
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
                anchors.topMargin: 90
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
                        font.pointSize:ScreenTools.defaultFontPointSize
                        font.bold: true
                        anchors.centerIn: parent
                        color: "white"
                    }
                    background: Rectangle {
                        id: verify_now_button
                        implicitWidth: mainWindow.width/3
                        implicitHeight:  mainWindow.height/10
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
                        database_access.new_user_registration(combobox_text.text,combobox_role_text.text,user_name_text.text,user_mail_text.text,user_number_text.text,user_address_text.text,user_locality_text.text,user_password_text.text)
                        control.currentIndex        = -1
                        control_role.currentIndex   = -1
                        user_name_text.text         = ''
                        user_mail_text.text         = ''
                        user_number_text.text       = ''
                        user_address_text.text      = ''
                        user_locality_text.text     = ''
                        user_password_text.text     = ''
                        user_image.color            = "white"
                        user_profile_image.source   == ""
                        user_profile_image.visible  = false
                    }
                }
            }
            Label{
                anchors.top: otp_column.bottom
                anchors.topMargin: 60
                anchors.horizontalCenter: parent.horizontalCenter
                text: "PREVIOUS STEP"
                font.bold: true
                color: "white"
                font.pointSize:ScreenTools.defaultFontPointSize
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        second_circle_text.text          = "2"
                        second_circle.color              = "#031C28"
                        third_circle.color               = "#031C28"
                        third_user_details_page.visible  = false
                        second_user_details_page.visible = true
                    }
                }
            }
        }
        Image{
            id: back_to_login_logo
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 90
            width: 90
            height: 90
            source: "/res/backtologin-removebg-preview.png"
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
        nameFilters: [ "(*.jpg)"]
        selectMultiple: false
        onAccepted: {
            user_profile_image.visible = true
            var filePath = fileUrl.toString().replace("file://", "")
            image_upload = filePath;
        }
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
    MessageDialog {
        id: no_recordDialog
        title: "New User"
        text: qsTr("We think your are a new user")
        informativeText: "Please Sign up/ Create a New Account."
        icon: StandardIcon.Warning
        standardButtons: Dialog.Ok
        onButtonClicked: {
            login_page_email_textfield.text    = ""
            login_page_password_textfield.text = ""
        }
    }
    MessageDialog {
        id: incorrect_password_Dialog
        title: "Wrong Password"
        text: qsTr("Entered password is incorrect")
        standardButtons: Dialog.Ok
    }

    MessageDialog{
        id: selectIndustryDialog
        title: "Industry Type"
        text: "Please Select the Industry Type."
        standardButtons: Dialog.Ok
    }
    MessageDialog {
        id: selectRoleDialog
        title: "Role Type"
        text: "Please Select the Role."
    }
    MessageDialog{
        id: aboutDialog
        title: "About"
        text:"GoDrona GCS V1.0"
        informativeText: "@2023 Casca E-Connect Private Limited"
    }

    MessageDialog {
        id: userRegisteredDialog
        title:"Registration Successfull"
        text: "Registered Successfully"
        standardButtons: Dialog.Ok
    }

    MessageDialog {
        id: signout_Dialog
        title: "Sign Out"
        text: "Are You Sure you want to Sign Out?."
        standardButtons: Dialog.Yes | Dialog.No
        onYes: {
            landing_page_rectangle.visible     = false
            flightView.visible                 = false
            planView.visible                   = false
            login_page_rectangle.visible       = true
            login_page_email_textfield.text    = ""
            login_page_password_textfield.text = ""
            password_hide_image.visible        = true
            password_show_image.visible        = false
            checkBoxState = 0
        }
        onNo: {
            landing_page_rectangle.visible = true
        }
    }
    MessageDialog {
        id: mailrecord_Dialog
        title: "Already Registered Mail"
        text: "Entered Mail is Already Registered."
        standardButtons: Dialog.Ok
        onAccepted: {
            user_mail_text.text = ""
        }
    }

    MessageDialog {
        id: uinrecord_Dialog
        title: "Already used UIN"
        text: "Entered UIN is Already Used."
        standardButtons: Dialog.Ok

    }
    MessageDialog {
        id: mailrecord_not_found
        title: "Wrong Mail ID"
        text: "Please provide your Valid Mail Id"
    }

    MessageDialog {
        id: connection_not_established_dialog
        title: "Connection Lost"
        text: "Connection not established, Please try after Sometime."
    }
    MessageDialog {
        id: connectionLostdialog
        title: "Connection Lost"
        text: "Connection Lost, Please check your Internet Connection."
    }
    MessageDialog {
        id: enter_all_fields
        text: "Please fill all the details"
    }
    MessageDialog {
        id: password_mismatch
        title: "Mismatch"
        text: "Both passwords do not match"
    }
    MessageDialog {
        id: password_length_error_dialog
        title: "Password Length Error"
        text: "Password Length must be greater than 6"
    }
    MessageDialog {
        id: password_updated
        title: "Updated"
        text: "Password Reset Link sent to the respective Mail."
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
        //firstRunPromptManager.nextPrompt()
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
        //visible:    (login_page_rectangle.z != 1) && (landing_page_rectangle.z != 1) && !QGroundControl.videoManager.fullScreen
        visible:{
            if(login_page_rectangle || landing_page_rectangle){
                toolbar.visible = false
            }
        }
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
                            text:                   qsTr("%1 Version").arg(QGroundControl.appName) + " v1.0"
                            font.pointSize:         ScreenTools.smallFontPointSize
                            wrapMode:               QGCLabel.WordWrap
                            Layout.maximumWidth:    parent.width
                            Layout.alignment:       Qt.AlignHCenter
                        }

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

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: first_rectangle
                color: "#031C28"
                Layout.preferredWidth: mainWindow.width/5
                Layout.maximumWidth: mainWindow.width/5 + 100
                Layout.minimumWidth: mainWindow.width/5 - 100
                Layout.preferredHeight: mainWindow.height

                ColumnLayout {
                    id: menu_column
                    anchors.fill: parent
                    spacing: 12

                    Rectangle{
                        id:brand_rect
                        height: 100
                        Layout.fillWidth: true
                        width: first_rectangle.width
                        color: "#031C28"
                        Text {
                            id: brand_text
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: brand_rect.right
                            anchors.rightMargin: 30
                            text: qsTr("GoDrona GCS")
                            font.family: "Mistral"
                            font.pointSize:ScreenTools.defaultFontPointSize * 1.4
                            font.bold: true
                            color: "white"
                        }
                        Rectangle{
                            id: brand_logo
                            width: 120
                            height: 120
                            anchors.left: brand_rect.left
                            anchors.leftMargin:30
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#031C28"
                            Image {
                                anchors.fill: parent
                                source: "/res/goDrona.png"
                            }
                        }
                    }
                    Rectangle {
                        id: menu_rect_1
                        color: "#05324D"
                        height: 50
                        width: first_rectangle.width
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true


                        Image {
                            id: home_image
                            source: "/res/home.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: menu_rect_1.left
                            anchors.leftMargin: 30
                        }

                        Text {
                            id:landing_page_text
                            text: "HOME"
                            color: "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: home_image.left
                            anchors.leftMargin: 35
                        }
                    }

                    Text{
                        id: management
                        text: "Management"
                        color : "white"
                        font.pointSize: ScreenTools.smallFontPointSize * 1.2
                        font.bold: true
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 17
                        Layout.topMargin: 12
                    }

                    Rectangle{
                        id: dashboard_button
                        width: menu_rect_1.width -15
                        height: 50
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: dashboard_image
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_button.left
                            anchors.leftMargin: 20
                            source: "/res/dashboard.png"
                        }

                        ColorOverlay{
                            anchors.fill: dashboard_image
                            source: dashboard_image
                            color: "#60FFFFFF"
                        }
                        Text{
                            text: "DASHBOARD";
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_image.left
                            anchors.leftMargin: 35
                        }


                        MouseArea{
                            id:mouseArea
                            anchors.fill: dashboard_button
                            onClicked: {
                                dashboard_rectangle.visible       = true
                                users_profile_header1.visible     = true
                                manage_rpa_rectangle.visible      = false
                                flight_log_rectangle.visible      = false
                                rpa_register_page.visible         = false
                                firmware_log_rectangle.visible    = false
                                users_information_header1.visible = false
                                dashboard_button.color            = "#F25822" || "#031C28"
                                logout_button.color               = "#031C28"
                                managerpa_button.color            = "#031C28"
                                flight_log_button.color           = "#031C28"
                                firmware_button.color             = "#031C28"
                                profile_button.color              = "#031C28"
                                about_button.color                = "#031C28"

                            }
                        }

                    }

                    Rectangle{
                        id: managerpa_button
                        width: menu_rect_1.width -15
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: landingrpa_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: managerpa_button
                            onClicked: {
                                rpadatabase.manageRpaClicked(database_access.mail)
                                manage_rpa_rectangle.visible      = true
                                users_profile_header1.visible     = true
                                manage_rpa_header1.visible        = true
                                dashboard_rectangle.visible       = false
                                flight_log_rectangle.visible      = false
                                firmware_log_rectangle.visible    = false
                                users_information_header1.visible = false
                                managerpa_button.color            = "#F25822"
                                logout_button.color               = "#031C28"
                                dashboard_button.color            = "#031C28"
                                flight_log_button.color           = "#031C28"
                                firmware_button.color             = "#031C28"
                                profile_button.color              = "#031C28"
                                about_button.color                = "#031C28"
                            }
                        }
                    }

                    /*===========add when necessary============*/

                    Rectangle{
                        id: customers_button
                        width: menu_rect_1.width -15
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: customers_image.left
                            anchors.leftMargin: 35
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
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: remote_image.left
                            anchors.leftMargin: 35
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
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mission_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: missions_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: create_button
                        width: menu_rect_1.width -15
                        height: 50
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: create_mission_image
                            source: "/res/create_mission.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: create_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "CREATE MISSIONS"
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: create_mission_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: create_button
                            onClicked: {

                            }
                        }
                    }

                    Rectangle{
                        id: flight_log_button
                        width: menu_rect_1.width -15
                        height: 50
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: log_image
                            source: "/res/log.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: flight_log_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "FLIGHT LOG"
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: log_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: flight_log_button
                            onClicked: {
                                rpadatabase.read_text_file(database_access.mail,QGroundControl.settingsManager.appSettings.telemetrySavePath)
                                flight_log_rectangle.visible      = true
                                users_profile_header1.visible     = true
                                manage_rpa_rectangle.visible      = false
                                dashboard_rectangle.visible       = false
                                rpa_register_page.visible         = false
                                firmware_log_rectangle.visible    = false
                                users_information_header1.visible = false
                                flight_log_button.color           = "#F25822"
                                logout_button.color               = "#031C28"
                                managerpa_button.color            = "#031C28"
                                dashboard_button.color            = "#031C28"
                                firmware_button.color             = "#031C28"
                                profile_button.color              = "#031C28"
                                about_button.color                = "#031C28"
                            }
                        }
                    }

                    Rectangle{
                        id: firmware_button
                        width: menu_rect_1.width -15
                        height: 50
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: firmware_log_image
                            source: "/res/firmware.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: firmware_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "FIRMWARE LOG"
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: firmware_log_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: firmware_button
                            onClicked: {
                                firmware_log_rectangle.visible    = true
                                users_profile_header1.visible     = true
                                flight_log_rectangle.visible      = false
                                manage_rpa_rectangle.visible      = false
                                dashboard_rectangle.visible       = false
                                rpa_register_page.visible         = false
                                users_information_header1.visible = false
                                flight_log_rectangle.visible      = false
                                firmware_button.color             = "#F25822"
                                logout_button.color               = "#031C28"
                                managerpa_button.color            = "#031C28"
                                dashboard_button.color            = "#031C28"
                                flight_log_button.color           = "#031C28"
                                profile_button.color              = "#031C28"
                                about_button.color                = "#031C28"
                                rpadatabase.firmwareupgrade_data()
                            }
                        }
                    }

                    Text{
                        id: insights
                        text: "Insights"
                        color : "white"
                        font.pointSize: ScreenTools.smallFontPointSize *1.2
                        font.bold: true
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 17
                        Layout.topMargin: 12

                    }
                    Rectangle{
                        id: profile_button
                        width: menu_rect_1.width -15
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: settings_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: profile_button
                            onClicked: {
                                users_profile_header1.visible     = false
                                users_information_header1.visible = true
                                address_field.activeFocus         = true
                                locality_field.activeFocus        = true
                                profile_button.color              = "#F25822"
                                logout_button.color               = "#031C28"
                                managerpa_button.color            = "#031C28"
                                dashboard_button.color            = "#031C28"
                                firmware_button.color             = "#031C28"
                                flight_log_button.color           = "#031C28"
                                about_button.color                = "#031C28"
                                userprofile_name.text             = database_access.name
                                mail_address.text                 = database_access.mail
                                mobile_number.text                = database_access.number
                                address_field.text                = database_access.address
                                locality_field.text               = database_access.locality
                            }
                        }
                    }
                    Rectangle{
                        id: notification_button
                        width: menu_rect_1.width -15
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: notification_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: notification_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: about_button
                        width: menu_rect_1.width -15
                        height: 50
                        color: "#031C28"
                        radius: 4
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10

                        Image {
                            id: about_image
                            source: "/res/about.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: about_button.left
                            anchors.leftMargin: 20
                        }
                        Text{
                            text: "ABOUT"
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: about_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: about_button
                            onClicked: {
                                aboutDialog.open()
                                about_button.color      = "#F25822"
                                logout_button.color     = "#031C28"
                                managerpa_button.color  = "#031C28"
                                dashboard_button.color  = "#031C28"
                                flight_log_button.color = "#031C28"
                                firmware_button.color   = "#031C28"
                                profile_button.color    = "#031C28"
                            }
                        }
                    }
                    Rectangle{
                        id: logout_button
                        width: menu_rect_1.width -15
                        height: 50
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
                            color: "#FFFFFF"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: logout_image.left
                            anchors.leftMargin: 35
                        }

                        MouseArea{
                            anchors.fill: logout_button
                            onClicked: {
                                if(!_activeVehicle){
                                signout_Dialog.open()
                                users_profile_header1.visible     = true
                                users_information_header1.visible = false
                                logout_button.color               = "#F25822"
                                dashboard_button.color            = "#031C28"
                                managerpa_button.color            = "#031C28"
                                flight_log_button.color           = "#031C28"
                                firmware_button.color             = "#031C28"
                                profile_button.color              = "#031C28"
                                about_button.color                = "#031C28"
                                login_page_email.border.color     = "#05324D"
                                login_page_password.border.color  = "#05324D"

                                }
                                else {
                                    signout_message_dialog.open()
                                }
                            }
                        }
                    }
                }
            }

            MessageDialog{
                id: signout_message_dialog
                text: "You still have a Active vehicle. Please disconnect before you logout"
            }
            Rectangle {
                id: second_rectangle
                Layout.preferredWidth: mainWindow.width/1.65
                Layout.maximumWidth: mainWindow.width/1.65 + 100
                Layout.minimumWidth: mainWindow.width/1.65 - 100
                Layout.preferredHeight: mainWindow.height
                color: "#031C28"
                border.color: "#05324D"
                border.width: 1

                Rectangle {
                    id: dashboard_rectangle
                    width: second_rectangle.width
                    visible: false
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id: dashboard_rectangle_header
                        color: "#031C28"
                        height:  mainWindow.height/10
                        width: dashboard_rectangle.width
                        border.color: "#05324D"
                        border.width: 2

                        Image {
                            id: hamburger_image
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_rectangle_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text
                            text: "DASHBOARD"
                            color: "white"
                            font.bold: true
                            font.pointSize: ScreenTools.smallFontPointSize
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image.left
                            anchors.leftMargin: 35
                        }

                        Image {
                            id: search_image
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: dashboard_rectangle_header.right
                            anchors.rightMargin: 220
                        }
                        Text{
                            id: dashboard_text_search
                            text: "Search"
                            color : "white"
                            font.bold: true
                            font.pointSize:ScreenTools.smallFontPointSize
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: dashboard_rectangle_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        id: dashboard_rectangle_column
                        anchors.left: parent.left
                        anchors.top: dashboard_rectangle_header.bottom

                        Rectangle{
                            id: dashboard_rectangle_header1
                            height: screen.height - 50
                            width: dashboard_rectangle.width
                            color: "#031C28"
                            border.color: "#05324D"
                            border.width: 1
                            Text{
                                id: greet
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                text: "Hi "
                                color : "white"
                                font.pointSize:ScreenTools.defaultFontPointSize
                            }
                            Text{
                                id: username
                                text: database_access.name
                                color : "#F25822"
                                font.pointSize: ScreenTools.defaultFontPointSize * 1.1
                                font.bold: true
                                anchors.left: greet.right
                                anchors.top: parent.top
                                anchors.topMargin: 20
                            }
                            Timer {
                                id: profile_timer
                                interval: 50
                                onTriggered:{
                                    username.text               = database_access.name
                                    user_role.text              = database_access.role
                                    userprofile_name.text       = database_access.name
                                    mail_address.text           = database_access.mail
                                    mobile_number.text          = database_access.number
                                    address_field.text          = database_access.address
                                    locality_field.text         = database_access.locality
                                    user_name_inprofile.text    = database_access.name
                                    user_image_inprofile.source = rpadatabase.image
                                    profile_timer.stop()
                                }
                            }

                            Text{
                                id: greeting_text
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: greet.bottom
                                anchors.topMargin: 15
                                text: "Welcome back to <b>GoDrona<b>"
                                color : "white"
                                font.pointSize: 14
                            }
                            Text{
                                id: overview
                                text: "OVERVIEW"
                                color : "white"
                                font.pointSize:ScreenTools.smallFontPointSize * 1.2
                                font.bold: true
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: greeting_text.bottom
                                anchors.topMargin: 25

                            }

                            Row{
                                anchors.left: parent.left
                                anchors.leftMargin: 50
                                anchors.top: overview.bottom
                                anchors.topMargin: 25
                                Row {
                                    spacing: 75
                                    Rectangle {
                                        id:row_rectangle1
                                        color: "#4D05324D"
                                        width: mainWindow.height /4
                                        height: width
                                        radius: 2

                                        Rectangle {
                                            id:flight_log_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 18
                                            width: parent.width/1.4
                                            height: parent.height /1.6
                                            color: "Green"
                                            radius: 3
                                            Rectangle{
                                                id: inner_rect_11
                                                width: 120
                                                height: 120
                                                anchors.centerIn: parent
                                                color: "transparent"
                                                Image {
                                                    id: flight_log_image
                                                    anchors.fill: parent
                                                    source: "qrc:/res/Flight_log.png"

                                                }
                                                ColorOverlay{
                                                    anchors.fill: flight_log_image
                                                    source:flight_log_image
                                                    color: "white"
                                                }

                                            }

                                        }

                                        Text {
                                            id: flightlog
                                            text: qsTr("Drone Log")
                                            font.pointSize:ScreenTools.smallFontPointSize
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }

                                    }
                                    Rectangle {
                                        color: "#4D05324D"
                                        width: mainWindow.height /4
                                        height: width
                                        radius: 2

                                        Rectangle {
                                            id:customers_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 18
                                            width: parent.width/1.4
                                            height: parent.height /1.6
                                            color: "black"
                                            radius: 4
                                            Rectangle{
                                                id: inner_rect_2
                                                width: 120
                                                height: 120
                                                anchors.centerIn: parent
                                                color: "transparent"
                                                Image {
                                                    id: customersimage
                                                    anchors.fill: parent
                                                    source: "qrc:/qmlimages/customers_black.png"

                                                }
                                                ColorOverlay{
                                                    anchors.fill: customersimage
                                                    source:customersimage
                                                    color: "white"
                                                }

                                            }
                                        }

                                        Text {
                                            id: customers
                                            text: qsTr("Customers")
                                            font.pointSize: ScreenTools.smallFontPointSize
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }

                                    }

                                    Rectangle {
                                        color: "#4D05324D"
                                        width: mainWindow.height /4
                                        height: width
                                        radius: 2

                                        Rectangle {
                                            id:remote_pilots_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 18
                                            width: parent.width/1.4
                                            height: parent.height /1.6
                                            color: "red"
                                            radius: 4
                                            Rectangle{
                                                id: inner_rect_3
                                                width: 120
                                                height: 120
                                                anchors.centerIn: parent
                                                color: "transparent"
                                                Image {
                                                    id: remote_pilots_image
                                                    anchors.fill: parent
                                                    source: "qrc:/qmlimages/Remote_pilot.png"

                                                }
                                                ColorOverlay{
                                                    anchors.fill: remote_pilots_image
                                                    source:remote_pilots_image
                                                    color: "white"
                                                }

                                            }
                                        }

                                        Text {
                                            id: remote_pilot_text
                                            text: qsTr("Remote Pilots")
                                            font.pointSize:ScreenTools.smallFontPointSize
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                            }
                                        }

                                    }
                                    Rectangle {
                                        id: back_to_fly_rect
                                        width: mainWindow.height /4
                                        height: width
                                        radius: 2
                                        color: "#4D05324D"

                                        Rectangle{
                                            id:back_to_fly_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 18
                                            width: parent.width/1.4
                                            height: parent.height /1.6
                                            color: "Blue"
                                            radius: 4
                                            Rectangle{
                                                id: inner_rect_4
                                                width: 120
                                                height: 120
                                                anchors.centerIn: parent
                                                color: "transparent"
                                                Image {
                                                    id: back_to_fly_image
                                                    anchors.fill: parent
                                                    source: "qrc:/qmlimages/Back_to_fly.png"

                                                }
                                                ColorOverlay{
                                                    anchors.fill: back_to_fly_image
                                                    source:back_to_fly_image
                                                    color: "white"
                                                }
                                            }
                                        }
                                        Text {
                                            id: back_to_fly_text
                                            text: qsTr("Fly View")
                                            font.pointSize: ScreenTools.smallFontPointSize
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }
                                    }
                                }
                            }
                            //====have to put copyrights=====
                            Rectangle {
                                id: copyrights
                                anchors.bottom: dashboard_rectangle_header1.bottom
                                anchors.bottomMargin: 65
                                height: mainWindow.height/20
                                width: parent.width
                                color: "#05324D"

                                Text {
                                    anchors.centerIn: parent
                                    text: "@2023 Casca E-Connect Private Limited | All Rights Reserved"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    color: "White"
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: manage_rpa_rectangle
                    width: second_rectangle.width
                    color: "#031C28"
                    visible: false
                    border.color: "#05324D"
                    border.width: 1

                    Rectangle {
                        id:manage_rpa_header
                        color: "#031C28"
                        height: mainWindow.height/10
                        width: manage_rpa_rectangle.width
                        visible: true
                        border.color: "#05324D"
                        border.width: 2

                        Image {
                            id: hamburger_image_rpa
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: manage_rpa_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: managerpat_text
                            text: "MANAGE RPA"
                            color: "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_rpa.left
                            anchors.leftMargin: 35
                        }

                        Image {
                            id: search_image_rpa
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_rpa_header.right
                            anchors.rightMargin: 220
                        }
                        Text{
                            id: search_rpa
                            text: "Search"
                            color : "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_rpa_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.top: manage_rpa_header.bottom

                        Rectangle {
                            id:manage_rpa_header1
                            color: "#031C28"
                            visible:false || true
                            height: screen.height - 50
                            width: manage_rpa_rectangle.width
                            border.color: "#05324D"
                            border.width: 1

                            Text{
                                id: list_of_rpa_text
                                text: "LIST OF RPA"
                                color : "white"
                                font.pointSize: ScreenTools.smallFontPointSize
                                font.bold: true
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 25
                            }

                            Button {
                                id:flyview_button
                                anchors.right: manage_rpa_header1.right
                                anchors.rightMargin: 370
                                anchors.top: parent.top
                                anchors.topMargin: 20
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
                                    firmware_load1.mute_sound(1)
                                    if(checkBoxState === 0){
                                        select_the_modelDialog.open()
                                    }
                                    else if(checkBoxState === 1){
                                        QGroundControl.multiVehicleManager.vehicle_connect = true;
                                        rpadatabase.modelSelected(checkBoxNumber)

                                    }
                                    else{
                                    }
                                    flightView.visible             = true
                                    toolbar.visible                = true
                                    landing_page_rectangle.visible = false

                                }
                            }
                            MessageDialog{
                                id:select_the_modelDialog
                                title: "Model not Selected"
                                text: "you have to select the model before you fly."
                            }

                            Button {
                                id: register_rpa_button
                                anchors.right: manage_rpa_header1.right
                                anchors.rightMargin: 30
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                Text {
                                    anchors.centerIn: parent
                                    text: "Register RPA"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    color:"white"
                                    font.bold: true
                                }
                                background: Rectangle {
                                    id:register_rpa_button_rect
                                    implicitHeight: mainWindow.height/20
                                    implicitWidth:  mainWindow.width/8
                                    border.width: 1
                                    border.color: "#F25822"
                                    radius: 4
                                    color: "#F25822"
                                }
                                onPressed: {
                                    register_rpa_button_rect.color = "#05324D"
                                }
                                onReleased: {
                                    register_rpa_button_rect.color = "#F25822"
                                }
                                onClicked: {

                                    updateButton = 1
                                    manage_rpa_header1.visible    = false
                                    rpa_register_page.visible     = true
                                    drone_contents.visible        = true
                                    drone_type_list.currentIndex  = -1
                                    drone_model_list.currentIndex = -1
                                    drone_name_text.text          = ""
                                    uin_input_text.text           = ""
                                    uin_input_text.enabled        = true

                                }

                            }
                            Timer {
                                interval: 50; running: true; repeat: true
                                onTriggered:{

                                }
                            }

                            Rectangle {
                                id: table_rect
                                anchors.left: manage_rpa_header1.left
                                anchors.leftMargin: 20
                                anchors.top: list_of_rpa_text.bottom
                                anchors.topMargin: 30
                                width: manage_rpa_header1.width - 50
                                height: mainWindow.height - 320
                                color: "#031C28"
                                visible: true

                            }
                            Rectangle {
                                anchors.bottom: manage_rpa_header1.bottom
                                anchors.bottomMargin: 65
                                height: mainWindow.height/20
                                width: parent.width
                                color: "#05324D"

                                Text {
                                    anchors.centerIn: parent
                                    text: "@2023 Casca E-Connect Private Limited | All Rights Reserved"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    color: "White"
                                }
                            }
                        }
                    }
                    Rectangle{
                        id: rpa_register_page
                        color: "#031C28"
                        visible: false
                        height: screen.height - 50
                        width: manage_rpa_header1.width
                        border.color: "#05324D"
                        border.width: 2
                        anchors.left: parent.left
                        anchors.top: manage_rpa_header.bottom

                        Rectangle {
                            id: back_arrow_button
                            anchors.left: rpa_register_page.left
                            anchors.leftMargin: 20
                            anchors.top: rpa_register_page.top
                            anchors.topMargin: 20
                            width: 40
                            height: 40
                            color: "#031C28"

                            Image {
                                source: "/res/back_arrow.png"
                                anchors.centerIn: parent
                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: {
                                        back_arrow_button.color = "#F25822"
                                    }
                                    onReleased: {
                                        back_arrow_button.color = "#031C28"
                                    }
                                    onClicked : {
                                        rpa_register_page.visible     =  false
                                        manage_rpa_header1.visible    = true
                                        drone_type_list.currentIndex  = -1
                                        drone_model_list.currentIndex = -1
                                        drone_name_text.text          = ""
                                        uin_input_text.text           = ""
                                        uin_input_text.enabled        = true
                                    }
                                }
                            }
                        }

                        Text{
                            id: add_edit_rpa_text
                            text: "ADD / EDIT RPA"
                            color : "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.left: back_arrow_button.left
                            anchors.leftMargin: 40
                            anchors.top: parent.top
                            anchors.topMargin: 25
                        }

                        Rectangle {
                            id: drone_contents
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 80
                            width: parent.width - 50
                            height: parent.height /1.5
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
                                    height: mainWindow.height/9
                                    width: mainWindow.width/15
                                    radius: width/2
                                    color: "#031C28"
                                    Image {
                                        id:drone_image
                                        source: "qrc:/qmlimages/drone_1.png"
                                        anchors.fill: drone_image_container
                                        fillMode: Image.PreserveAspectCrop
                                        anchors.centerIn: parent
                                        layer.enabled: true
                                        layer.effect: OpacityMask {
                                            maskSource: drone_image_container
                                        }
                                    }
                                }

                                Column{
                                    spacing: 15
                                    Text {
                                        id: drone_image_text
                                        text: qsTr("Drone Image*")
                                        color: "White"
                                        font.pointSize: ScreenTools.smallFontPointSize
                                        anchors.left: drone_image_container.left
                                        anchors.leftMargin: 25
                                    }

                                    Button {
                                        id: browse_image_button
                                        height: mainWindow.height/18
                                        width: mainWindow.width/9
                                        anchors.left: drone_image_container.left
                                        anchors.leftMargin: 100

                                        contentItem :Text {
                                            anchors.centerIn: parent
                                            text: "Browse & Upload"
                                            color: "white"
                                            font.pointSize: ScreenTools.smallFontPointSize
                                        }
                                        background: Rectangle {
                                            anchors.centerIn: parent
                                            height: mainWindow.height/18
                                            width: mainWindow.width/9
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
                                    drone_image.source = fileUrl.toString()
                                }
                                onRejected: {
                                }
                            }

                            Text {
                                id: drone_type_text
                                anchors.left: drone_contents.left
                                anchors.leftMargin: 25
                                anchors.top: drone_contents.top
                                anchors.topMargin: 160
                                text: qsTr("Drone Type*")
                                color: "White"
                                font.pointSize: ScreenTools.smallFontPointSize
                            }

                            Rectangle {
                                id: drone_type_combo
                                height: mainWindow.height/18
                                width: mainWindow.width/7
                                anchors.left: drone_contents.left
                                anchors.leftMargin: 25
                                anchors.top: drone_type_text.top
                                anchors.topMargin: 40
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
                                    model:ListModel {
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
                                            font.pointSize: ScreenTools.smallFontPointSize
                                        }
                                        highlighted: drone_type_list.highlightedIndex === index
                                    }

                                    indicator: Canvas {
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
                                            context.fillStyle = "white";
                                            context.fill();
                                        }
                                    }

                                    contentItem: Text {
                                        id: combo_box1
                                        text: drone_type_list.displayText
                                        color: "white"
                                        font.pointSize: ScreenTools.smallFontPointSize
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        height: mainWindow.height/18
                                        width: mainWindow.width/11
                                        color: "#031C28"
                                        visible:false
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
                                anchors.rightMargin: 45
                                anchors.top: drone_contents.top
                                anchors.topMargin: 160
                                text: qsTr("Name/Drone's Model Name*")
                                color: "White"
                                font.pointSize: ScreenTools.smallFontPointSize
                            }

                            Rectangle {
                                id: drone_model_combo
                                height: mainWindow.height/18
                                width: mainWindow.width/7
                                anchors.right: drone_contents.right
                                anchors.rightMargin: 125
                                anchors.top: drone_model_text.top
                                anchors.topMargin: 40
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
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    model: ListModel {
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
                                            font.pointSize: ScreenTools.smallFontPointSize
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
                                        id: combo_box2
                                        text: drone_model_list.displayText
                                        color: "white"
                                        font.pointSize: ScreenTools.smallFontPointSize
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        height: mainWindow.height/18
                                        width: mainWindow.width/11
                                        color: "#031C28"
                                        visible: false
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
                                anchors.topMargin: 90
                                height: 40
                                width: drone_contents.width - 35
                                color: "#031C28"
                                radius: 4

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5
                                    text: qsTr ("RPA INFORMATIONS")
                                    color: "white"
                                    font.pointSize:ScreenTools.smallFontPointSize
                                }
                            }

                            Text {
                                id:basic_details_text
                                anchors.left: drone_contents.left
                                anchors.leftMargin: 25
                                anchors.top: drone_type_combo.top
                                anchors.topMargin: 160
                                text: qsTr("Basic Details")
                                font.bold: true
                                font.pointSize:ScreenTools.smallFontPointSize
                                color: "white"
                            }

                            Text {
                                id: drone_name_input
                                anchors.left: drone_contents.left
                                anchors.leftMargin: 25
                                anchors.top: basic_details_text.top
                                anchors.topMargin: 60
                                text: qsTr("Drone Name*")
                                font.pointSize:ScreenTools.smallFontPointSize
                                color: "white"
                            }

                            Rectangle {
                                id:drone_name_input_rect
                                anchors.left: drone_contents.left
                                anchors.leftMargin: 25
                                anchors.top: drone_name_input.top
                                anchors.topMargin:40
                                height: mainWindow.height/18
                                width: mainWindow.width/7
                                radius: 4

                                TextField{
                                    id:drone_name_text
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.margins: 5
                                    text: ''
                                    font.pointSize:ScreenTools.smallFontPointSize
                                    color: "white"
                                    selectByMouse: true
                                    Keys.onReturnPressed: {
                                        uin_input_text.forceActiveFocus()
                                    }
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
                                anchors.rightMargin: 380
                                anchors.top: rpa_text.top
                                anchors.topMargin: 120
                                text: qsTr("UIN*")
                                font.pointSize:ScreenTools.smallFontPointSize
                                color: "white"
                            }

                            Rectangle {
                                id:uin_input_rect
                                anchors.right: drone_contents.right
                                anchors.rightMargin: 120
                                anchors.top: uin_input.top
                                anchors.topMargin: 40
                                height: mainWindow.height/18
                                width: mainWindow.width/7
                                color: "#031C28"

                                TextField {
                                    id:uin_input_text
                                    enabled: editUin ? true : false
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.margins: 5
                                    text: ""
                                    font.pointSize:ScreenTools.smallFontPointSize
                                    color: "white"
                                    selectByMouse: true
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
                            anchors.left: drone_contents.left
                            anchors.leftMargin: parent.width/3.5
                            anchors.bottom: drone_contents.bottom
                            anchors.bottomMargin: 30
                            Button {
                                Text {
                                    anchors.centerIn: parent
                                    text: "Update"
                                    color:"white"
                                    font.pointSize:ScreenTools.smallFontPointSize
                                }
                                background: Rectangle {
                                    id:update_Button
                                    implicitWidth: mainWindow.width/9
                                    implicitHeight: mainWindow.height/18
                                    radius: 4
                                    color: "Green"
                                    border.width: 1
                                    border.color: "#F25822"
                                }
                                onPressed: {
                                    update_Button.color = "#05324D"
                                }
                                onReleased: {
                                    update_Button.color = "Green"
                                }
                                onClicked: {
                                    if(updateButton === 1){
                                        if((combo_box1.text === "")||(combo_box2.text === "") ||(drone_name_text.text == "") ||(uin_input_text.text == "")) {
                                            fillDialog.visible = true
                                        }
                                        else{
                                            rpadatabase.existingUIN(database_access.mail,uin_input_text.text)
                                        }
                                    }
                                    else if(updateButton == 2){
                                        rpa_register_page.visible     = false
                                        manage_rpa_header1.visible    = true
                                        tableDialog.visible           = true
                                        drone_type_list.currentIndex  = -1
                                        drone_model_list.currentIndex = -1
                                        drone_name_text.text          = ""
                                        uin_input_text.text           = ""
                                        uin_input_text.enabled        = true
                                        updateButton                  = 1
                                    }


                                }
                            }

                            Button {
                                Text {
                                    anchors.centerIn: parent
                                    text: "Cancel"
                                    color:"white"
                                    font.pointSize:ScreenTools.smallFontPointSize
                                }

                                background: Rectangle {
                                    id: cancel_Button
                                    implicitWidth: mainWindow.width/9
                                    implicitHeight: mainWindow.height/18
                                    radius: 4
                                    color: "red"
                                    border.width: 1
                                    border.color: "#F25822"
                                }
                                onPressed: {
                                    cancel_Button.color = "#05324D"
                                }
                                onReleased: {
                                    cancel_Button.color = "red"
                                }
                                onClicked:{
                                    manage_rpa_header1.visible    = true
                                    rpa_register_page.visible     = false
                                    drone_type_list.currentIndex  = -1
                                    drone_model_list.currentIndex = -1
                                    drone_name_text.text          = ""
                                    uin_input_text.text           = ""
                                    uin_input_text.enabled        = true
                                }
                            }
                        }
                        Rectangle {
                            anchors.bottom: rpa_register_page.bottom
                            anchors.bottomMargin: 65
                            height: mainWindow.height/20
                            width: parent.width
                            color: "#05324D"

                            Text {
                                anchors.centerIn: parent
                                text: "@2023 Casca E-Connect Private Limited | All Rights Reserved"
                                font.pointSize:ScreenTools.smallFontPointSize
                                color: "White"
                            }
                        }
                    }
                    MessageDialog {
                        id: profilePicUpdated_Dialog
                        text: "Profile Picture Updated Successfully";
                    }

                    MessageDialog{
                        id:fillDialog
                        text:"please fill the details correctly"
                    }

                    MessageDialog{
                        id:tableDialog
                        text:"Updated Successfully."
                    }

                    MessageDialog{
                        id:deleteDialog
                        text:"Row Deleted Successfully."
                    }

                }


                Rectangle {
                    id: flight_log_rectangle
                    width: second_rectangle.width
                    height: parent.height
                    color: "#031C28"
                    visible: false
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id:flight_log_header
                        color: "#031C28"
                        height: mainWindow.height/10
                        width: flight_log_rectangle.width
                        visible: true
                        border.color: "#05324D"
                        border.width: 2

                        Image {
                            id: hamburger_image_flight_log
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: flight_log_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: flight_log_text
                            text: "FLIGHT LOG"
                            color: "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_flight_log.left
                            anchors.leftMargin: 35
                        }

                        Image {
                            id: search_image_flight_log
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: flight_log_header.right
                            anchors.rightMargin: 220
                        }
                        Text{
                            id: search_flight_log
                            text: "Search"
                            color : "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: flight_log_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column{
                        anchors.left: parent.left
                        anchors.top: flight_log_header.bottom

                        Rectangle {
                            id:flightlog_header1
                            color: "#031C28"
                            visible:false || true
                            height: screen.height-50
                            width: flight_log_rectangle.width
                            border.color: "#05324D"
                            border.width: 1
                            Timer {
                                interval: 10; running: true; repeat: true
                                onTriggered:{
                                    folder_list_model.model = rpadatabase.filename
                                }
                            }

                            ListView {
                                id: folder_list_model
                                anchors.fill: parent
                                anchors.top: parent.top
                                anchors.topMargin: 50
                                model: rpadatabase.filename
                                delegate: RowLayout {
                                    id: rowLayout
                                    width: parent.width
                                    height: 80

                                    CheckBox {
                                        id: log_checkBox
                                        Layout.alignment: Qt.AlignVCenter
                                        indicator: Rectangle{
                                            implicitWidth: 30
                                            implicitHeight: 30
                                            radius: 2
                                            color: "#031C28"
                                            border.width:0.5
                                            border.color: "#F25822"
                                            anchors.centerIn: parent

                                            Rectangle {
                                                visible: log_checkBox.checked
                                                color: "#F25822"
                                                radius: 1
                                                anchors.margins: 2
                                                anchors.fill: parent
                                            }
                                        }
                                    }

                                    Text {
                                        id: fileNameText
                                        text: modelData
                                        color: "white"
                                        font.pointSize: ScreenTools.smallFontPointSize
                                        Layout.alignment: Qt.AlignVCenter
                                    }


                                    Button {
                                        id: downloadButton
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Download"
                                            color:"white"
                                            font.pointSize: ScreenTools.smallFontPointSize
                                        }
                                        background: Rectangle {
                                            id:log_download_button
                                            implicitHeight: mainWindow.height/20
                                            implicitWidth:  mainWindow.width/10
                                            border.width: 1
                                            border.color: "#F25822"
                                            radius: 4
                                            color: enabled ? "#F25822" : "#DA2C43"
                                        }
                                        enabled: log_checkBox.checked

                                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                                        onPressed: {
                                            log_download_button.color = "#05324D"
                                        }
                                        onReleased: {
                                            log_download_button.color = "#F25822"
                                        }

                                        onClicked: {
                                            rpadatabase.download_function(modelData,database_access.mail,QGroundControl.settingsManager.appSettings.telemetrySavePath);
                                            log_download_button.color = "#DA2C43"
                                            log_checkBox.checked = false
                                            fileDownloaded_Dialog.open()
                                        }
                                        MessageDialog{
                                            id: fileDownloaded_Dialog
                                            text: "File Download Completed."
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                anchors.bottom: flightlog_header1.bottom
                                anchors.bottomMargin: 65
                                height: mainWindow.height/20
                                width: parent.width
                                color: "#05324D"

                                Text {
                                    anchors.centerIn: parent
                                    text: "@2023 Casca E-Connect Private Limited | All Rights Reserved"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    color: "White"
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    id: firmware_log_rectangle
                    width: second_rectangle.width
                    height: parent.height
                    anchors.fill: parent
                    color: "#031C28"
                    visible: false
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id:firmware_log_header
                        color: "#031C28"
                        height: mainWindow.height/10
                        width: firmware_log_rectangle.width
                        visible: true
                        border.color: "#05324D"
                        border.width: 2

                        Image {
                            id: hamburger_image_firmware_log
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: firmware_log_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: firmware_log_text
                            text: "FIRMWARE LOG"
                            color: "white"
                            font.pointSize: ScreenTools.smallFontPointSize
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_firmware_log.left
                            anchors.leftMargin: 35
                        }

                        Image {
                            id: search_image_firmware_log
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: firmware_log_header.right
                            anchors.rightMargin: 220
                        }
                        Text{
                            id: search_firmware_log
                            text: "Search"
                            color : "white"
                            font.bold: true
                            font.pointSize:ScreenTools.smallFontPointSize
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: firmware_log_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column{
                        anchors.left: parent.left
                        anchors.top: firmware_log_header.bottom

                        Rectangle {
                            id:firmware_log_header1
                            color: "#031C28"
                            visible:false || true
                            height: screen.height-50
                            width: firmware_log_rectangle.width
                            border.color: "#05324D"
                            border.width: 1
                            Timer {
                                interval: 50; running: true; repeat: true
                                onTriggered:{
                                    firmware_list_model.model = rpadatabase.firmwarelog_list
                                }
                            }

                            ListView {
                                id: firmware_list_model
                                anchors.fill: parent
                                anchors.top: parent.top
                                anchors.topMargin: 30
                                model: rpadatabase.firmwarelog_list
                                delegate: RowLayout {
                                    Text {
                                        id: firmware_info_Text
                                        text: modelData
                                        color: "white"
                                        font.pointSize: ScreenTools.smallFontPointSize
                                        Layout.alignment: Qt.AlignLeft
                                        Layout.margins: 40
                                    }
                                }
                            }
                            Rectangle {
                                anchors.bottom: firmware_log_header1.bottom
                                anchors.bottomMargin: 65
                                height: mainWindow.height/20
                                width: parent.width
                                color: "#05324D"

                                Text {
                                    anchors.centerIn: parent
                                    text: "@2023 Casca E-Connect Private Limited | All Rights Reserved"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    color: "White"
                                }
                            }
                        }
                    }
                }
            }

            Rectangle{
                id:third_rectangle
                Layout.fillWidth: true
                Layout.preferredHeight: mainWindow.height
                color: "#031C28"
                border.color: "#05324D"
                border.width: 1

                Rectangle {
                    id: users_profile_rectangle
                    width: third_rectangle.width
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle{
                        id: users_profile_header
                        color: "#031C28"
                        height: mainWindow.height/10
                        width: users_profile_rectangle.width
                        border.color: "#05324D"
                        border.width: 2

                        Rectangle{
                            id: bell_button
                            anchors.left: users_profile_header.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            height: 40
                            width: 40
                            radius: 20
                            color: "#05324D"

                            Image {
                                id: bell_image
                                source:"/res/bell.png"
                                anchors.centerIn: parent
                            }
                            ColorOverlay{
                                anchors.fill: bell_image
                                source: bell_image
                                color:"white"
                            }
                            MouseArea{
                                anchors.fill: bell_button
                                onClicked:{

                                }
                                onPressed: {
                                    bell_button.color = "#F25822"
                                }
                                onReleased: {
                                    bell_button.color = "#05324D"
                                }
                            }
                        }

                        Rectangle {
                            id: mail_button
                            anchors.left: bell_button.right
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            height: 40
                            width: 40
                            radius: 20
                            color: "#05324D"

                            Image {
                                id: mail_image
                                source:"/res/mail.png"
                                anchors.centerIn: parent
                            }
                            ColorOverlay{
                                anchors.fill: mail_image
                                source: mail_image
                                color:"white"
                            }
                            MouseArea{
                                anchors.fill: mail_button
                                onClicked:{

                                }
                                onPressed: {
                                    mail_button.color = "#F25822"
                                }
                                onReleased: {
                                    mail_button.color = "#05324D"
                                }
                            }
                        }
                        Rectangle {
                            id: image_rect
                            anchors.right: users_profile_header.right
                            anchors.rightMargin: third_rectangle.width/2
                            anchors.verticalCenter: parent.verticalCenter
                            height: 60
                            width: 60
                            clip:true
                            radius: width/2
                            color: "#05324D"
                            border.width: 1
                            border.color: "#F25822"

                            Image {
                                id: user_image_inprofile
                                source:rpadatabase.image
                                anchors.fill: image_rect
                                fillMode: Image.PreserveAspectCrop
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: image_rect
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    image_update_dialog.open()
                                }
                            }

                        }
                        FileDialog {
                            id:image_update_dialog
                            title: "Please choose an image"
                            folder: shortcuts.documents
                            nameFilters: [ "(*.jpg)"]
                            selectMultiple: false
                            onAccepted: {
                                user_profile_image.visible = true
                                var filePath = fileUrl.toString().replace("file://", "")
                                image_upload = filePath;
                                rpadatabase.upload_function("user_profile.jpg",database_access.storagename, image_upload)
                                user_image_inprofile.source = image_update_dialog.fileUrl
                                profilePicUpdated_Dialog.open()
                            }
                        }
                        Column {
                            spacing: 5
                            anchors.left: image_rect.right
                            anchors.leftMargin: 10
                            anchors.top: users_profile_header.top
                            anchors.topMargin: 9

                            Text {
                                id: user_name_inprofile
                                wrapMode: Text.WordWrap
                                text: qsTr(database_access.name)
                                color:"white"
                                font.pointSize: ScreenTools.smallFontPointSize

                            }
                            Text {
                                id: user_role
                                text: database_access.role
                                color: "#F25822"
                                font.pointSize: ScreenTools.smallFontPointSize

                            }

                        }
                    }
                    Rectangle {
                        id: users_profile_header1
                        anchors.top: users_profile_header.bottom
                        height: screen.height - 50
                        width: users_profile_rectangle.width
                        visible: true || false
                        color: "#031C28"
                        border.width: 1
                        border.color: "#05324D"

                        Column{
                            spacing: 30
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 25
                            Text {
                                text : "Subscription"
                                color: "white"
                                font.bold: true
                                font.pointSize: ScreenTools.smallFontPointSize
                            }

                            Rectangle {
                                height: 100
                                width: third_rectangle.width -50
                                color: "#031C28"
                                border.width: 1
                                border.color: "cyan"

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.top: parent.top
                                    anchors.topMargin: 10
                                    text: "Your Current Active Plan is"
                                    wrapMode: Text.WordWrap
                                    color: "#ffffff"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: users_information_header1
                        anchors.top: users_profile_header.bottom
                        height: screen.height - 50
                        width: users_profile_rectangle.width
                        visible: false
                        color: "#031C28"
                        border.width: 1
                        border.color: "#05324D"

                        Column{
                            spacing: 15
                            anchors.left: users_information_header1.left
                            anchors.leftMargin: 20
                            anchors.top: users_information_header1.top
                            anchors.topMargin: 20
                            Column{
                                spacing:5
                                Text{
                                    text: "Name"
                                    color: "white"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    font.bold: true
                                }
                                TextField{
                                    id: userprofile_name
                                    readOnly: true
                                    width: third_rectangle.width -50
                                    height:  mainWindow.height/18
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Name")
                                    text: database_access.name
                                    color:"white"
                                    font.pointSize:     ScreenTools.smallFontPointSize
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: userprofile_name.height
                                        implicitWidth: userprofile_name.width
                                    }
                                }
                            }
                            Column{
                                spacing:5
                                Text{
                                    text: "Mail Address"
                                    color: "white"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    font.bold: true
                                }
                                TextField{
                                    id: mail_address
                                    width: third_rectangle.width -50
                                    height: mainWindow.height/18
                                    anchors.margins: 5
                                    placeholderText: qsTr("user@gmail.com")
                                    text: database_access.mail
                                    color:"white"
                                    readOnly: true
                                    font.pointSize:     ScreenTools.smallFontPointSize
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: mail_address.height
                                        implicitWidth: mail_address.width
                                    }
                                }
                            }
                            Column{
                                spacing:8
                                Text{
                                    text: "Mobile number"
                                    color: "white"
                                    font.pointSize:     ScreenTools.smallFontPointSize
                                    font.bold: true
                                }
                                TextField{
                                    id: mobile_number
                                    readOnly: true
                                    width: third_rectangle.width -50
                                    height: mainWindow.height/18
                                    anchors.margins: 5
                                    text: database_access.number
                                    color:"white"
                                    font.pointSize:     ScreenTools.smallFontPointSize
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: mobile_number.height
                                        implicitWidth: mobile_number.width
                                    }
                                }
                            }
                            Column{
                                spacing:5
                                Text{
                                    text: "Address"
                                    color: "white"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    font.bold: true
                                }
                                TextField{
                                    id: address_field
                                    width: third_rectangle.width -50
                                    height: mainWindow.height/18
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Address")
                                    text: database_access.address
                                    color:"white"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    Keys.onReturnPressed: {
                                        locality_field.forceActiveFocus()
                                    }
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: address_field.height
                                        implicitWidth: address_field.width
                                    }
                                }
                            }
                            Column{
                                spacing:5
                                Text{
                                    text: "Locality"
                                    color: "white"
                                    font.pointSize: ScreenTools.smallFontPointSize
                                    font.bold: true
                                }
                                TextField{
                                    id: locality_field
                                    width: third_rectangle.width -50
                                    height: mainWindow.height/18
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Locality")
                                    text: database_access.locality
                                    color:"white"
                                    font.pointSize:     ScreenTools.smallFontPointSize
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: locality_field.height
                                        implicitWidth: locality_field.width
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: update_profile
                            height: mainWindow.height/20
                            width: mainWindow.width/14
                            anchors.right: users_information_header1.right
                            anchors.rightMargin: 220
                            anchors.bottom: users_information_header1.bottom
                            anchors.bottomMargin: 220
                            color: "#05324D"
                            radius: 4
                            border.width: 1
                            border.color: "#F25822"

                            Text {
                                text:"Update"
                                color: "white"
                                font.pointSize:ScreenTools.smallFontPointSize
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: update_profile
                                onClicked: {
                                    if(userprofile_name.text == "" || mail_address.text == "" || locality_field.text == "" || address_field.text == ""){
                                        popupDialog.open()
                                    }
                                    else {
                                        database_access.update_profile(userprofile_name.text,mail_address.text,mobile_number.text,address_field.text,locality_field.text)
                                        users_profile_header1.visible = true
                                        users_information_header1.visible = false
                                        profileDialog.open()
                                        userprofile_name = database_access.name
                                        mail_address.text = database_access.mail
                                        mobile_number.text = database_access.number
                                        address_field.text = database_access.address
                                        locality_field.text = database_access.locality
                                        address_field.activeFocus = false
                                        locality_field.activeFocus = false
                                    }
                                }
                                onPressed: {
                                    update_profile.color = "#F25822"
                                }
                                onReleased: {
                                    update_profile.color = "#05324D"
                                }
                            }
                        }
                        MessageDialog{
                            id: popupDialog
                            text:"Please Fill all the Details"
                        }

                        Rectangle {
                            id: back_to_profile
                            height: mainWindow.height/20
                            width: mainWindow.width/14
                            anchors.left: update_profile.right
                            anchors.leftMargin: 20
                            anchors.bottom: users_information_header1.bottom
                            anchors.bottomMargin: 220
                            color: "#05324D"
                            radius: 4
                            border.width: 1
                            border.color: "#F25822"

                            Text {
                                text:"Back"
                                color: "white"
                                font.pointSize:ScreenTools.smallFontPointSize
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: back_to_profile
                                onClicked: {
                                    users_profile_header1.visible = true
                                    users_information_header1.visible = false
                                }
                                onPressed: {
                                    back_to_profile.color = "#F25822"
                                }
                                onReleased: {
                                    back_to_profile.color = "#05324D"
                                }
                            }
                        }
                        MessageDialog{
                            id:profileDialog
                            text:"Profile Updated Successfully."
                        }
                    }
                }
            }
        }
    }
}
