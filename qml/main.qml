import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root
    width: 1920
    height: 1080
    color: "#222"

    // Prevent Alt+F4 and Esc
    Keys.onPressed: {
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_F4)
            event.accepted = true;
    }

    property string username: systemUsername
    property string password: ""

    // Background image
    Image {
        id: bg
        anchors.fill: parent
        source: "Blue.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Overlay with UI box
        Image {
            id: overlayBox
            width: 920
            height: 720
            source: "rectangle.png"
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.centerIn: parent
                spacing: 30
                width: 600



                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 120
                    height: 120
                    source: "rectangle.png"

                    Image {
                        anchors.centerIn: parent
                        width: 100
                        height: 100
                        source: "user.jpg"
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.username + " welcome to Arch"
                    font.pixelSize: 30
                    color: "black"
                }

                Column {
                    width: parent.width

                    Text {
                        text: "Enter Password"
                        color: "black"
                        font.pixelSize: 20
                        // horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }

                    TextField {
                        id: passwordField
                        placeholderText: "Password"
                        echoMode: TextInput.Password
                        width: parent.width
                        height: 50
                        font.pixelSize: 22
                        padding: 10
                        color: "black"
                        onTextChanged: root.password = text
                        focus: true
                        Keys.onReturnPressed: {
                            console.log("Trying to auth as:", root.username, "with password:", root.password)
                            lockManager.authenticate(root.username, root.password)
                        }
                        background: Rectangle {
                            color: "white"  // Background color
                            radius: 20
                            border.color: "#555555"
                            border.width: 1
                        }
                    }
                }

                Button {
                    text: "Unlock"
                    width: 100
                    background: Rectangle {
                        color: "#33aaff"          // Background color
                        radius: 20
                        border.color: "#0077cc"
                        border.width: 2
                    }
                    onClicked: {
                        console.log("Trying to auth as:", root.username, "with password:", root.password)
                        lockManager.authenticate(root.username, root.password)
                    }
                }
            }
        }

    }



    Connections {
        target: lockManager
        function onAuthResult(success) {
            if (success) {
                Qt.quit()
            } else {
                console.log("Authentication failed")
                passwordField.text = ""
                passwordField.forceActiveFocus()
            }
        }
    }
}
