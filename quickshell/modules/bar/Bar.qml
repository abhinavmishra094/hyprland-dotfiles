import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: barWindow

    required property var shellScreen

    screen: shellScreen
    color: "transparent"
    aboveWindows: true
    focusable: false
    exclusiveZone: Theme.chipHeight + Theme.outerMargin + 6
    implicitHeight: Theme.chipHeight + Theme.outerMargin + 6

    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        WorkspaceList {
            anchors.left: parent.left
            anchors.leftMargin: Theme.outerMargin
            anchors.top: parent.top
            anchors.topMargin: Theme.outerMargin
        }

        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: Theme.outerMargin
            anchors.top: parent.top
            anchors.topMargin: Theme.outerMargin
            spacing: Theme.innerSpacing

            Tray {
                panelWindow: barWindow
                Layout.alignment: Qt.AlignVCenter
            }

            ClockAudioGroup {
                panelWindow: barWindow
                Layout.alignment: Qt.AlignVCenter
            }

        }

        ActiveWindow {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Theme.outerMargin
            maxWidth: Math.min(560, parent.width - 240)
        }

    }

}
