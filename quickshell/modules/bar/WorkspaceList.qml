import "../../components"
import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

Chip {
    id: root

    property var occupiedWorkspaceNames: []

    function shouldShowWorkspace(workspace) {
        if (!workspace || !workspace.name || workspace.name.startsWith("special:"))
            return false;

        return workspace.active || workspace.focused || occupiedWorkspaceNames.indexOf(workspace.name) !== -1;
    }

    function refreshOccupiedWorkspaces() {
        workspaceStateProcess.running = false;
        workspaceStateProcess.running = true;
    }

    implicitWidth: row.implicitWidth + 10
    hovered: false
    Component.onCompleted: refreshOccupiedWorkspaces()

    Connections {
        function onRawEvent() {
            root.refreshOccupiedWorkspaces();
        }

        target: Hyprland
    }

    Process {
        id: workspaceStateProcess

        command: ["sh", "-c", "hyprctl workspaces -j 2>/dev/null || echo '[]'"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text.trim() || "[]");
                    root.occupiedWorkspaceNames = parsed.filter((workspace) => {
                        return workspace && workspace.name && !workspace.name.startsWith("special:") && (workspace.windows || 0) > 0;
                    }).map((workspace) => {
                        return workspace.name;
                    });
                } catch (error) {
                    root.occupiedWorkspaceNames = [];
                }
            }
        }

    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: root.refreshOccupiedWorkspaces()
    }

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: Theme.innerSpacing

        Repeater {
            model: Hyprland.workspaces

            delegate: WorkspaceButton {
                required property var modelData

                visible: root.shouldShowWorkspace(modelData)
                label: modelData ? modelData.name : ""
                active: modelData ? modelData.active : false
                focused: modelData ? modelData.focused : false
                urgent: modelData ? modelData.urgent : false
                onClicked: {
                    if (modelData)
                        modelData.activate();

                }
            }

        }

    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                Hyprland.dispatch("workspace -1");
            else if (wheel.angleDelta.y < 0)
                Hyprland.dispatch("workspace +1");
        }
    }

}
