import "../../components"
import "../../theme"
import QtQuick
import Quickshell

Chip {
    id: root

    required property var panelWindow

    textColor: Theme.clock
    flatRight: true
    implicitWidth: content.implicitWidth + Theme.chipPadding * 2

    ClockDashboard {
        id: dashboard

        anchorItem: root
        panelWindow: root.panelWindow
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 6

        Text {
            text: Qt.formatDateTime(clock.date, "HH:mm:ss")
            color: Theme.clock
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Theme.fontWeight
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: ""
            color: Theme.clock
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Theme.fontWeight
            anchors.verticalCenter: parent.verticalCenter
            transform: Translate {
                y: -1
            }
        }

        Text {
            text: Qt.formatDateTime(clock.date, "dd-MM-yyyy")
            color: Theme.clock
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.weight: Theme.fontWeight
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: dashboard.open = !dashboard.open
    }

}
