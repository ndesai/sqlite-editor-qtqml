import QtQuick 2.3
import QtQuick.Controls 1.2
import st.app 1.0 as AppStreet

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right

    height: 40

    gradient: theme.headerGradient
    radius: theme.windowRadius

    MouseArea {
        property int _x
        property int _y

        anchors.fill: parent

        onPressed: {
            _x = mouse.x
            _y = mouse.y
        }
        onPositionChanged: {
            superRoot.x = superRoot.x + mouse.x - _x
            superRoot.y = superRoot.y + mouse.y - _y
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        height: 14
        spacing: 8

        YosemiteButton {
            color: theme.yosemite.exitColor
            onClicked: {
                Qt.quit()
            }
        }

        YosemiteButton {
            color: theme.yosemite.minimizeColor
            onClicked: {
                superRoot.showMinimized()
            }
        }

        YosemiteButton {
            color: theme.yosemite.expandColor
            onClicked: {
                superRoot.showFullScreen()
            }
        }
    }

    Label {
        anchors.centerIn: parent

        width: 500

        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        styleColor: theme.white
        style: Text.Raised
        text: [superRoot.title, superRoot.activeDatabase.toString().replace("file://", "")].filter(Boolean).join(" - ")
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        layoutDirection: Qt.RightToLeft
        spacing: 10

        Button {
            height: 30
            text: "Open Database"
            onClicked: {
                 fileDialog.open()
            }
        }

        Button {
            height: 30
            text: "Resize Contents"
            onClicked: {
                _TableView.visible = false
                _TableView.resizeColumnsToContents()
                _TableView.visible = true
            }
        }

        Button {
            height: 30
            text: "All Table Counts"
            onClicked: {
                _ListView_Tables.getAllTableRowCounts()
            }
        }

        Item {
            width: 30
            height: 30

            visible: _SQLite.status != AppStreet.SQLite.Ready

            Canvas {
                id: _Canvas_Spinner
                anchors.fill: parent
//                renderTarget: Canvas.FramebufferObject
//                renderStrategy: Canvas.Threaded
                property int centerX : width/2
                property int centerY : height/2
                property int radius : width / 4
                property double degree : 290


                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = theme.text
                    ctx.beginPath()
                    ctx.lineWidth = 2
                    ctx.arc(centerX, centerY, radius, 0, (degree * Math.PI / 180));
                    ctx.stroke()
                }

//                layer.enabled: true
//                layer.smooth: true

                opacity: 0.5

                SequentialAnimation {
                    loops: Animation.Infinite
                    running: visible
                    NumberAnimation {
                        target: _Canvas_Spinner
                        property: "rotation"
                        from: 0; to: 360;
                        duration: 1200
                    }
                }
            }
        }
    }


    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: 1
        color: theme.headerAccent
    }
}
