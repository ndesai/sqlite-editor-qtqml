import QtQuick 2.3
import "../views/" as Views
import "../utils/" as Utils
Item {
    id: root

    signal tabClicked(variant tabObject)
    signal hideAllPages

    property bool enabled : true
    property variant tabBarModel : []
    property variant activeButton : _Repeater_TabBar.count > 0 ? _Repeater_TabBar.itemAt(0) : { }

    property alias theme : _BaseButtonTheme

    Utils.BaseButtonTheme {
        id: _BaseButtonTheme
        backgroundDefaultColor: "#f3f3f3"
        backgroundPressedColor: "#e0e0e0"
        backgroundActiveColor: "#81c343"
        iconDefaultColor: "#222222"
        iconPressedColor: "#111111"
        iconActiveColor: "#ffffff"
        borderColor: "transparent"
    }

    Row {
        id: _Row_TabBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        Repeater {
            id: _Repeater_TabBar
            model: root.tabBarModel
            property variant responder : root.activeButton
            delegate: TabBarButton {
                property variant dataModel : modelData
                width: Math.floor(root.width / root.tabBarModel.length)
                icon: modelData.icon
                onClicked: {
                    root.tabClicked(modelData)
                    root.activeButton = this
                    root.hideAllPages()
                    try {
                        eval(modelData.sourceComponent).show()
                    } catch (ex)
                    {
                        console.trace()
                        console.error(ex)
                    }
                }
            }
            Component.onCompleted: if(count > 0) itemAt(0).clicked()
        }
    }

    Utils.ClickGuard {
        visible: !root.enabled
    }

    function showView(sourceComponent)
    {
        for(var i = 0; i < _Repeater_TabBar.count; i++)
        {
            var obj = _Repeater_TabBar.itemAt(i)
            if(obj.dataModel.sourceComponent === sourceComponent)
            {
                _Repeater_TabBar.itemAt(i).clicked()
            }
        }
    }
}
