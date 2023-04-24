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

import AjayDatabase 1.0
import RpaDatabase 1.0
import AWSOperations 1.0

/// @brief Native QML top level window
/// All properties defined here are visible to all QML pages.
ApplicationWindow {
    id:             mainWindow
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true

    property int updateButton: 1
    property bool editUin: true
    property int number: 0
    property real rectangleWidth: (table_rect.width - 40) / 5

    AWSOperations{
        id: aws
    }

    AjayDatabase{
        id: database
        /*onConnection_not_established: {
            connection_not_established_dialog.open()
            first_rectangle.visible = false
            second_rectangle.visile = false
            third_rectangle.visible = false
            landing_page_rectangle.visible =false
            dashboard_rectangle.visible = false
            users_profile_header1.visible = false
            manage_rpa_rectangle.visible = false
            flight_log_rectangle.visible = false
            users_information_header1.visible = false
            rpa_register_page.visible = false
        }*/

        onRecord_found: {
            console.log(rectangleWidth)
            landing_page_rectangle.visible =true
            dashboard_rectangle.visible = true
            login_page_rectangle.z = -1
            login_page_rectangle.visible = false
            //rpadatabase.callSql("SELECT * From RpaList")
            rpadatabase.callSql("select * from RpaList limit 5")
            landing_page_rectangle.visible =true
            dashboard_rectangle.visible = true
            users_profile_header1.visible = true
            manage_rpa_rectangle.visible = false
            flight_log_rectangle.visible = false
            users_information_header1.visible = false
            rpa_register_page.visible = false
            dashboard_button.color = "#F25822"
            managerpa_button.color = "#031C28"
            flight_log_button.color = "#031C28"
            logout_button.color = "#031C28"
        }
        onNo_record_found: {
            no_recordDialog.open()
        }
        onIncorrect_password: {
            incorrect_password_Dialog.open()
        }
        onName_record_found: {
            namerecord_Dialog.open()
            //namerecord_Dialog.visible = true
            //console.log("record found")
        }
        onMail_record_found: {
            mailrecord_Dialog.open()
        }
        onNumber_record_found: {
            number_record_Dialog.open()
        }
        onClose_database: {
            landing_page_rectangle.visible = false
            login_page_rectangle.visible = true
            login_page_email_textfield.text = ""
            login_page_password_textfield.text = ""
            updateButton = 1
        }
        onConnectionNotopened: {
            connectionLostdialog.open()
        }
        onForgotmail_record_notfound: {
            mailrecord_not_found.open()
        }

    }

    RpaDatabase {
        id:rpadatabase

        onUin_record_found: {
            uinrecord_Dialog.open()
        }

        onUin_record_notfound: {
            rpa_register_page.visible =  false
            manage_rpa_header1.visible = true
            rpadatabase.addData(drone_type_list.currentText,drone_model_list.currentText,drone_name_text.text,uin_input_text.text)
            rpadatabase.callSql("select * from RpaList limit 5")
            drone_type_list.currentIndex = -1
            drone_model_list.currentIndex = -1
            drone_name_text.text = ""
            uin_input_text.text = ""
            uin_input_text.enabled = true
            check_box.checked = false
            check_box1.checked = false
            check_box2.checked = false
            check_box3.checked = false
            check_box4.checked = false
        }
    }

    function showPanel(button, qmlSource) {
        if (mainWindow.preventViewSwitch()) {
            return
        }
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
            source: "/res/godrona-logo.png"//"qrc:/../../../../Downloads/godrona-logo.png"
        }
        Column{
            id: login_page_label
            spacing: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: login_page_godrona_image.bottom
            anchors.topMargin: 60
            Label{
                text: "LOGIN/SIGN-IN ACCOUNT"
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
                placeholderText: qsTr("example@gmail.com")
                inputMethodHints: Qt.ImhEmailCharactersOnly
                validator: RegExpValidator{regExp: /.+/}
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
                width: 300
                height: 35
                text: ""
                color: "white"
                placeholderText: qsTr("Password")
                leftPadding: 50
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
                    width: 23
                    height: 23
                    fillMode: Image.PreserveAspectFit
                    source: "/res/password.png"//"qrc:/../../../../Downloads/password.png"
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }
                Image {
                    id: password_hide_image
                    width: 25
                    height: 25
                    fillMode: Image.PreserveAspectFit
                    source: "/res/password_hide.png"//"qrc:/../../../../Downloads/password_hide.png"
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
                    source: "/res/password_show.png"//"qrc:/../../../../Downloads/password_show.png"
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
            MessageDialog{
                id:messagedialog1
                height: 50
                width: 50
                text:"please enter your details correctly"
            }
            onPressed: {
                login_button.color = "#05324D"
            }
            onReleased: {
                login_button.color = "#F25822"
            }
            onClicked: {
                if (login_page_email_textfield.text !== "" && login_page_password_textfield.text !== "") {
                    console.log("Username: " + login_page_email_textfield.text)
                    console.log("Password: " + login_page_password_textfield.text)
                    database.loginExistingUser(login_page_email_textfield.text,login_page_password_textfield.text)
                } else {
                    messagedialog1.visible = true
                    console.log("Please enter a username and password.")
                }
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
                    source: "/res/new_member.png" //"qrc:/../../../../Downloads/new_member.png"

                }
                MouseArea{
                    anchors.fill: new_user_logo
                    onClicked: {
                        password_hide_image.visible = true
                        password_show_image.visible = false
                        new_user_first_page.visible = true
                        first_user_details_page.visible = true
                        login_page_email_textfield.text = ""
                        login_page_password_textfield.text = ""
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
                color: "white"
                Image{
                    id: forgot_password_logo
                    anchors.bottom: parent.top
                    width: 50
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/res/forgotpassword.png" //"qrc:/../../../../Downloads/forgotpassword.png"
                }
                MouseArea{
                    anchors.fill: forgot_password_logo
                    onClicked: {
                        password_hide_image.visible = true
                        password_show_image.visible = false
                        login_page_rectangle.visible = false
                        forgot_password_page_rectangle.visible = true
                        login_page_email_textfield.text = ""
                        login_page_password_textfield.text = ""
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
                    forgot_password_mail_text.text = ""
                    password_hide_image.visible = true
                    password_show_image.visible = false
                    login_page_password_textfield.echoMode = TextInput.Password
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
                    placeholderText: qsTr("example@gmail.com")
                    inputMethodHints: Qt.ImhEmailCharactersOnly
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
                        source: "/res/mailLogo.png"//"qrc:/../../../../Downloads/mailLogo.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    onEditingFinished : {
                        database.forgotPasswordmail(forgot_password_mail_text.text)
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

                    if(forgot_password_mail_text.text !== database.mail){
                        database.forgotPasswordmail(forgot_password_mail_text.text)
                        console.log("mail is not found")
                        //forgot_password_mail_text.text = ""
                    }
                    else {
                        forgot_password_page_rectangle.visible = false
                        reset_password_page_rectangle.visible = true
                        console.log("Mail is found")
                        //forgot_password_mail_text.text = ""
                    }
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
            source: "/res/backtologin-removebg-preview.png"//"qrc:/../../../../Downloads/backtologin-removebg-preview.png"
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
                    user_name_text.text = ""
                    user_mail_text.text = ""
                    user_number_text.text = ""
                    user_address_text.text = ""
                    user_locality_text.text = ""
                    user_password_text.text = ""
                    forgot_password_mail_text.text =""
                    password_show_image.visible = false
                    password_hide_image.visible = true
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
                    reset_password_page_rectangle.visible = false
                    forgot_password_page_rectangle.visible = true
                    new_password_hide_image.visible = true
                    new_password_show_image.visible = false
                    confirm_password_hide_image.visible = true
                    confirm_password_show_image.visible = false
                    password_hide_image.visible = true
                    password_show_image.visible = false
                    new_password_textfield.echoMode = TextInput.Password
                    confirm_password_textfield.echoMode = TextInput.Password
                    new_password_textfield.text = ""
                    confirm_password_textfield.text = ""
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
                        width: 23
                        height: 23
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password.png"//"qrc:/../../../../Downloads/password.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: new_password_hide_image
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_hide.png"//"qrc:/../../../../Downloads/password_hide.png"
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
                        source: "/res/password_show.png"//"qrc:/../../../../Downloads/password_show.png"
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
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                        source: "/res/password_hide.png"//"qrc:/../../../../Downloads/password_hide.png"
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
                        source: "/res/password_show.png"//"qrc:/../../../../Downloads/password_show.png"
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
                       console.log("mismatch")
                        password_mismatch.open()
                        new_password_textfield.text = ""
                        confirm_password_textfield.text = ""
                    }
                    else{
                        console.log("matched")
                        database.change_password(forgot_password_mail_text.text,new_password_textfield.text)
                        password_updated.open()
                        reset_password_page_rectangle.visible = false
                        login_page_rectangle.visible = true
                        new_password_hide_image.visible = true
                        new_password_show_image.visible = false
                        new_password_textfield.echoMode = TextInput.Password
                        confirm_password_textfield.echoMode = TextInput.Password
                        confirm_password_hide_image.visible =true
                        confirm_password_show_image.visible = false
                        new_password_textfield.text = ""
                        confirm_password_textfield.text = ""
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
                    user_name_text.text = ""
                    user_mail_text.text = ""
                    user_number_text.text = ""
                    user_address_text.text = ""
                    user_locality_text.text = ""
                    user_password_text.text = ""
                    control.currentIndex = -1
                    password_hide_image.visible = true
                    password_show_image.visible = false
                    password_show_image1.visible = false
                    password_hide_image1.visible = true
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
                    text: "Select Your Industry Type*"
                    color: "white"
                }
                ComboBox {
                    id: control
                    model: ["Drone Education & Training","Asset Inspection","Security & Surveillance","Public Survey","Oil & Gas Inspection","Industrial Inspection","Agricultural Usage","Goods Delivery"]
                    width: 200
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
//                        onTextChanged: {
//                            if(combobox_text.text == "Drone Education & Training"){
//                                organization_image.visible = true
//                            }
//                            else{
//                                organization_image.visible = false
//                            }
//                        }
                        Image{
                            id: organization_image
                            width: 25
                            height: 25
                            anchors.verticalCenter: parent.verticalCenter
                            source: "/res/organization.png"//"qrc:/../../../../Downloads/organization.png"
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
                        control.currentIndex = -1
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
                clip: true
                anchors.horizontalCenter: parent.horizontalCenter
                Image{
                    width: 25
                    height: 25
                    anchors.left: user_image.left
                    anchors.leftMargin: user_image.radius + 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/res/user_photo.png"//"qrc:/../../../../Downloads/user_photo.png"
                }
                Image{
                    id:user_profile_image
                    anchors.fill: user_image
                    width: 75
                    height: 75
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
                                    placeholderText: qsTr("Your Name")
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
                                        source: "/res/user_image.png"//"qrc:/../../../../Downloads/user_image.png"
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    onEditingFinished:{
                                        if (user_name_text.text !== "") {
                                            database.signupExistingUsername(user_name_text.text)
                                        }
                                        //database.signupExistingUsername(user_name_text.text)
                                        //namerecord_Dialog.open()

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
                                    placeholderText: qsTr("example@gmail.com")
                                    inputMethodHints: Qt.ImhEmailCharactersOnly
                                    //validator: RegExpValidator{regExp:/[A-Z0-9a-z._-]{1,}@(\\w+)(\\.(\\w+))(\\.(\\w+))?(\\.(\\w+))?$"*/}
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
                                        source: "/res/mailLogo.png"//"qrc:/../../../../Downloads/mailLogo.png"
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    onEditingFinished:{
                                        if (user_mail_text.text !== "") {
                                            database.signupExistingUsermail(user_mail_text.text)
                                        }
                                        //database.signupExistingUsermail(user_mail_text.text)
                                        //mailrecord_Dialog.open()
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
                                    maximumLength: 10
                                    placeholderText: qsTr("Your Mobile Number")
                                    leftPadding: 70
                                    validator: RegExpValidator{regExp: /[0-9,/]*/}
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
                                        id:image
                                        width: 25
                                        height: 25
                                        fillMode: Image.PreserveAspectFit
                                        source: "/res/user_phone.png"//"qrc:/../../../../Downloads/user_phone.png"
                                        anchors.left: parent.left
                                        anchors.leftMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Label {
                                        anchors.left: image.right
                                        anchors.leftMargin:3
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "+91"
                                        color: "white"
                                    }
                                    onEditingFinished:{
                                        console.log("Edit Finished")
                                        if(user_number_text.text.length < user_number_text.maximumLength && user_number_text.text.length >= 1){
                                            console.log(user_number_text.text.length + " mobile number length")
                                            wrong_numberDialog.open()
                                        }
                                        if (user_number_text.text !== "") {
                                            database.signupExistingUsernumber(user_number_text.text)
                                        }
                                    }
                                }
                            }
                            Dialog {
                                id: wrong_numberDialog
                                width: 200
                                height: 100
                                title: "Not a Valid Number"
                                Label {
                                    text: "Please provide a Valid Mobile Number"
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
                                    placeholderText: qsTr("Your Address")
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
                                        source: "/res/user_location.png"//"qrc:/../../../../Downloads/user_location.png"
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
                                    placeholderText: qsTr("Your Locality")
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
                                        source: "/res/user_locality.png"//"qrc:/../../../../Downloads/user_locality.png"
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
                                    placeholderText: qsTr("password")
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
                                        source: "/res/password.png"//"qrc:/../../../../Downloads/password.png"
                                        anchors.left: parent.left
                                        anchors.leftMargin: 8
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    Image {
                                        id: password_hide_image1
                                        width: 25
                                        height: 25
                                        fillMode: Image.PreserveAspectFit
                                        source: "/res/password_hide.png"//"qrc:/../../../../Downloads/password_hide.png"
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
                                        source: "/res/password_show.png"//"qrc:/../../../../Downloads/password_show.png"
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
                            //database.signupExistingUser(user_name_text.text,user_mail_text.text,user_number_text.text)
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
                            password_hide_image1.visible = true
                            password_show_image1.visible = false
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
                            user_name_text.text == ""
                            user_mail_text.text == ""
                            user_number_text.text == ""
                            user_address_text.text == ""
                            user_locality_text.text == ""
                            user_password_text.text == ""
                            control.currentIndex = -1
                            password_hide_image1.visible = true
                            password_show_image1.visible = false
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
                        user_name_text.text = ''
                        user_mail_text.text = ''
                        user_number_text.text = ''
                        user_address_text.text = ''
                        user_locality_text.text = ''
                        user_password_text.text = ''
                        user_image.color = "white"
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
            source: "/res/backtologin-removebg-preview.png"//"qrc:/../../../../Downloads/backtologin-removebg-preview.png"
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
        onAccepted: {
            console.log("You chose: " + image_file_dialog.fileUrls)
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
        width: 200
        height: 100
        title: "New User"
        text: "We think your are a new user"
        informativeText: "Please Sign up/ Create a New Account."
        icon: StandardIcon.Warning
        /*Label {
            text: "We think your are a new user"
            Label{
                anchors.top: parent.bottom
                anchors.topMargin: 3
                text: "So kindly create a new account"
            }
        }*/
        standardButtons: Dialog.Ok
        onButtonClicked: {
            login_page_email_textfield.text = ""
            login_page_password_textfield.text = ""
        }
    }
    Dialog {
        id: incorrect_password_Dialog
        width: 260
        height: 160
        //icon: standardIcon.Warning
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
    /*Label{
        id:namerecord_Dialog
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.bottom: user_name.bottom
        anchors.bottomMargin: 5
        visible: false
        text: "*Entered Name is Already taken"
        color: "red"
        background: Rectangle{
            width: 100
            height: 7
            color: "#031C28"
        }
    }*/

    Dialog {
        id: namerecord_Dialog
        width: 200
        height: 100
        title: "Already Registered Name"
        Label {
            text: "Entered Name is Already Registered."
            //            Label{
            //                anchors.top: parent.bottom
            //                anchors.topMargin: 3
            //                text: "Please provide Alternate name"
            //                Label{
            //                    anchors.top: parent.bottom
            //                    anchors.topMargin: 3
            //                    text: "Create a New Account."
            //                }
            //            }

        }
        standardButtons: Dialog.Ok
        onButtonClicked: {
            user_name_text.text = ""
        }
    }

    Dialog {
        id: signout_Dialog
        width: 200
        height: 100
        title: "Sign Out"
        Label {
            text: "Are You Sure you want to Sign Out?."
        }
        standardButtons: Dialog.Yes | Dialog.No
        onYes: {
            database.logout()
            //            landing_page_rectangle.visible = false
            //            login_page_rectangle.visible = true
            //            login_page_email_textfield.text = ""
            //            login_page_password_textfield.text = ""

        }
        onNo: {
            landing_page_rectangle.visible = true
        }
    }
    Dialog {
        id: mailrecord_Dialog
        width: 200
        height: 100
        title: "Already Registered Mail"
        Label {
            text: "Entered Mail is Already Registered."
        }
        standardButtons: Dialog.Ok
        onAccepted: {
            //login_page_rectangle.visible = true
            user_mail_text.text = ""
        }
    }
    Dialog {
        id: number_record_Dialog
        width: 200
        height: 100
        title: "Already Registered Number"
        Label {
            text: "Entered Number is Already Registered."
        }
        standardButtons: Dialog.Ok
        onAccepted: {
            //login_page_rectangle.visible = true
            user_number_text.text = ""
        }
    }
    Dialog {
        id: uinrecord_Dialog
        width: 200
        height: 100
        title: "Already used UIN"
        Label {
            text: "Entered UIN is Already Used."
        }
        standardButtons: Dialog.Ok

    }
    //    Dialog {
    //        id: all_record_Dialog
    //        width: 200
    //        height: 100
    //        title: "Already Registered Name,Mail,Number"
    //        Label {
    //            text: "Given Name,Mail,Number is Already Registered."
    //            Label{
    //                anchors.top: parent.bottom
    //                anchors.topMargin: 3
    //                text: "Please provide Alternate Name,Mail,Number."
    //                Label{
    //                    anchors.top: parent.bottom
    //                    anchors.topMargin: 3
    //                    text: "Create a New Account."
    //                }
    //            }

    //        }
    //        standardButtons: Dialog.Ok
    //        onAccepted: {
    //            login_page_rectangle.visible = true
    //        }
    //    }
    Dialog {
        id: mailrecord_not_found
        width: 200
        height: 50
        title: "Wrong Mail ID"
        Label {
            text: "Please provide your Valid Mail Id"
        }
    }

    Dialog {
        id: connection_not_established_dialog
        width: 200
        height: 50
        title: "Connection Lost"
        Label {
            text: "Connection not established, Please try after Sometime."
        }
    }
    Dialog {
        id: connectionLostdialog
        width: 200
        height: 50
        title: "Connection Lost"
        Label {
            text: "Connection Lost, Please check your Internet Connection."
        }
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
            text: "Both passwords do not match"
        }
    }
    Dialog {
        id: password_updated
        width: 200
        height: 50
        title: "Updated"
        Label {
            text: "Password changed and Updated."
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
                border.width: 1
                border.color: "#05324D"

                ColumnLayout {
                    id: menu_column
                    //anchors.fill: parent
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
                            anchors.left: brand_rect.left
                            anchors.leftMargin:20
                            text: qsTr("Go Drona")
                            font.pointSize: 13
                            font.bold: true
                            color: "white"
                        }
                        Rectangle{
                            id: brand_logo
                            width: 90
                            height: 90
                            anchors.right: brand_rect.right
                            anchors.rightMargin: 20
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
                        height: 25
                        width: first_rectangle.width
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        //Layout.top: brand_row.bottom


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
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: dashboard_image.left
                            anchors.leftMargin: 30
                        }


                        MouseArea{
                            id:mouseArea
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: dashboard_button
                            onClicked: {
                                //                                hoverEnabled: false
                                dashboard_rectangle.visible = true
                                logout_button.color = "#031C28"
                                dashboard_button.color ="#F25822" || "#031C28"
                                managerpa_button.color = "#031C28"
                                flight_log_button.color = "#031C28"
                                manage_rpa_rectangle.visible = false
                                flight_log_rectangle.visible = false
                                rpa_register_page.visible = false
                                check_box.checked = false
                                check_box1.checked = false
                                check_box2.checked = false
                                check_box3.checked = false
                                check_box4.checked = false
                            }
                        }
                        /*states: State {
                            name: "pressed"; when: mouseArea.pressed
                            PropertyChanges { target: dashboard_button; scale: 1 }
                        }

                        transitions: Transition {
                            NumberAnimation { properties: "scale"; duration: 150; easing.type: Easing.InOutQuad }
                        }*/
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: landingrpa_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: managerpa_button
                            onClicked: {
                                manage_rpa_rectangle.visible = true
                                dashboard_rectangle.visible = false
                                flight_log_rectangle.visible = false
                                logout_button.color = "#031C28"
                                dashboard_button.color = "#031C28"
                                flight_log_button.color = "#031C28"
                                managerpa_button.color = "#F25822"
                                manage_rpa_header1.visible = true
                                check_box.checked = false
                                check_box1.checked = false
                                check_box2.checked = false
                                check_box3.checked = false
                                check_box4.checked = false
                                showPanel(this,"SetupParameterEditor.qml")
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: customers_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: remote_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: mission_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: missions_button
                            onClicked: {

                            }
                        }
                    }
                    Rectangle{
                        id: create_button
                        width: menu_rect_1.width -15
                        height: 25
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
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: create_mission_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: create_button
                            onClicked: {

                            }
                        }
                    }

                    Rectangle{
                        id: flight_log_button
                        width: menu_rect_1.width -15
                        height: 25
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
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: log_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: flight_log_button
                            onClicked: {
                                aws.read_text_file(database.awsname,QGroundControl.settingsManager.appSettings.telemetrySavePath)
                                flight_log_rectangle.visible = true
                                manage_rpa_rectangle.visible = false
                                dashboard_rectangle.visible = false
                                rpa_register_page.visible = false
                                logout_button.color = "#031C28"
                                flight_log_button.color = "#F25822"
                                managerpa_button.color = "#031C28"
                                dashboard_button.color = "#031C28"
                                check_box.checked = false
                                check_box1.checked = false
                                check_box2.checked = false
                                check_box3.checked = false
                                check_box4.checked = false
                                console.log(screen.width)
                                console.log(screen.width/5)
                                console.log(screen.width/1.8)
                                console.log((screen.width/1.8 - screen.width/5))
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: settings_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: notification_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
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
                            color: "#FFFFFF"
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: logout_image.left
                            anchors.leftMargin: 30
                        }

                        MouseArea{
                            //                            hoverEnabled: true
                            //                            onEntered: parent.color = '#F25822'
                            //                            onExited: parent.color = '#031C28'
                            anchors.fill: logout_button
                            onClicked: {
                                signout_Dialog.open()
                                logout_button.color = "#F25822"
                                dashboard_button.color ="#031C28"
                                managerpa_button.color = "#031C28"
                                flight_log_button.color = "#031C28"
                                check_box.checked = false
                                check_box1.checked = false
                                check_box2.checked = false
                                check_box3.checked = false
                                check_box4.checked = false
                                console.log(database.number)
                            }
                        }
                    }


                    /*=================== until here===========*/

                }
            }

            Rectangle {
                id: second_rectangle
                Layout.preferredWidth: mainWindow.width/1.8
                Layout.maximumWidth: mainWindow.width/1.8 + 100
                Layout.minimumWidth: mainWindow.width/1.8 - 100
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
                        height: 50
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
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: dashboard_rectangle_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: dashboard_text_search
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
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
                            height: screen.height - 50//350
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
                                font.pointSize: 10
                                //anchors.verticalCenter: parent.verticalCenter
                            }
                            Text{
                                id: username
                                text: qsTr(database.name)//"Chris Hemsworth"
                                color : "#F25822"
                                font.pointSize: 10
                                font.bold: true
                                anchors.left: greet.right
                                anchors.top: parent.top
                                anchors.topMargin: 20
                            }
                            Timer {
                                interval: 100; running: true; repeat: true
                                onTriggered:{
                                    username.text = database.name
                                    user_name_inprofile.text = database.name
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
                                font.pointSize: 10
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: greeting_text.bottom
                                anchors.topMargin: 25

                            }

                            Row{
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: overview.bottom
                                anchors.topMargin: 15
                                Row {
                                    spacing: 25
                                    Rectangle {
                                        color: "#4D05324D"
                                        width: 155; height: 150
                                        radius: 2

                                        Rectangle {
                                            id:flight_log_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 15
                                            width: parent.width/2
                                            height: 70
                                            color: "Green"
                                            radius: 3
                                            Image {
                                                id: flight_log_image
                                                anchors.centerIn: parent
                                                source: "qrc:/res/Flight_log.png"

                                            }
                                            ColorOverlay{
                                                anchors.fill: flight_log_image
                                                source:flight_log_image
                                                color: "white"
                                            }

                                        }

                                        Text {
                                            id: flightlog
                                            text: qsTr("Drone Log")
                                            font.pointSize: 9
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }

                                    }
                                    Rectangle {
                                        color: "#4D05324D"
                                        width: 155; height: 150
                                        radius: 2

                                        Rectangle {
                                            id:customers_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 15
                                            width: parent.width/2
                                            height: 70
                                            color: "black"
                                            radius: 4
                                            Image {
                                                id: customersimage
                                                anchors.centerIn: parent
                                                source: "qrc:/qmlimages/customers_black.png"

                                            }
                                            ColorOverlay{
                                                anchors.fill: customersimage
                                                source:customersimage
                                                color: "white"
                                            }

                                        }

                                        Text {
                                            id: customers
                                            text: qsTr("Customers")
                                            font.pointSize: 9
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }

                                    }

                                    Rectangle {
                                        color: "#4D05324D"
                                        width: 155; height: 150
                                        radius: 2

                                        Rectangle {
                                            id:remote_pilots_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 15
                                            width: parent.width/2
                                            height: 70
                                            color: "red"
                                            radius: 4
                                            Image {
                                                id: remote_pilots_image
                                                anchors.centerIn: parent
                                                source: "qrc:/qmlimages/Remote_pilot.png"

                                            }
                                            ColorOverlay{
                                                anchors.fill: remote_pilots_image
                                                source:remote_pilots_image
                                                color: "white"
                                            }

                                        }

                                        Text {
                                            id: remote_pilot_text
                                            text: qsTr("Remote Pilots")
                                            font.pointSize: 9
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }

                                    }
                                    Rectangle {
                                        id: back_to_fly_rect
                                        width: 155; height: 150
                                        radius: 2
                                        color: "#4D05324D"

                                        Rectangle{
                                            id:back_to_fly_image_rect
                                            anchors.left: parent.left
                                            anchors.leftMargin: 38
                                            anchors.top: parent.top
                                            anchors.topMargin: 15
                                            width: parent.width/2
                                            height: 70
                                            color: "Blue"
                                            radius: 4
                                            Image {
                                                id: back_to_fly_image
                                                anchors.centerIn: parent
                                                source: "qrc:/qmlimages/Back_to_fly.png"

                                            }
                                            ColorOverlay{
                                                anchors.fill: back_to_fly_image
                                                source:back_to_fly_image
                                                color: "white"
                                            }
                                        }
                                        Text {
                                            id: back_to_fly_text
                                            text: qsTr("Fly View")
                                            font.pointSize: 9
                                            anchors.bottom: parent.bottom
                                            anchors.bottomMargin: 20
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: "white"
                                        }
                                        /*MouseArea{
                                            id: flyView_mouseArea
                                            hoverEnabled: true
                                            onEntered: back_to_fly_rect.color = '#05324D'
                                            onExited: back_to_fly_rect.color = '#4D05324D'
                                            anchors.fill: back_to_fly_rect

                                            onClicked:{
                                                flightView.visible = true
                                                console.log("flightview clicked")
                                                login_page_rectangle.visible=false
                                                landing_page_rectangle.visible = false
                                                toolbar.visible =true
                                            }
                                        }*/
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: manage_rpa_rectangle
                    width: second_rectangle.width
                    //width: dashboard_rectangle.width
                    //height: dashboard_rectangle.height
                    color: "#031C28"
                    visible: false
                    border.color: "#05324D"
                    border.width: 1

                    Rectangle {
                        id:manage_rpa_header
                        color: "#031C28"
                        height: 50
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
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_rpa.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_rpa
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_rpa_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_rpa
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_rpa_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        //id: manage_rpa_rectangle_header
                        anchors.left: parent.left
                        anchors.top: manage_rpa_header.bottom//parent.top

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
                                font.pointSize: 10
                                font.bold: true
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 25
                            }

                            Rectangle {
                                id:back_to_button
                                anchors.right: manage_rpa_header1.right
                                anchors.rightMargin: 180
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                width: 130
                                height: 35
                                radius: 4
                                color: "red"//"#60031C28"

                                Loader {
                                    id: panelLoader
                                    anchors.fill: parent
                                    property var vehicleComponent

                                    function setSource(source, vehicleComponent) {
                                        panelLoader.source = ""
                                        panelLoader.vehicleComponent = vehicleComponent
                                        panelLoader.source = source
                                    }

                                    function setSourceComponent(sourceComponent, vehicleComponent) {
                                        panelLoader.sourceComponent = undefined
                                        panelLoader.vehicleComponent = vehicleComponent
                                        panelLoader.sourceComponent = sourceComponent
                                    }

                                }
                            }


                            Button {
                                anchors.right: manage_rpa_header1.right
                                anchors.rightMargin: 30
                                anchors.top: parent.top
                                anchors.topMargin: 20
                                Text {
                                    anchors.centerIn: parent
                                    text: "Register RPA"
                                    color:"white"
                                }
                                background: Rectangle {
                                    id:register_rpa_button
                                    implicitHeight: 35
                                    implicitWidth: 130
                                    border.width: 1
                                    border.color: "#F25822"
                                    radius: 4
                                    color: "#F25822"
                                }
                                onPressed: {
                                    register_rpa_button.color = "#05324D"
                                }
                                onReleased: {
                                    register_rpa_button.color = "#F25822"
                                }
                                onClicked: {
                                    updateButton = 1
                                    console.log("register button clicked"+updateButton)
                                    manage_rpa_header1.visible = false
                                    rpa_register_page.visible = true
                                    drone_contents.visible = true
                                    check_box.checked = false
                                    check_box1.checked = false
                                    check_box2.checked = false
                                    check_box3.checked = false
                                    check_box4.checked = false
                                    drone_type_list.currentIndex = -1
                                    drone_model_list.currentIndex = -1
                                    drone_name_text.text = ""
                                    uin_input_text.text = ""
                                    uin_input_text.enabled = true
                                }

                            }

                            //                            Item {
                            //                                id: table_item
                            //                                anchors.left: manage_rpa_header1.left
                            //                                anchors.leftMargin: 20
                            //                                anchors.top: list_of_rpa_text.bottom
                            //                                anchors.topMargin: 30
                            //                                width: manage_rpa_header1.width
                            //                                height: manage_rpa_header1.height + 400
                            //                                visible: true

                            /*TableView {
                                    id: rpa_list_table
                                    topMargin: 35
                                    columnWidthProvider: function (modelData) { return 177; }
                                    rowHeightProvider: function (modelData) { return 50; }
                                    width: table_item.width - 50
                                    height: 450
                                    boundsBehavior: Flickable.StopAtBounds
                                    clip: true
                                    ScrollBar.vertical: ScrollBar {
                                        id: tableVerticalBar;
                                        policy:ScrollBar.AsNeeded
                                    }

                                    ScrollBar.horizontal: ScrollBar {
                                        policy: ScrollBar.AsNeeded
                                    }

                                    MouseArea {
                                        onClicked: {
                                            selectedRowIndex = rpa_list_table.currentRow
                                            console.log(selectedRowIndex)
                                        }
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
                                                height: 40
                                                color: "#031C28"
                                                border.width: 2
                                                border.color: "#05324D"

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: rpadatabase.headerData(modelData, Qt.Horizontal)
                                                    color: "White"
                                                    font.pointSize: 11
                                                }
                                            }

                                        }
                                    }

                                    //Table body

                                    delegate: Rectangle {
                                        id: table_rows
                                        y: 35
                                        //property color rowColor: styleData.row === selectedRowIndex ? "green" : "blue"
                                        color: "#031C28"
                                        border.width: 2
                                        border.color: "#05324D"


                                        Text{
                                            text: display // This is set in rpa_database.cpp roleNames()
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            color: 'white'
                                            font.pixelSize: 15
                                            verticalAlignment: Text.AlignVCenter
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }*/
                            //                            }
                            Rectangle {
                                id: table_rect
                                anchors.left: manage_rpa_header1.left
                                anchors.leftMargin: 20
                                anchors.top: list_of_rpa_text.bottom
                                anchors.topMargin: 30
                                width: manage_rpa_header1.width - 50
                                height: 400
                                color: "#031C28"
                                visible: true

                                Row{
                                    id: header_row
                                    width: parent.width
                                    height: 40
                                    Rectangle {
                                        width:40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 2
                                        border.color: "#05324D"
                                    }

                                    Repeater {
                                        id: repeater_model
                                        model: ["TYPE", "MODEL NAME", "DRONE NAME", "UIN", "ACTIONS"] //, "ACTIONS"
                                        Rectangle {
                                            id: header
                                            width: (table_rect.width - 40) / 5
                                            height: 40
                                            color: "#031C28"
                                            border.width: 2
                                            border.color: "#05324D"

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData
                                                color: "White"
                                                font.pointSize: 11
                                            }
                                        }
                                    }

                                }

                                Column {
                                    id: checkbox_column
                                    anchors.top: parent.top
                                    anchors.topMargin: 40
                                    anchors.left: parent.left
                                    clip: true

                                    Rectangle{
                                        width: 40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 1
                                        border.color: "#05324D"
                                        visible: tableView.rows > 0
                                        CheckBox{
                                            id: check_box
                                            anchors.fill: parent
                                            indicator: Rectangle{
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                radius: 2
                                                color: "#031C28"
                                                border.width:0.5
                                                border.color: "#F25822"
                                                anchors.centerIn: parent
                                                Rectangle {
                                                    visible: check_box.checked
                                                    color: "#F25822"
                                                    radius: 1
                                                    anchors.margins: 2
                                                    anchors.fill: parent
                                                }
                                            }
//                                            visible: {
//                                                if(tableView.rows == 1){
//                                                    check_box.visible = true;
//                                                }
//                                            }

                                            checked: false
                                            onCheckedChanged: {
                                                if(check_box.checked == true){
                                                    check_box1.checked = false
                                                    check_box2.checked = false
                                                    check_box3.checked = false
                                                    check_box4.checked = false
                                                }
                                            }
                                        }
                                    }
                                    /*Repeater{
                                        model: tableView.rows
                                        Rectangle{
                                            width: 40
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            CheckBox{
                                                function isChecked() {
                                                    return ((number &(1 << index)) != 0);
                                                }
                                                id: check_box
                                                anchors.centerIn: parent
                                                checked: isChecked()
                                                onClicked:  {
                                                    {
                                                        if (checked) {
                                                            number |= (1<<index);
                                                            console.log(index + " is checked")
                                                        }
                                                        else {
                                                            number &= ~(1<<index);
                                                            console.log(index + " is not checked")
                                                        }

                                                        // now rebind the item's checked property
                                                        checked = Qt.binding(isChecked);

                                                    }
                                                }
                                            }
                                        }
                                    }*/
                                    Rectangle{
                                        width: 40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 1
                                        border.color: "#05324D"
                                        visible: tableView.rows > 1
                                        CheckBox{
                                            id: check_box1
                                            anchors.fill: parent
                                            indicator: Rectangle{
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                radius: 2
                                                color: "#031C28"
                                                border.width:0.5
                                                border.color: "#F25822"
                                                anchors.centerIn: parent
                                                Rectangle {
                                                    visible: check_box1.checked
                                                    color: "#F25822"
                                                    radius: 1
                                                    anchors.margins: 2
                                                    anchors.fill: parent
                                                }
                                            }
                                            checked: false
                                            onCheckedChanged: {
                                                if(check_box1.checked == true){
                                                    check_box.checked = false
                                                    check_box2.checked = false
                                                    check_box3.checked = false
                                                    check_box4.checked = false
                                                }
                                            }
                                        }
                                    }
                                    Rectangle{
                                        width: 40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 1
                                        border.color: "#05324D"
                                        visible: tableView.rows > 2
                                        CheckBox{
                                            id: check_box2
                                            anchors.fill: parent
                                            indicator: Rectangle{
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                radius: 2
                                                color: "#031C28"
                                                border.width:0.5
                                                border.color: "#F25822"
                                                anchors.centerIn: parent
                                                Rectangle {
                                                    visible: check_box2.checked
                                                    color: "#F25822"
                                                    radius: 1
                                                    anchors.margins: 2
                                                    anchors.fill: parent
                                                }
                                            }
                                            checked: false
                                            onCheckedChanged: {
                                                if(check_box2.checked == true){
                                                    check_box.checked = false
                                                    check_box1.checked = false
                                                    check_box3.checked = false
                                                    check_box4.checked = false
                                                }
                                            }
                                        }
                                    }
                                    Rectangle{
                                        width: 40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 1
                                        border.color: "#05324D"
                                        visible: tableView.rows > 3
                                        CheckBox{
                                            id: check_box3
                                            anchors.fill: parent
                                            indicator: Rectangle{
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                radius: 2
                                                color: "#031C28"
                                                border.width:0.5
                                                border.color: "#F25822"
                                                anchors.centerIn: parent
                                                Rectangle {
                                                    visible: check_box3.checked
                                                    color: "#F25822"
                                                    radius: 1
                                                    anchors.margins: 2
                                                    anchors.fill: parent
                                                }
                                            }
                                            checked: false
                                            onCheckedChanged: {
                                                if(check_box3.checked == true){
                                                    check_box.checked = false
                                                    check_box1.checked = false
                                                    check_box2.checked = false
                                                    check_box4.checked = false
                                                }
                                            }
                                        }
                                    }
                                    Rectangle{
                                        width: 40
                                        height: 40
                                        color: "#031C28"
                                        border.width: 1
                                        border.color: "#05324D"
                                        visible: tableView.rows > 4
                                        CheckBox{
                                            id: check_box4
                                            anchors.fill: parent
                                            indicator: Rectangle{
                                                implicitWidth: 16
                                                implicitHeight: 16
                                                radius: 2
                                                color: "#031C28"
                                                border.width:0.5
                                                border.color: "#F25822"
                                                anchors.centerIn: parent
                                                Rectangle {
                                                    visible: check_box4.checked
                                                    color: "#F25822"
                                                    radius: 1
                                                    anchors.margins: 2
                                                    anchors.fill: parent
                                                }
                                            }
                                            checked: false
                                            onCheckedChanged: {
                                                if(check_box4.checked == true){
                                                    check_box.checked = false
                                                    check_box1.checked = false
                                                    check_box2.checked = false
                                                    check_box3.checked = false
                                                }
                                            }
                                        }
                                    }
                                }
                                Item{
                                    id:table_item
                                    //anchors.left: parent.left
                                    //anchors.leftMargin: 40
                                    anchors.left: checkbox_column.right
                                    anchors.top: parent.top
                                    anchors.topMargin: 40
                                    width: (table_rect.width - 40)
                                    height: table_rect.height
                                    clip: true
                                    TableView {
                                        id: tableView
                                        columnWidthProvider:  function (column) { return rectangleWidth; } //167  134
                                        rowHeightProvider: function (column) { return 40; }
                                        anchors.fill: parent
                                        boundsBehavior: Flickable.StopAtBounds
                                        clip: true

                                        model: rpadatabase

                                        // Table Body

                                        delegate: Rectangle {
                                            id:table_row
                                            implicitHeight: 40
                                            border.width: 1
                                            border.color: "#05324D"
                                            color: "#031C28"
                                            Text{
                                                text: display // This is set in mysqlmodel.cpp roleNames()
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                color: 'white'
                                                font.pixelSize: 15
                                                verticalAlignment: Text.AlignVCenter
                                            }
                                        }
                                    }

                                }
                                Column{
                                    id: actions_column
                                    anchors.top:parent.top
                                    anchors.topMargin: 40
                                    //anchors.left: parent.left
                                    anchors.right: table_item.right
                                    //anchors.leftMargin: 574
                                    clip: true
//                                    Repeater{
//                                        model: tableView.rows
                                        Rectangle{
                                            id: actions_rect
                                            width: (table_rect.width - 40) / 5//134
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            visible: tableView.rows > 0
                                            Row{
                                                spacing: 15
//                                                anchors.top: actions_rect.top
//                                                anchors.topMargin: 2.5
//                                                anchors.left: actions_rect.left
//                                                anchors.leftMargin: 25
                                                anchors.centerIn: parent
                                                Rectangle{
                                                    id: edit_button
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: edit_image
                                                        source: "/res/edit.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: edit_image
                                                        source: edit_image
                                                        color:"orange"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: edit_button
                                                        onClicked: {
                                                            updateButton = 0;
                                                            if(updateButton === 0){
                                                                console.log("in edit button if"+ updateButton)
                                                                if(check_box.checked === true){
                                                                    rpadatabase.checkboxSqledit("select * from RpaList limit 1")
                                                                    //rpadatabase.checkboxSqledit("select * from RpaList where UIN ='" + rpadatabase.uin +" ")
                                                                    rpa_register_page.visible =  true
                                                                    manage_rpa_header1.visible = false
                                                                    console.log(rpadatabase.type)
                                                                    console.log(rpadatabase.model)
                                                                    console.log(rpadatabase.droneName)
                                                                    console.log(rpadatabase.uin)
                                                                    if(rpadatabase.type === "Nano"){
                                                                        drone_type_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.type === "Micro"){
                                                                        drone_type_list.currentIndex = 1
                                                                    }
                                                                    if(rpadatabase.type === "Small"){
                                                                        drone_type_list.currentIndex = 2
                                                                    }
                                                                    if(rpadatabase.type === "Medium"){
                                                                        drone_type_list.currentIndex = 3
                                                                    }
                                                                    if(rpadatabase.type === "Large"){
                                                                        drone_type_list.currentIndex = 4
                                                                    }
                                                                    if(rpadatabase.model === "Model A"){
                                                                        drone_model_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.model === "Model B"){
                                                                        drone_model_list.currentIndex = 1
                                                                    }
                                                                    drone_name_text.text = rpadatabase.droneName
                                                                    uin_input_text.text = rpadatabase.uin
                                                                    uin_input_text.enabled = false
                                                                    updateButton = 2
                                                                }
                                                            }

                                                        }
                                                        onPressed: {
                                                            edit_button.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            edit_button.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    id: delete_button
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: delete_image
                                                        source: "/res/delete.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: delete_image
                                                        source: delete_image
                                                        color:"red"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: delete_button
                                                        onClicked: {
                                                            if(check_box.checked === true){
                                                                 //rpadatabase.delete_table_contents("delete from RpaList Limit 1")
                                                                rpadatabase.delete_table_contents(1)
                                                                rpadatabase.callSql("select * from RpaList limit 5")
                                                                deleteDialog.visible = true
                                                                console.log("row erased")
                                                                check_box.checked = false
                                                                check_box1.checked = false
                                                                check_box2.checked = false
                                                                check_box3.checked = false
                                                                check_box4.checked = false
                                                            }
                                                        }
                                                        onPressed: {
                                                            delete_button.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            delete_button.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                /*Rectangle{
                                                    id: upload_button
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4
                                                    border.width: 0.5
                                                    border.color:"#6600FF00"

                                                    Image {
                                                        id: upload_image
                                                        source: "/res/upload.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: upload_image
                                                        source: upload_image
                                                        color:"#00FF00"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: upload_button
                                                        onClicked: {

                                                        }
                                                    }
                                                }*/
                                            }
                                        }
                                        Rectangle{
                                            id: actions_rect1
                                            width: (table_rect.width - 40) / 5
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            visible: tableView.rows > 1
                                            Row{
                                                spacing: 15
                                                anchors.centerIn: parent

                                                Rectangle{
                                                    id: edit_button1
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: edit_image1
                                                        source: "/res/edit.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: edit_image1
                                                        source: edit_image1
                                                        color:"orange"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: edit_button1
                                                        onClicked: {
                                                            updateButton = 0;
                                                            if(updateButton === 0){
                                                                console.log("in edit button if"+ updateButton)
                                                                if(check_box1.checked === true){
                                                                    rpadatabase.checkboxSqledit("select * from RpaList limit 1 offset 1")
                                                                    rpa_register_page.visible =  true
                                                                    manage_rpa_header1.visible = false
                                                                    console.log(rpadatabase.type)
                                                                    console.log(rpadatabase.model)
                                                                    console.log(rpadatabase.droneName)
                                                                    console.log(rpadatabase.uin)
                                                                    if(rpadatabase.type === "Nano"){
                                                                        drone_type_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.type === "Micro"){
                                                                        drone_type_list.currentIndex = 1
                                                                    }
                                                                    if(rpadatabase.type === "Small"){
                                                                        drone_type_list.currentIndex = 2
                                                                    }
                                                                    if(rpadatabase.type === "Medium"){
                                                                        drone_type_list.currentIndex = 3
                                                                    }
                                                                    if(rpadatabase.type === "Large"){
                                                                        drone_type_list.currentIndex = 4
                                                                    }
                                                                    if(rpadatabase.model === "Model A"){
                                                                        drone_model_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.model === "Model B"){
                                                                        drone_model_list.currentIndex = 1
                                                                    }
                                                                    drone_name_text.text = rpadatabase.droneName
                                                                    uin_input_text.text = rpadatabase.uin
                                                                    uin_input_text.enabled = false
                                                                    updateButton = 2
                                                                }
                                                            }

                                                        }
                                                        onPressed: {
                                                            edit_button1.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            edit_button1.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    id: delete_button1
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: delete_image1
                                                        source: "/res/delete.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: delete_image1
                                                        source: delete_image
                                                        color:"red"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: delete_button1
                                                        onClicked: {
                                                            if(check_box1.checked === true){
                                                                //rpadatabase.delete_table_contents("delete from RpaList Limit 1")
                                                                rpadatabase.delete_table_contents(2)
                                                                rpadatabase.callSql("select * from RpaList limit 5")
                                                                deleteDialog.visible = true
                                                                console.log("row erased")
                                                                check_box.checked = false
                                                                check_box1.checked = false
                                                                check_box2.checked = false
                                                                check_box3.checked = false
                                                                check_box4.checked = false
                                                            }
                                                        }
                                                        onPressed: {
                                                            delete_button1.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            delete_button1.color = "#031C28"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Rectangle{
                                            id: actions_rect2
                                            width: (table_rect.width - 40) / 5
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            visible: tableView.rows > 2
                                            Row{
                                                spacing: 15
                                                anchors.centerIn: parent
                                                Rectangle{
                                                    id: edit_button2
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: edit_image2
                                                        source: "/res/edit.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: edit_image2
                                                        source: edit_image2
                                                        color:"orange"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: edit_button2
                                                        onClicked: {
                                                            updateButton = 0;
                                                            if(updateButton === 0){
                                                                console.log("in edit button if"+ updateButton)
                                                                if(check_box2.checked === true){
                                                                    rpadatabase.checkboxSqledit("select * from RpaList limit 1 offset 2")
                                                                    rpa_register_page.visible =  true
                                                                    manage_rpa_header1.visible = false
                                                                    console.log(rpadatabase.type)
                                                                    console.log(rpadatabase.model)
                                                                    console.log(rpadatabase.droneName)
                                                                    console.log(rpadatabase.uin)
                                                                    if(rpadatabase.type === "Nano"){
                                                                        drone_type_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.type === "Micro"){
                                                                        drone_type_list.currentIndex = 1
                                                                    }
                                                                    if(rpadatabase.type === "Small"){
                                                                        drone_type_list.currentIndex = 2
                                                                    }
                                                                    if(rpadatabase.type === "Medium"){
                                                                        drone_type_list.currentIndex = 3
                                                                    }
                                                                    if(rpadatabase.type === "Large"){
                                                                        drone_type_list.currentIndex = 4
                                                                    }
                                                                    if(rpadatabase.model === "Model A"){
                                                                        drone_model_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.model === "Model B"){
                                                                        drone_model_list.currentIndex = 1
                                                                    }
                                                                    drone_name_text.text = rpadatabase.droneName
                                                                    uin_input_text.text = rpadatabase.uin
                                                                    uin_input_text.enabled = false
                                                                    updateButton = 2
                                                                }
                                                            }

                                                        }
                                                        onPressed: {
                                                            edit_button2.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            edit_button2.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    id: delete_button2
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: delete_image2
                                                        source: "/res/delete.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: delete_image2
                                                        source: delete_image2
                                                        color:"red"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: delete_button2
                                                        onClicked: {
                                                            if(check_box2.checked === true){
                                                                //rpadatabase.delete_table_contents("delete from RpaList where UIN = ' " + rpadatabase.uin + "'")
                                                                rpadatabase.delete_table_contents(3)
                                                                rpadatabase.callSql("select * from RpaList limit 5")
                                                                deleteDialog.visible = true
                                                                console.log("row erased")
                                                                check_box.checked = false
                                                                check_box1.checked = false
                                                                check_box2.checked = false
                                                                check_box3.checked = false
                                                                check_box4.checked = false
                                                            }
                                                        }
                                                        onPressed: {
                                                            delete_button2.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            delete_button2.color = "#031C28"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Rectangle{
                                            id: actions_rect3
                                            width: (table_rect.width - 40) / 5
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            visible: tableView.rows > 3
                                            Row{
                                                spacing: 15
                                                anchors.centerIn: parent
                                                Rectangle{
                                                    id: edit_button3
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: edit_image3
                                                        source: "/res/edit.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: edit_image3
                                                        source: edit_image3
                                                        color:"orange"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: edit_button3
                                                        onClicked: {
                                                            updateButton = 0;
                                                            if(updateButton === 0){
                                                                console.log("in edit button if"+ updateButton)
                                                                if(check_box3.checked === true){
                                                                    rpadatabase.checkboxSqledit("select * from RpaList limit 1 offset 3")
                                                                    rpa_register_page.visible =  true
                                                                    manage_rpa_header1.visible = false
                                                                    console.log(rpadatabase.type)
                                                                    console.log(rpadatabase.model)
                                                                    console.log(rpadatabase.droneName)
                                                                    console.log(rpadatabase.uin)
                                                                    if(rpadatabase.type === "Nano"){
                                                                        drone_type_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.type === "Micro"){
                                                                        drone_type_list.currentIndex = 1
                                                                    }
                                                                    if(rpadatabase.type === "Small"){
                                                                        drone_type_list.currentIndex = 2
                                                                    }
                                                                    if(rpadatabase.type === "Medium"){
                                                                        drone_type_list.currentIndex = 3
                                                                    }
                                                                    if(rpadatabase.type === "Large"){
                                                                        drone_type_list.currentIndex = 4
                                                                    }
                                                                    if(rpadatabase.model === "Model A"){
                                                                        drone_model_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.model === "Model B"){
                                                                        drone_model_list.currentIndex = 1
                                                                    }
                                                                    drone_name_text.text = rpadatabase.droneName
                                                                    uin_input_text.text = rpadatabase.uin
                                                                    uin_input_text.enabled = false
                                                                    updateButton = 2
                                                                }
                                                            }

                                                        }
                                                        onPressed: {
                                                            edit_button3.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            edit_button3.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    id: delete_button3
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: delete_image3
                                                        source: "/res/delete.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: delete_image3
                                                        source: delete_image3
                                                        color:"red"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: delete_button3
                                                        onClicked: {
                                                            if(check_box2.checked === true){
                                                                //rpadatabase.delete_table_contents("delete from RpaList where UIN = ' " + rpadatabase.uin + "'")
                                                                rpadatabase.delete_table_contents(4)
                                                                rpadatabase.callSql("select * from RpaList limit 5")
                                                                deleteDialog.visible = true
                                                                console.log("row erased")
                                                                check_box.checked = false
                                                                check_box1.checked = false
                                                                check_box2.checked = false
                                                                check_box3.checked = false
                                                                check_box4.checked = false
                                                            }
                                                        }
                                                        onPressed: {
                                                            delete_button3.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            delete_button3.color = "#031C28"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        Rectangle{
                                            id: actions_rect4
                                            width: (table_rect.width - 40) / 5
                                            height: 40
                                            color: "#031C28"
                                            border.width: 1
                                            border.color: "#05324D"
                                            visible: tableView.rows > 4
                                            Row{
                                                spacing: 15
                                                anchors.centerIn: parent
                                                Rectangle{
                                                    id: edit_button4
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: edit_image4
                                                        source: "/res/edit.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: edit_image4
                                                        source: edit_image4
                                                        color:"orange"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: edit_button4
                                                        onClicked: {
                                                            updateButton = 0;
                                                            if(updateButton === 0){
                                                                console.log("in edit button if"+ updateButton)
                                                                if(check_box4.checked === true){
                                                                    rpadatabase.checkboxSqledit("select * from RpaList limit 1 offset 4")
                                                                    rpa_register_page.visible =  true
                                                                    manage_rpa_header1.visible = false
                                                                    console.log(rpadatabase.type)
                                                                    console.log(rpadatabase.model)
                                                                    console.log(rpadatabase.droneName)
                                                                    console.log(rpadatabase.uin)
                                                                    if(rpadatabase.type === "Nano"){
                                                                        drone_type_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.type === "Micro"){
                                                                        drone_type_list.currentIndex = 1
                                                                    }
                                                                    if(rpadatabase.type === "Small"){
                                                                        drone_type_list.currentIndex = 2
                                                                    }
                                                                    if(rpadatabase.type === "Medium"){
                                                                        drone_type_list.currentIndex = 3
                                                                    }
                                                                    if(rpadatabase.type === "Large"){
                                                                        drone_type_list.currentIndex = 4
                                                                    }
                                                                    if(rpadatabase.model === "Model A"){
                                                                        drone_model_list.currentIndex = 0
                                                                    }
                                                                    if(rpadatabase.model === "Model B"){
                                                                        drone_model_list.currentIndex = 1
                                                                    }
                                                                    drone_name_text.text = rpadatabase.droneName
                                                                    uin_input_text.text = rpadatabase.uin
                                                                    uin_input_text.enabled = false
                                                                    updateButton = 2
                                                                }
                                                            }

                                                        }
                                                        onPressed: {
                                                            edit_button4.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            edit_button4.color = "#031C28"
                                                        }
                                                    }
                                                }
                                                Rectangle{
                                                    id: delete_button4
                                                    width: 35
                                                    height: 35
                                                    color: "#031C28"
                                                    radius: 4

                                                    Image {
                                                        id: delete_image4
                                                        source: "/res/delete.png"
                                                        anchors.centerIn: parent
                                                    }
                                                    ColorOverlay{
                                                        anchors.fill: delete_image4
                                                        source: delete_image4
                                                        color:"red"
                                                    }
                                                    MouseArea{
                                                        anchors.fill: delete_button4
                                                        onClicked: {
                                                            if(check_box4.checked === true){
                                                                //console.log(model.index)
                                                                //rpadatabase.delete_table_contents("delete from RpaList where UIN = ' " + rpadatabase.uin + "'")
                                                                rpadatabase.delete_table_contents(5)
                                                                rpadatabase.callSql("select * from RpaList limit 5")
                                                                deleteDialog.visible = true
                                                                console.log("row erased")
                                                                check_box.checked = false
                                                                check_box1.checked = false
                                                                check_box2.checked = false
                                                                check_box3.checked = false
                                                                check_box4.checked = false
                                                            }
                                                        }
                                                        onPressed: {
                                                            delete_button4.color = "#F25822"
                                                        }
                                                        onReleased: {
                                                            delete_button4.color = "#031C28"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    //}
                                }
                            }
                            /*Rectangle{
                                id: page_number_rect
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: table_rect.bottom
                                width: table_rect.width
                                height: 40
                                radius: 4
                                color: "#05324D"

                            }*/

                        }


                    }
                    Rectangle{
                        id: rpa_register_page
                        color: "#031C28"
                        visible: false
                        //height: parent.height
                        //width: parent.width
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
                            width: 25
                            height: 25
                            color: "#031C28"

                            Image {
                                //id: back_arrow
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
                                        rpa_register_page.visible =  false
                                        manage_rpa_header1.visible = true
                                        drone_type_list.currentIndex = -1
                                        drone_model_list.currentIndex = -1
                                        drone_name_text.text = ""
                                        uin_input_text.text = ""
                                        uin_input_text.enabled = true
                                        check_box.checked = false
                                        check_box1.checked = false
                                        check_box2.checked = false
                                        check_box3.checked = false
                                        check_box4.checked = false
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
                            anchors.leftMargin: 30
                            anchors.top: parent.top
                            anchors.topMargin: 25
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
                                    Image {
                                        id:drone_image
                                        source: "qrc:/qmlimages/drone_1.png" //""
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
                                            anchors.centerIn: parent
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
                                text: qsTr("Drone Type*")
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
                                            context.fillStyle = "white";//"#17a81a" : "#21be2b"
                                            context.fill();
                                        }
                                    }

                                    contentItem: Text {
                                        id: combo_box1
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
                                anchors.rightMargin: 95
                                anchors.top: drone_contents.top
                                anchors.topMargin: 120
                                text: qsTr("Name/Drone's Model Name*")
                                color: "White"
                                font.pointSize: 10
                            }

                            Rectangle {
                                id: drone_model_combo
                                width: 200
                                height: 35
                                anchors.right: drone_contents.right
                                anchors.rightMargin: 80
                                anchors.top: drone_model_text.top
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
                                        id: combo_box2
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
                                text: qsTr("Drone Name*")
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
                                    selectByMouse: true
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
                                anchors.top: rpa_text.top
                                anchors.topMargin: 70
                                text: qsTr("UIN*")
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
                                    enabled: editUin ? true : false
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.margins: 5
                                    text: ""
                                    color: "white"
                                    selectByMouse: true
                                    maximumLength: 8
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
                            anchors.leftMargin: parent.width/3
                            anchors.bottom: drone_contents.bottom
                            anchors.bottomMargin: 20
                            Button {
                                Text {
                                    anchors.centerIn: parent
                                    text: "Update"
                                    color:"white"
                                }
                                background: Rectangle {
                                    id:update_Button
                                    implicitHeight: 35
                                    implicitWidth: 100
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
                                            rpadatabase.existingUIN(uin_input_text.text)
                                            //uinDialog.visible = true
                                            console.log("in update button if "+ updateButton)
                                        }
                                    }
                                    else if(updateButton == 2){
                                        console.log("in update button else"+ updateButton)
                                        rpadatabase.update_table_contents(combo_box1.text, combo_box2.text, drone_name_text.text,uin_input_text.text)
                                        rpa_register_page.visible = false
                                        manage_rpa_header1.visible = true
                                        rpadatabase.callSql("select * from RpaList limit 5")
                                        tableDialog.visible = true
                                        drone_type_list.currentIndex = -1
                                        drone_model_list.currentIndex = -1
                                        drone_name_text.text = ""
                                        uin_input_text.text = ""
                                        uin_input_text.enabled = true
                                        check_box.checked = false
                                        check_box1.checked = false
                                        check_box2.checked = false
                                        check_box3.checked = false
                                        check_box4.checked = false
                                        updateButton = 1
                                        console.log("in update button else when ending"+ updateButton)
                                    }

                                }
                            }

                            Button {
                                Text {
                                    anchors.centerIn: parent
                                    text: "Cancel"
                                    color:"white"
                                }

                                background: Rectangle {
                                    id: cancel_Button
                                    implicitHeight: 35
                                    implicitWidth: 100
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
                                    manage_rpa_header1.visible = true
                                    rpa_register_page.visible = false
                                    drone_type_list.currentIndex = -1
                                    drone_model_list.currentIndex = -1
                                    drone_name_text.text = ""
                                    uin_input_text.text = ""
                                    uin_input_text.enabled = true
                                    check_box.checked = false
                                    check_box1.checked = false
                                    check_box2.checked = false
                                    check_box3.checked = false
                                    check_box4.checked = false
                                }
                            }
                        }

                        MessageDialog{
                            id:fillDialog
                            height: 50
                            width: 50
                            text:"please fill the details correctly"
                        }

                        MessageDialog{
                            id:uinDialog
                            height: 50
                            width: 50
                            text:"Registered Successfully."
                        }
                        MessageDialog{
                            id:tableDialog
                            height: 50
                            width: 50
                            text:"Updated Successfully."
                        }
                        MessageDialog{
                            id:deleteDialog
                            height: 50
                            width: 50
                            text:"Row Deleted Successfully."
                        }
                    }

                }

                /*Rectangle {
                    id: manage_customers_rectangle
                    width: second_rectangle.width
                    visible: false
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id: manage_customers_header
                        color: "#031C28"
                        height: 50
                        width: manage_customers_rectangle.width
                        border.color: "#05324D"
                        border.width: 1

                        Image {
                            id: hamburger_image_mc
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: manage_customers_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text_mc
                            text: "MANAGE CUSTOMERS"
                            color: "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_mc.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_mc
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_customers_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_mc
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manage_customers_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        id: mc_rectangle_column
                        anchors.left: parent.left
                        anchors.top: manage_customers_header.bottom

                        Rectangle{
                            id: manage_customers_header1
                            height: screen.height - 50//350
                            width: manage_customers_rectangle.width
                            color: "#031C28"
                            border.color: "#05324D"
                            border.width: 1
                        }
                    }
                }
                Rectangle {
                    id: remote_pilots_rectangle
                    width: second_rectangle.width
                    visible: false
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id: remote_pilots_header
                        color: "#031C28"
                        height: 50
                        width: remote_pilots_rectangle.width
                        border.color: "#05324D"
                        border.width: 1

                        Image {
                            id: hamburger_image_rp
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: remote_pilots_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text_rp
                            text: "REMOTE PILOTS"
                            color: "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_rp.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_rp
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: remote_pilots_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_rp
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: remote_pilots_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        id: rp_rectangle_column
                        anchors.left: parent.left
                        anchors.top: remote_pilots_header.bottom

                        Rectangle{
                            id: remote_pilots_header1
                            height: screen.height - 50//350
                            width: remote_pilots_rectangle.width
                            color: "#031C28"
                            border.color: "#05324D"
                            border.width: 1
                        }
                    }
                }
                Rectangle {
                    id: missions_rectangle
                    width: second_rectangle.width
                    visible: false
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id: missions_header
                        color: "#031C28"
                        height: 50
                        width: missions_rectangle.width
                        border.color: "#05324D"
                        border.width: 1

                        Image {
                            id: hamburger_image_m
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: missions_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text_m
                            text: "MANAGE CUSTOMERS"
                            color: "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_m.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_m
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: missions_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_m
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: missions_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        id: m_rectangle_column
                        anchors.left: parent.left
                        anchors.top: missions_header.bottom

                        Rectangle{
                            id: missions_header1
                            height: screen.height - 50//350
                            width: missions_rectangle.width
                            color: "#031C28"
                            border.color: "#05324D"
                            border.width: 1
                        }
                    }
                }
                Rectangle {
                    id: manual_missions_rectangle
                    width: second_rectangle.width
                    visible: false
                    color: "#031C28"
                    border.color: "#05324D"
                    border.width: 1
                    Rectangle {
                        id: manual_missions_header
                        color: "#031C28"
                        height: 50
                        width: dashboard_rectangle.width
                        border.color: "#05324D"
                        border.width: 1

                        Image {
                            id: hamburger_image_mm
                            source: "/res/hamburger_menu.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: manual_missions_header.left
                            anchors.leftMargin: 20
                        }

                        Text {
                            id: dashboard_text_mm
                            text: "MANAGE CUSTOMERS"
                            color: "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_mm.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_mm
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manual_missions_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_mm
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: manual_missions_header.right
                            anchors.rightMargin: 100
                        }
                    }

                    Column {
                        id: mm_rectangle_column
                        anchors.left: parent.left
                        anchors.top: manual_missions_header.bottom

                        Rectangle{
                            id: manual_missions_header1
                            height: screen.height - 50//350
                            width: dashboard_rectangle.width
                            color: "#031C28"
                            border.color: "#05324D"
                            border.width: 1
                        }
                    }
                }*/
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
                        height: 50
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
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: hamburger_image_flight_log.left
                            anchors.leftMargin: 25
                        }

                        Image {
                            id: search_image_flight_log
                            source: "/res/search.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: flight_log_header.right
                            anchors.rightMargin: 180
                        }
                        Text{
                            id: search_flight_log
                            text: "Search"
                            color : "white"
                            font.pointSize: 10
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
                                interval: 100; running: true; repeat: true
                                onTriggered:{
                                    folder_list_model.model = aws.name
                                }
                            }

                            ListView {
                                id: folder_list_model
                                anchors.fill: parent
                                model: aws.name
                                delegate: RowLayout {
                                    id: rowLayout
                                    width: parent.width
                                    height: 40
                                    spacing: 50

                                    CheckBox {
                                        id: log_checkBox
                                        Layout.alignment: Qt.AlignVCenter
                                        indicator: Rectangle{
                                            implicitWidth: 16
                                            implicitHeight: 16
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
                                        text: modelData //fileName
                                        color: "white"
                                        font.pointSize: 11
                                        Layout.alignment: Qt.AlignVCenter
                                    }


                                    Button {
                                        id: downloadButton
                                        Text {
                                            anchors.centerIn: parent
                                            text: "Download"
                                            color:"white"
                                        }
                                        background: Rectangle {
                                            id:log_download_button
                                            implicitHeight: 30
                                            implicitWidth: 120
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
                                            //var sourceFile = folderModel.folder + "/" + fileName;
                                            //console.log("Source file path: " + sourceFile);

                                            var fileDialog = Qt.createQmlObject('import QtQuick.Dialogs 1.3; FileDialog {}', downloadButton);
                                            fileDialog.selectExisting = false;
                                            fileDialog.selectMultiple = false;
                                            fileDialog.title = "Save file";

                                            fileDialog.accepted.connect(function() {
                                                log_download_button.color = "#DA2C43"
                                                log_checkBox.checked = false
                                                var destFile = fileDialog.fileUrls.length > 0 ? fileDialog.fileUrls[0].toString() : "";
                                                console.log("Destination file path: " + destFile);
                                                var destFileLoaction;
                                                function pfx_file_location_function(str)
                                                {
                                                    destFileLoaction = str.slice(str.lastIndexOf("file://")+7)
                                                }
                                                pfx_file_location_function(destFile);
                                                aws.download_file(modelData,destFileLoaction);
                                            });
                                            fileDialog.rejected.connect(function(){
                                                log_download_button.color = "#DA2C43";
                                                log_checkBox.checked = false
                                            });
                                            fileDialog.open();
                                        }
                                    }
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
                        height: 50
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
                            anchors.rightMargin: 120
                            anchors.verticalCenter: parent.verticalCenter
                            height: 40
                            width: 40
                            clip:true
                            radius: width/2
                            color: "#05324D"
                            border.width: 1
                            border.color: "#F25822"

                            Image {
                                id: user_image_inprofile
                                source:user_profile_image.source//"qrc:/qmlimages/drone_1.png"
                                anchors.fill: image_rect
                                fillMode: Image.PreserveAspectCrop
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: image_rect
                                }
                            }

                            /*MouseArea{
                                anchors.fill: image_rect
                                onClicked:{
                                    //database.profile_contents("select industry,address,locality,password from UsersLoginInfo where number="+database.number)
                                    //database.username_
                                    users_profile_header1.visible = false
                                    users_information_header1.visible = true
                                    userprofile_name.text = database.name
                                    mail_address.text = database.mail
                                    mobile_number.text = database.number
                                    address_field.text = database.address
                                    locality_field.text = database.locality
                                    password_field.text = database.password
                                }
                                onPressed: {
                                    image_rect.color = "#F25822"
                                }
                                onReleased: {
                                    image_rect.color = "#05324D"
                                }
                            }*/
                        }
                        Column {
                            spacing: 5
                            anchors.left: image_rect.right
                            anchors.leftMargin: 10
                            anchors.top: users_profile_header.top
                            anchors.topMargin: 5

                            Text {
                                id: user_name_inprofile
                                wrapMode: Text.WordWrap
                                text: qsTr(database.name)
                                color:"white"
                                font.pointSize: 10
                                //font.pixelSize: 0.1 * parent.height
                            }
                            Text {
                                text: "OEM"
                                color: "#F25822"
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

                        Rectangle {
                            id: go_to_profile
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            color: "#05324D"
                            border.color: "#F25822"
                            border.width: 0.5
                            width: 100
                            height: 30
                            radius: 3
                            Text {
                                text: "Your Profile"
                                color: "#FFFFFF"
                                font.pointSize: 10
                                anchors.centerIn: parent
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            MouseArea{
                                anchors.fill: go_to_profile
                                onClicked: {
                                    users_profile_header1.visible = false
                                    users_information_header1.visible = true
                                    userprofile_name.text = database.name
                                    mail_address.text = database.mail
                                    mobile_number.text = database.number
                                    address_field.text = database.address
                                    locality_field.text = database.locality
                                    password_field.text = database.password
                                }
                                onPressed: {
                                    go_to_profile.color = "#F25822"
                                }
                                onReleased: {
                                    go_to_profile.color = "#05324D"
                                }
                            }
                        }

                        Column{
                            spacing: 10
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.top: parent.top
                            anchors.topMargin: 45
                            Text {
                                text : "Subscription"
                                color: "white"
                                font.bold: true
                                font.pointSize: 10
                            }

                            Rectangle {
                                height: 100
                                width: third_rectangle.width -50
                                color: "#031C28"
                                border.width: 1
                                border.color: "cyan"

                                Label {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.top: parent.top
                                    anchors.topMargin: 10
                                    text: "Your Current Active Plan is"
                                    wrapMode: Text.WordWrap
                                    color: "#ffffff"
                                    font.pointSize: 9
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
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: userprofile_name
                                    readOnly: true
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Name")
                                    text: database.name
                                    color:"white"
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: userprofile_name.height
                                        implicitWidth: userprofile_name.width
                                    }
                                    /*onAccepted: {
                                        if(userprofile_name.text != ""){
                                            database.existingUserProfilename(userprofile_name.text)
                                        }
                                    }*/
                                }
                            }
                            Column{
                                spacing:5
                                Text{
                                    text: "Mail Address"
                                    color: "white"
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: mail_address
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    placeholderText: qsTr("user@gmail.com")
                                    text: database.mail
                                    color:"white"
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: mail_address.height
                                        implicitWidth: mail_address.width
                                    }
                                    onAccepted :{
                                        if(mail_address.text != ""){
                                            database.existingUserProfilemail(mail_address.text)
                                        }
                                    }
                                }
                            }
                            Column{
                                spacing:5
                                Text{
                                    text: "Mobile number"
                                    color: "white"
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: mobile_number
                                    readOnly: true
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    text: database.number
                                    color:"white"
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
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: address_field
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Address")
                                    text: database.address
                                    color:"white"
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
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: locality_field
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    placeholderText: qsTr("User Locality")
                                    text: database.locality
                                    color:"white"
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
                            Column{
                                spacing:5
                                Text{
                                    text: "Password"
                                    color: "white"
                                    font.pointSize: 9
                                }
                                TextField{
                                    id: password_field
                                    width: third_rectangle.width -50
                                    height: 35
                                    anchors.margins: 5
                                    placeholderText: qsTr("password")
                                    text: database.password
                                    color:"white"
                                    background: Rectangle{
                                        color: "#05324D"
                                        radius: 4
                                        border.width: 1
                                        border.color: "#05324D"
                                        implicitHeight: password_field.height
                                        implicitWidth: password_field.width
                                    }
                                }
                            }

                        }
                        Rectangle {
                            id: update_profile
                            width: 60
                            height: 30
                            anchors.right: users_information_header1.right
                            anchors.rightMargin: 100
                            anchors.bottom: users_information_header1.bottom
                            anchors.bottomMargin: 80
                            color: "#05324D"
                            radius: 4
                            border.width: 1
                            border.color: "#F25822"

                            Text {
                                text:"Update"
                                color: "white"
                                font.pointSize: 10
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: update_profile
                                onClicked: {
                                    //reflect all the updated info to the database
                                    if(userprofile_name.text == "" || mail_address.text == "" || locality_field.text == "" || address_field.text == "" || password_field.text == ""){
                                        popupDialog.open()
                                    }
                                    else {
                                        database.update_profile_contents(userprofile_name.text, mail_address.text,mobile_number.text,address_field.text,locality_field.text,password_field.text)
                                        users_profile_header1.visible = true
                                        users_information_header1.visible = false
                                        profileDialog.open()
                                        mail_address.text = database.mail
                                        mobile_number.text = database.number
                                        address_field.text = database.address
                                        locality_field.text = database.locality
                                        password_field.text = database.password
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
                            height: 50
                            width: 50
                            text:"Please Fill all the Details"
                        }

                        Rectangle {
                            id: back_to_profile
                            width: 60
                            height: 30
                            anchors.left: update_profile.right
                            anchors.leftMargin: 20
                            anchors.bottom: users_information_header1.bottom
                            anchors.bottomMargin: 80
                            color: "#05324D"
                            radius: 4
                            border.width: 1
                            border.color: "#F25822"

                            Text {
                                text:"Back"
                                color: "white"
                                font.pointSize: 10
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
                            height: 50
                            width: 50
                            text:"Profile Updated Successfully."
                        }
                    }
                }
            }
        }
    }
}


