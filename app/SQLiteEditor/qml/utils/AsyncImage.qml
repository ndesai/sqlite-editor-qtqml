import QtQuick 2.3

Image {
    property double finalOpacity : 1.0
    property bool ready : status===Image.Ready
    cache: false;
    asynchronous: true
    opacity: 0
    onStatusChanged: {
        if(status == Image.Ready)
        {
            opacity = finalOpacity;
        }
    }
    Behavior on opacity { NumberAnimation{ duration: 150; } }
}
