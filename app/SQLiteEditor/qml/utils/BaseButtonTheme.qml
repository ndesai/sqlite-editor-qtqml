import QtQuick 2.3

QtObject {
    id: root
    property color backgroundDefaultColor : "#000000"
    property color backgroundPressedColor : backgroundDefaultColor
    property color backgroundActiveColor : backgroundDefaultColor
    property color iconDefaultColor : "#ffffff"
    property color iconPressedColor : iconDefaultColor
    property color iconActiveColor : iconDefaultColor

    property color borderColor : "#111111"

    property int colorAnimationDuration : 50
}
