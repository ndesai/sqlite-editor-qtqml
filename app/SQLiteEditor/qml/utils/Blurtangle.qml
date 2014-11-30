import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    id: root
    property color color: "#222222"
    property Item attachTo
    property alias blurOffset: _ShaderEffectSource.yOffset
    property alias radius: _Rectangle.radius
    Rectangle {
        id: _Rectangle
        anchors.fill: _FastBlur
        color: root.color
    }
    FastBlur {
        id: _FastBlur
        height: root.height
        width: root.width
        radius: 100
        opacity: 0.30
        source: ShaderEffectSource {
            id: _ShaderEffectSource
            property int yOffset : 0
            sourceItem: root.attachTo ? root.attachTo : _Dummy
            sourceRect: Qt.rect(0,yOffset,root.width,_FastBlur.height)
        }
    }
    Item {
        id: _Dummy
    }
}
