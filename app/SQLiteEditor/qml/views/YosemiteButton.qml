import QtQuick 2.0

Rectangle {
    id: root

    property color buttonColor
    signal clicked

    width: 14
    height: width
    radius: width / 2
    color: !_MouseArea.pressed ? buttonColor : theme.shadeColor(buttonColor, -15)

    MouseArea {
        id: _MouseArea
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
