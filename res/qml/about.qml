import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

ScrollView {
    contentWidth: width

    Column {
        width: parent.width

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "karunit_google_contacts"
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "<p>xavi-b/karunit_google_contacts</p>" + "LGPL 3.0 License"
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "QGoogleWrapper"
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "<p>xavi-b/QGoogleWrapper</p>" + "LGPL 3.0 License"
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "qzxing"
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: leftPadding
            text: "<p>ftylitak/qzxing</p>" + "Apache 2.0 License"
        }
    }
}
