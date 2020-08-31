import QtQuick 2.5
import QtQuick.Controls 2.4

ToolBar {
    contentHeight: toolButton.implicitHeight

    ToolButton {
        id: toolButton
        text: "\u25C0"
        visible: stackView.depth > 1
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        onClicked: {
            if (stackView.depth > 1) {
                stackView.pop()
            }
        }
    }

    Label {
        text: stackView.currentItem.title
        anchors.centerIn: parent
    }
}
