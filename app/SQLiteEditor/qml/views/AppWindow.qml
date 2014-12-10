import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: root

    property url activeDatabase

    objectName: "mainWindow"
    visible: true
    width: 1424
    height: 768
    title: qsTr("SQLite Editor")
    color: "transparent"
    flags: Qt.FramelessWindowHint

    Rectangle {
        anchors.fill: parent
        color: theme.lightgray
        radius: theme.windowRadius
    }

    Settings {
        property alias url: root.activeDatabase
    }

    property alias fileDialog : _FileDialog
    FileDialog {
        id: _FileDialog
        title: "Please choose a file"
        nameFilters: [ "SQLite3 Databases (*.db *.sqlite3 *.sqlite *.sql3)", "All files (*)" ]
        onAccepted: {
            activeDatabase = fileUrl
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                shortcut: StandardKey.Open
                onTriggered: {
                    fileDialog.open()
                }
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    property alias theme : _Theme

    Theme {
        id: _Theme
    }

}
