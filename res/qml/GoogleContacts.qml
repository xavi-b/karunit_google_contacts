import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.XmlListModel 2.15
import QZXing 2.3

import Karunit 1.0
import KarunitPlugins 1.0

Item {
    id: googlecontacts
    visible: true

    Connections {
        target: KUPGoogleContactsPluginConnector
        function onAuthenticated() {
            stackView.push(contactsPage)
        }

        function onPendingVerification(verificationUrl, userCode) {
            qrcode.source = "image://QZXing/encode/" + verificationUrl
            verificationUrlLabel.text = verificationUrl
            userCodeLabel.text = userCode
            stackView.push(connectionPage)
        }

        function onContactsRequest(contactsXml) {
            contactsModel.xml = contactsXml
        }
    }

    function askDeviceCode() {
        stackView.clear(StackView.PopTransition)
        stackView.push(waitingPage, {}, StackView.PopTransition)
    }

    function askDeviceCodeSignal() {
        KUPGoogleContactsPluginConnector.askDeviceCode()
    }

    function callSignal(number) {
        KUPGoogleContactsPluginConnector.call(number)
    }

    Page {
        id: waitingPage

        Button {
            text: qsTr("Ask for device code")
            anchors.centerIn: parent
            onClicked: {
                KUPGoogleContactsPluginConnector.setEngine(this)
                googlecontacts.askDeviceCodeSignal()
            }
        }
    }

    Page {
        id: connectionPage

        ColumnLayout {
            anchors.centerIn: parent
            Image {
                id: qrcode
                cache: false
                sourceSize.width: 200
                sourceSize.height: 200
                Layout.alignment: Qt.AlignHCenter
            }
            TextEdit {
                id: verificationUrlLabel
                readOnly: true
                wrapMode: Text.WordWrap
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
            }
            TextEdit {
                id: userCodeLabel
                readOnly: true
                wrapMode: Text.WordWrap
                selectByMouse: true
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                font.pixelSize: 30
            }
        }
    }

    Page {
        id: contactsPage

        XmlListModel {
            id: contactsModel
            query: "/feed/entry"
            namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
                                   + "declare namespace gd='http://schemas.google.com/g/2005';"

            XmlRole {
                name: "title"
                query: "title/string()"
            }
            XmlRole {
                name: "fullName"
                query: "gd:name/gd:fullName/string()"
            }
            XmlRole {
                name: "phoneNumber1"
                query: "gd:phoneNumber[1]/string()"
            }
            XmlRole {
                name: "phoneNumber2"
                query: "gd:phoneNumber[2]/string()"
            }
            XmlRole {
                name: "phoneNumber3"
                query: "gd:phoneNumber[3]/string()"
            }

            onStatusChanged: function (status) {
                if (status == XmlListModel.Null) {
                    console.log("Null")
                }
                if (status == XmlListModel.Ready) {
                    console.log("Ready")
                    console.log(count)
                    sortedModel.sort()
                }
                if (status == XmlListModel.Loading) {
                    console.log("Loading")
                }
                if (status == XmlListModel.Error) {
                    console.log("Error")
                    console.log(errorString())
                }
            }
        }

        SortingModel {
            id: sortedModel
            model: contactsModel

            delegate: Row {
                width: contactsList.width
                height: childrenRect.height
                Rectangle {
                    color: "lightgrey"
                    width: parent.width
                    height: childrenRect.height

                    Column {
                        padding: 5
                        TextEdit {
                            id: titleTextEdit
                            text: title ? title : fullName
                            readOnly: true
                            wrapMode: Text.WordWrap
                            selectByMouse: true
                            font.bold: true
                        }
                        TextEdit {
                            text: phoneNumber1
                            readOnly: true
                            wrapMode: Text.WordWrap
                            selectByMouse: true
                        }
                        TextEdit {
                            text: phoneNumber2
                            readOnly: true
                            wrapMode: Text.WordWrap
                            selectByMouse: true
                        }
                        TextEdit {
                            text: phoneNumber3
                            readOnly: true
                            wrapMode: Text.WordWrap
                            selectByMouse: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            googlecontacts.callSignal(phoneNumber1)
                        }
                    }
                }
            }
        }

        ListView {
            id: contactsList
            anchors.fill: parent
            spacing: 5
            model: sortedModel

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }
        }
    }

    StackView {
        id: stackView
        initialItem: waitingPage
        anchors.fill: parent
    }

    RoundButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20

        id: toolButton
        icon.name: "window-close"
        icon.color: "transparent"
        visible: stackView.depth > 1
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        onClicked: {
            if (stackView.depth > 1) {
                stackView.pop()
            }
        }
    }
}
