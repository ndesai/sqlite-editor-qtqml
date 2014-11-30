import QtQuick 2.3

Loader {
    id: root
    signal opened
    signal closed

    property alias controller : _Connections.target
    property bool loadAsNeeded : false
    property bool loaded : false
    property variant contentComponent

    anchors.fill: parent
    visible: false

    ClickGuard { }

    Connections {
        id: _Connections
        target: null
        ignoreUnknownSignals: true
        onHideAllPages: {
            console.log("hide all pages")
            root.closed()
            root.visible = false
        }
    }

    onLoaded: {
        loaded = true
        _show()
    }

    function show()
    {
        if(!loaded && loadAsNeeded)
        {
            // load the component
            if(contentComponent)
                sourceComponent = contentComponent
        } else
        {
            _show()
        }
    }

    function _show()
    {
        root.opened()
        visible = true
    }
}
