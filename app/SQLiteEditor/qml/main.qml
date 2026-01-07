import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.qmlmodels
import "views" as Views
import "utils" as Utils
import st.app  as AppStreet

Views.AppWindow {
    id: superRoot

    property QtObject queries : QtObject {
        readonly property string tableView : "SELECT * FROM sqlite_master WHERE type = 'table' OR type = 'view' ORDER BY type"
    }

    AppStreet.SQLite {
        id: _SQLite
        databasePath: superRoot.activeDatabase
        onResultsReady: {
            console.log("ready = " + query)
            if (query == queries.tableView) {
                _ListView_Tables.model = results
            } else {
                _TableView.prepareAndSetModel(results)
            }
        }
        onDatabaseOpened: {
            executeQuery(queries.tableView)
        }
    }

    // GUI
    Views.Header {
        id: _Header
        z: theme.z.header
    }

    Rectangle {
        id: _Rectangle_Navigation

        anchors.top: _Header.bottom
        anchors.bottom: parent.bottom

        width: 72
        color: theme.asphalt

        ListView {
            id: _ListView_Navigation

            anchors.fill: parent

            interactive: false

            model: [
                {
                    image : "qrc:/qml/img/icon-tables.png"
                }
            ]

            delegate: Rectangle {
                width: ListView.view.width
                height: width
                color: ListView.view.currentIndex === index ? Qt.darker(theme.asphalt) : theme.asphalt
                Utils.BaseIcon {
                    anchors.centerIn: parent
                    width: 32
                    source: modelData.image
                    color: theme.lightblue
                }
            }
        }
    }

    Rectangle {
        id: _Rectangle_Tables
        anchors.top: _Header.bottom
        anchors.bottom: parent.bottom
        anchors.left: _Rectangle_Navigation.right
        width: 200
        color: theme.white

        Utils.AccentRight {
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                property int _x : 0
                onPressed: {
                    _x = mouse.x
                }
                onPositionChanged: {
                    _Rectangle_Tables.width = Math.max(200, _Rectangle_Tables.width + mouse.x - _x)
                }
            }
            color: "transparent"
            width: 4
            z: 3
        }

        Utils.Blurtangle {
            id: _Item_TablesHeader
            anchors.top: parent.top
            height: 30
            width: parent.width
            attachTo: _ListView_Tables
            color: "#ffffff"

            Utils.AccentBottom {
                color: theme.headerAccent
            }

            Views.Label {
                anchors.fill: parent
                anchors.margins: 8
                text: qsTr("Tables")
                font.capitalization: Font.AllUppercase
                font.bold: true
                font.pixelSize: 12
            }
            z: 2
        }

        ListView {
            id: _ListView_Tables

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            currentIndex: -1
            z: 1

            function getAllTableRowCounts() {

            }

            onCurrentIndexChanged: {
                _TextArea_Query.text = "SELECT * FROM " + currentItem.dataModel.name
                _Button_Query.clicked()
            }

            header: Item {
                width: 1
                height: _Item_TablesHeader.height
            }


            delegate: Rectangle {
                property variant dataModel : modelData || {}
                width: ListView.view.width
                height: 30
                color: ListView.view.currentIndex === index ? theme.dirtywhite : "transparent"
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.right: _Rectangle_Count.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: theme.blue
                        anchors.verticalCenter: _Text_TableName.verticalCenter
                    }
                    Views.Label {
                        id: _Text_TableName
                        height: 20
                        text: modelData.name
                    }
                }
                Rectangle {
                    id: _Rectangle_Count
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(12, _Text_TableRowCount.paintedWidth + 10)
                    height: 12
                    radius: 6
                    color: theme.lightgray
                    Views.Label {
                        id: _Text_TableRowCount
                        anchors.centerIn: parent
                        font.pixelSize: 10
                        font.bold: true
                        text: modelData.count || ""
                        color: theme.text
                    }
                    visible: _Text_TableRowCount.text !== ""
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: parent.ListView.view.currentIndex = index
                }
            }
        }
    }

    Pane {
        id: _Item_Container
        anchors.top: _Header.bottom
        anchors.left: _Rectangle_Tables.right
        anchors.right: _Item_RowDetail.left
        anchors.bottom: parent.bottom
        clip: true

        ListView {
            id: _ListView_Columns
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            orientation: ListView.Horizontal
            model: _SQLite.tableModel ? _SQLite.tableModel.columnNames : []
            clip: true
            contentX: _TableView.contentX
            interactive: false

            delegate: Item {
                width: 140
                height: _ListView_Columns.height
                Views.Label {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    verticalAlignment: Text.AlignVCenter
                    text: modelData
                    font.bold: true
                    elide: Text.ElideRight
                    color: theme.black
                    font.pixelSize: theme.fontSizeBody
                }
                Utils.AccentBottom {
                    color: theme.lightgray
                    height: 2
                }
                Utils.AccentRight {
                    color: theme.lightgray
                    width: 3
                }
            }
            z: 2
        }

        TableView {
            id: _TableView
            property string tableViewColumnBuilder : "import QtQuick; import Qt.labs.qmlmodels; TableModelColumn { display: \"%roleName%\" }"
            anchors.top: _ListView_Columns.bottom
            anchors.topMargin: 6
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: _Pane_Query.top
            clip: true
            z: 1

            property int selectedRow: -1

            onSelectedRowChanged: {
                if (selectedRow >= 0 && selectedRow < model.count) {
                    _TextArea_RowDetail.text = JSON.stringify(model.get(selectedRow), null, 2)
                }
            }

            delegate: TextField {
                implicitWidth: 140
                implicitHeight: 36
                horizontalAlignment: Text.AlignHCenter
                text: model.display
                font.bold: row == _TableView.selectedRow
                font.pixelSize: theme.fontSizeBody
                background: null

                Rectangle {
                    anchors.fill: parent
                    color: row%2==0 ? "transparent" : theme.dirtywhite
                    z: -1
                }

                Utils.AccentBottom {
                    color: theme.lightgray
                    height: 2
                }
                Utils.AccentRight {
                    color: theme.lightgray
                    width: 3
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        _TableView.selectedRow = row;
                    }

                    onDoubleClicked: {
                        $.saveTextToClipboard(JSON.stringify(_TableView.model.get(row), null, 2))
                    }
                }
            }

            function prepareAndSetModel(result) {
                if (result.length === 0) {
                    _TableView.model = null
                    return
                }
                _TableView.model = _SQLite.tableModel
            }
        }

        Pane {
            id: _Pane_Query
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.width
            height: 150
            TextArea {
                id: _TextArea_Query
                anchors.fill: parent
                font.family: "Courier"
                z: 2

                Keys.onReturnPressed: {
                    _Button_Query.clicked();
                }

                Button {
                    id: _Button_Query
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 15
                    text: qsTr("Execute Query")
                    onClicked: {
                        _TextArea_Query.text = _TextArea_Query.text.trim();
                        _SQLite.executeQuery(_TextArea_Query.text);
                        _TableView.contentY = 0;
                    }
                }
            }
        }
    }

    Pane {
        id: _Item_RowDetail
        width: 400
        anchors.top: _Header.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        TextArea {
            id: _TextArea_RowDetail
            anchors.fill: parent
            font.bold: true
            font.family: "Courier"
            font.pixelSize: theme.fontSizeBody
        }
    }
}
