import QtQuick 2.3
import "../views" as Views


Item {
    id: root

    signal itemClicked(variant itemObject)
    property alias model : _Repeater.model


    function open()
    {
        _StateGroup_Selector.state = "open"
    }

    function close()
    {
        _StateGroup_Selector.state = ""
    }

    anchors.fill: parent

    Rectangle {
        id: _Fulltone
        anchors.fill: parent
        color: "#222222"
        opacity: 0.0
        visible: opacity>0
        ClickGuard {
            onClicked: {
                root.close()
            }
        }
    }

    Item {
        id: _Item_SelectorPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: __theme.dp(16)
        anchors.leftMargin: anchors.rightMargin
        anchors.bottom: parent.bottom
        height: __theme.dp(300)
        Rectangle {
            id: _Choose
            radius: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: _Cancel.top
            anchors.bottomMargin: __theme.dp(16)
            height: _Column.height
            Column {
                id: _Column
                width: parent.width
                height: childrenRect.height
                Repeater {
                    id: _Repeater
                    Item {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: __theme.dp(87)
                        Views.Label {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: modelData.text
                        }
                        ClickGuard {
                            onClicked: {
                                log.jsonDump(root, modelData)
                                root.close()
                                root.itemClicked(modelData)
                            }
                        }
                        Rectangle {
                            color: "#dddddd"
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 1
                            anchors.bottom: parent.bottom
                            visible: index !== root.model.length
                        }
                    }
                }
            }
        }
        Rectangle {
            id: _Cancel
            radius: __theme.dp(5)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: __theme.dp(17)
            height: __theme.dp(88)
            Views.Label {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Cancel")
                font.weight: Font.DemiBold
            }
        }
        visible: false
        anchors.bottomMargin: -1*height
        StateGroup {
            id: _StateGroup_Selector
            states: [
                State {
                    name: "open"
                    PropertyChanges {
                        target: _Item_SelectorPanel
                        anchors.bottomMargin: 0
                        visible: true
                    }
                    PropertyChanges {
                        target: _Fulltone
                        opacity: 0.25
                    }
                }
            ]
            transitions: [
                Transition {
                    from: ""
                    to: "open"
                    SequentialAnimation {
                        PropertyAction {
                            targets: [_Item_SelectorPanel, _Fulltone];
                            property: "visible"
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: _Fulltone
                                property: "opacity"
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                target: _Item_SelectorPanel
                                property: "anchors.bottomMargin"
                                duration: 250
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                },
                Transition {
                    from: "open"
                    to: ""
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: _Fulltone
                                property: "opacity"
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                target: _Item_SelectorPanel
                                property: "anchors.bottomMargin"
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                        PropertyAction {
                            targets: [_Item_SelectorPanel, _Fulltone];
                            property: "visible"
                        }
                    }
                }
            ]
        }
    }

}
