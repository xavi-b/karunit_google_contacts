import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.XmlListModel 2.14
import QZXing 2.3

Item {
    visible: true

    function pendingVerification(verificationUrl: string, userCode: string) {
        qrcode.source = "image://QZXing/encode/" + verificationUrl;
        verificationUrlLabel.text = verificationUrl;
        userCodeLabel.text = userCode;
        stackView.push(connectionPage);
    }

    function authenticated() {
        stackView.push(contactsPage);
    }

    function contactsRequest(contactsXml: string) {
        contactsModel.xml = contactsXml;
    }

    Page {
        id: waitingPage

        header: Header { }

        Label {
            text: qsTr("Waiting for Google Contacts authorization request")
            anchors.fill: parent
        }
    }

    Page {
        id: connectionPage

        header: Header { }

        ColumnLayout {
            anchors.centerIn: parent
            Image {
                id: qrcode
                cache: false;
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

        header: Header { }

        XmlListModel {
            id: contactsModel
            query: "/feed/entry"
            namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
            + "declare namespace gd='http://schemas.google.com/g/2005';"

            XmlRole { name: "title"; query: "title/string()" }
            XmlRole { name: "fullName"; query: "gd:name/gd:fullName/string()" }
            XmlRole { name: "phoneNumber1"; query: "gd:phoneNumber[1]/string()" }
            XmlRole { name: "phoneNumber2"; query: "gd:phoneNumber[2]/string()" }
            XmlRole { name: "phoneNumber3"; query: "gd:phoneNumber[3]/string()" }
        }

        ListView {
            id: contactsList
            anchors.fill: parent
            spacing: 5
            model: contactsModel

            delegate: Row {
                width: 320
                leftPadding: (contactsList.width - width)/2
                height: phoneNumber1 ? childrenRect.height : 0
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
                            console.log("click");
                        }
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: waitingPage
        anchors.fill: parent
    }
}
