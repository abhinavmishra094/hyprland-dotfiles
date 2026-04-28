import "../../components"
import "../../theme"
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

Chip {
    id: root

    property string activeTitle: ""

    function refreshTitle() {
        activeWindowProcess.running = false;
        activeWindowProcess.running = true;
    }

    implicitWidth: title.implicitWidth + Theme.chipPadding * 2
    Component.onCompleted: refreshTitle()

    Connections {
        function onRawEvent() {
            root.refreshTitle();
        }

        target: Hyprland
    }

    Process {
        id: activeWindowProcess

        command: ["sh", "-c", "hyprctl activewindow -j 2>/dev/null || echo '{}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text.trim() || "{}");
                    root.activeTitle = parsed && parsed.title ? parsed.title : "";
                } catch (error) {
                    root.activeTitle = "";
                }
            }
        }

    }

    Text {
        id: title

        anchors.fill: parent
        anchors.leftMargin: Theme.chipPadding
        anchors.rightMargin: Theme.chipPadding
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: root.activeTitle
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

}
