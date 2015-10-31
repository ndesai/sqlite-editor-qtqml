import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.0
import "views" as Views
import "utils" as Utils
import QtQuick.Controls.Styles 1.2
import st.app 1.0 as AppStreet


Views.AppWindow {
    id: superRoot

    property QtObject queries : QtObject {
        readonly property string tableView : "SELECT * FROM sqlite_master WHERE type = 'table' OR type = 'view' ORDER BY type"
        property string fat : "SELECT * FROM Track tra JOIN (SELECT * FROM Album alb JOIN Artist art ON art.ArtistId = alb.ArtistId) albart ON tra.AlbumId = albart.AlbumId"
    }

    AppStreet.SQLite {
        id: _SQLite
        databasePath: superRoot.activeDatabase
        onResultsReady: {
            console.log("ready = " + query)
            console.log("results", Object.keys(results))
            if(query == queries.tableView)
            {
                _ListView_Tables.model = results
            } else
            {
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
                    image : "img/icon-tables.png"
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

            function getAllTableRowCounts()
            {

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

    Item {
        id: _Item_Container
        anchors.top: _Header.bottom
        anchors.left: _Rectangle_Tables.right
        anchors.right: _Item_RowDetail.left
        anchors.bottom: parent.bottom

        TableView {
            id: _TableView
            property string tableViewColumnBuilder : "import QtQuick 2.3; import QtQuick.Controls 1.0; import QtQuick.Layouts 1.0; TableViewColumn { role: \"%roleName%\"; title: role; width: 100 }"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: _TextArea_Query.top

            onClicked: {
                _TextArea_RowDetail.text = JSON.stringify(_TableView.model[row], null, 2)
            }

            onDoubleClicked: {
                $.saveTextToClipboard(JSON.stringify(_TableView.model[row], null, 2))
            }

            function prepareAndSetModel(result)
            {
                if(result.length === 0)
                {
                    _TableView.model = []
                    return
                }

                var columns = Object.keys(result[0])

                for(var i = _TableView.columnCount - 1; i >= 0; i--)
                {
                    _TableView.removeColumn(i)
                }

                for(var j = 0; j < columns.length; j++)
                {
                    var c = Qt.createQmlObject(_TableView.tableViewColumnBuilder.replace(/%roleName%/g, columns[j]), _TableView, "")
                    _TableView.addColumn(c)
                }

                _TableView.model = result

                _TableView.resizeColumnsToContents()
            }

            style: TableViewStyle {
                id: _TableViewStyle
                backgroundColor: theme.white
                alternateBackgroundColor: theme.superlightgray
                textColor: theme.text
                highlightedTextColor: theme.black
                corner: Item { }
                frame: Item { }
                rowDelegate: Rectangle {
                    height: 40
                    color: styleData.alternate ? _TableViewStyle.alternateBackgroundColor : _TableViewStyle.backgroundColor
                    Utils.AccentBottom {
                        color: theme.headerAccent
                        opacity: 0.3
                    }
                }
                headerDelegate: Rectangle {
                    color: theme.white
                    height: 20
                    clip: true
                    Utils.AccentBottom {
                        color: theme.headerAccent
                    }
                    Utils.AccentRight {
                        color: theme.headerAccent
                        opacity: 0.3
                    }
                    Text {
                        width: parent.width
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        font.pixelSize: 10
                        elide: Text.ElideRight
                        color: theme.text
                        text: String(styleData.value)
                    }
                }
            }

            itemDelegate: Item {
                width: 100
                clip: true

                Utils.AccentRight {
                    color: theme.headerAccent
                    opacity: 0.3
                }

                Views.Label {
                    id: _Text
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    color: styleData.textColor
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                    width: parent.width
                    text: String(styleData.value)
                }
            }
        }

        TextArea {
            id: _TextArea_Query
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: parent.width
            height: 150
            font.family: "Courier"
            style: TextAreaStyle {
                frame: Item { }
            }

            Button {
                id: _Button_Query
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                text: qsTr("Execute Query")
                onClicked: {
                    _SQLite.executeQuery(_TextArea_Query.text)
                }
            }
        }
    }

    Item {
        id: _Item_RowDetail
        width: 400
        anchors.top: _Header.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        TextArea {
            id: _TextArea_RowDetail
            anchors.fill: parent
            style: TextAreaStyle {
                frame: Item { }
            }
            font.family: "Courier"
        }
    }
}
