import "../../components"
import "../../theme"
import QtQuick
import Quickshell

Chip {
    id: root

    required property var panelWindow

    textColor: Theme.clock
    flatRight: true
    implicitWidth: label.implicitWidth + Theme.chipPadding * 2

    ClockDashboard {
        id: dashboard

        anchorItem: root
        panelWindow: root.panelWindow
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    Text {
        id: label

        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "HH:mm:ss   dd-MM-yyyy")
        color: Theme.clock
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: dashboard.open = !dashboard.open
    }

}
