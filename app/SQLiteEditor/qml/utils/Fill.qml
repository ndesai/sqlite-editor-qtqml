import QtQuick 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: "#00FEAA"
    opacity: 0.5
    visible: superRoot.showFills
    border { width: this === superRoot.activeObject ? 4 : 0; color: "#ffffff" }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "transparent"
        border { width: root.border.width; color: "#000000" }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: superRoot.activeObject = root
    }
}
