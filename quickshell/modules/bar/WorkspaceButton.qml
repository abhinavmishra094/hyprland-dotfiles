import "../../components"
import "../../theme"
import QtQuick

Rectangle {
    id: workspaceButton

    required property string label
    property bool active: false
    property bool focused: false
    property bool urgent: false
    property bool hovered: false

    signal clicked()

    implicitWidth: labelText.implicitWidth + 18
    implicitHeight: Theme.chipHeight - 10
    radius: Theme.radius
    color: urgent ? Theme.urgentWorkspace : (hovered || focused ? Theme.focusedWorkspace : "transparent")

    Text {
        id: labelText

        anchors.centerIn: parent
        text: workspaceButton.label
        color: urgent ? Theme.urgentWorkspaceForeground : ((active || focused || hovered) ? Theme.focusedWorkspaceForeground : Theme.mutedForeground)
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: workspaceButton.hovered = true
        onExited: workspaceButton.hovered = false
        onClicked: workspaceButton.clicked()
    }

}
