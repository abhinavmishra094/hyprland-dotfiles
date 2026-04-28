import "../../components"
import "../../theme"
import QtQuick
import Quickshell.Hyprland

Chip {
    implicitWidth: title.implicitWidth + Theme.chipPadding * 2

    Text {
        id: title

        anchors.fill: parent
        anchors.leftMargin: Theme.chipPadding
        anchors.rightMargin: Theme.chipPadding
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

}
