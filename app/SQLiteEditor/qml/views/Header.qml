import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    height: 40
    gradient: theme.headerGradient
    radius: theme.windowRadius

    MouseArea {
        anchors.fill: parent
        property int _x
        property int _y
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


    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        layoutDirection: Qt.RightToLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        Button {
            text: "Open Database"
            onClicked: {
                 fileDialog.open()
            }
        }

        Button {
            text: "Resize Contents"
            onClicked: {
                _TableView.visible = false
                _TableView.resizeColumnsToContents()
                _TableView.visible = true
            }
        }

        Button {
            text: "All Table Counts"
            onClicked: {
                _ListView_Tables.getAllTableRowCounts()
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
