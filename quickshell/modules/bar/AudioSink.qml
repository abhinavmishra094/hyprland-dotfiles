import "../../components"
import "../../theme"
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Chip {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var sinkAudio: sink ? sink.audio : null

    function sinkIcon() {
        if (!root.sinkAudio)
            return "🔈";

        if (root.sinkAudio.muted)
            return "🔇";

        const description = ((root.sink && (root.sink.description || root.sink.nickname || root.sink.name)) || "").toLowerCase();
        if (description.includes("headphone") || description.includes("headset"))
            return "🎧";

        return "🔈";
    }

    function sinkText() {
        if (!root.sinkAudio)
            return "🔈 --%";

        if (root.sinkAudio.muted)
            return "🔇 Muted";

        return `${root.sinkIcon()} ${Math.round(root.sinkAudio.volume * 100)}%`;
    }

    flatLeft: true
    flatRight: true
    implicitWidth: label.implicitWidth + Theme.chipPadding * 2

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Text {
        id: label

        anchors.centerIn: parent
        text: root.sinkText()
        color: Theme.volume
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton)
                Quickshell.execDetached(["pavucontrol"]);
            else if (mouse.button === Qt.RightButton && root.sinkAudio)
                root.sinkAudio.muted = !root.sinkAudio.muted;
        }
        onWheel: function(wheel) {
            if (!root.sinkAudio)
                return ;

            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            const nextVolume = Math.max(0, Math.min(1.5, root.sinkAudio.volume + delta));
            root.sinkAudio.volume = nextVolume;
        }
    }

}
