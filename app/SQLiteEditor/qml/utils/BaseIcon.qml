import QtQuick 2.0
import QtGraphicalEffects 1.0 as QGE

Item {
    property alias source: _Image.source
    property alias color : _ColorOverlay.color
//    anchors.centerIn: parent
    width: 44
    height: _Image.height
    layer.smooth: true
    layer.enabled: true
    Image {
        id: _Image
        anchors.left: parent.left
        anchors.right: parent.right
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 2*width; sourceSize.height: 2*height
        smooth: true
        visible: false
    }
    QGE.ColorOverlay {
        id: _ColorOverlay
        anchors.fill: parent
        source: _Image
        color: "#000000"
    }
}
