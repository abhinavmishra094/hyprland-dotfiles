import "../../components"
import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Chip {
    id: root

    function workspaceByName(name) {
        const workspaces = Hyprland.workspaces;
        if (!workspaces)
            return null;

        for (let i = 0; i < workspaces.count; i++) {
            const workspace = workspaces.get(i);
            if (workspace && workspace.name === name)
                return workspace;

        }
        return null;
    }

    function isActiveName(name) {
        const workspace = workspaceByName(name);
        return workspace ? workspace.active : Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.name === name;
    }

    function isFocusedName(name) {
        const workspace = workspaceByName(name);
        return workspace ? workspace.focused : false;
    }

    function isUrgentName(name) {
        const workspace = workspaceByName(name);
        return workspace ? workspace.urgent : false;
    }

    function activateName(name) {
        const workspace = workspaceByName(name);
        if (workspace) {
            workspace.activate();
            return ;
        }
        Hyprland.dispatch(`workspace ${name}`);
    }

    implicitWidth: row.implicitWidth + 10
    hovered: false

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: Theme.innerSpacing

        WorkspaceButton {
            label: "1"
            active: root.isActiveName("1")
            focused: root.isFocusedName("1")
            urgent: root.isUrgentName("1")
            onClicked: root.activateName("1")
        }

        WorkspaceButton {
            label: "2"
            active: root.isActiveName("2")
            focused: root.isFocusedName("2")
            urgent: root.isUrgentName("2")
            onClicked: root.activateName("2")
        }

        Repeater {
            model: Hyprland.workspaces

            delegate: WorkspaceButton {
                required property var modelData

                visible: modelData && modelData.name !== "1" && modelData.name !== "2" && !modelData.name.startsWith("special:")
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
