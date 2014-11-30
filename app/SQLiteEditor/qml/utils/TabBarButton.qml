import QtQuick 2.2
import "../utils" as Utils
Rectangle {
    id: _root

    signal clicked
    property alias icon : _BaseIcon.source
    property alias iconWidth : _BaseIcon.width
    property alias iconObject : _BaseIcon
    readonly property bool isActive : root.activeButton === this

    property variant theme : root.theme

    width: 120
    height: 100
    border { width: 1; color: theme.borderColor }
    color: !isActive ? (!_MouseArea.pressed ?
                            theme.backgroundDefaultColor :
                            theme.backgroundPressedColor) : theme.backgroundActiveColor

    Utils.BaseIcon {
        id: _BaseIcon
        anchors.centerIn: parent
        width: 54
        color: !isActive ? (!_MouseArea.pressed ?
                                theme.iconDefaultColor :
                                theme.iconPressedColor) : theme.iconActiveColor
        transformOrigin: Item.Center
        Fill { }
    }

    MouseArea {
        id: _MouseArea
        anchors.fill: parent
        onClicked: _root.clicked()
    }
}
