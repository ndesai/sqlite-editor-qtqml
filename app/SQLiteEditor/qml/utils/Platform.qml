import QtQuick 2.0

SafeLoader {
    id: root
    states: [
        State {
            when: Qt.platform.os === "ios"
            PropertyChanges {
                target: root
                source: "PlatformiOS.qml"
            }
        }
    ]
}
