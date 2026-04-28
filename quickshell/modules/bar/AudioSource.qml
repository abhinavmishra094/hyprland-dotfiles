import "../../components"
import "../../theme"
import QtQuick
import Quickshell.Services.Pipewire

Chip {
    id: root

    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sourceAudio: source ? source.audio : null

    function sourceText() {
        if (!root.sourceAudio)
            return " --%";

        if (root.sourceAudio.muted)
            return " Muted";

        return ` ${Math.round(root.sourceAudio.volume * 100)}%`;
    }

    flatLeft: true
    implicitWidth: label.implicitWidth + Theme.chipPadding * 2

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    Text {
        id: label

        anchors.centerIn: parent
        text: root.sourceText()
        color: Theme.microphone
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton && root.sourceAudio)
                root.sourceAudio.muted = !root.sourceAudio.muted;

        }
        onWheel: function(wheel) {
            if (!root.sourceAudio)
                return ;

            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            const nextVolume = Math.max(0, Math.min(1.5, root.sourceAudio.volume + delta));
            root.sourceAudio.volume = nextVolume;
        }
    }

}
