import "../theme"
import QtQuick

Rectangle {
    id: chip

    property color chipColor: Theme.panel
    property color borderColor: Theme.border
    property color textColor: Theme.foreground
    property bool hovered: false
    property bool flatLeft: false
    property bool flatRight: false

    implicitHeight: Theme.chipHeight
    radius: Theme.radius
    color: hovered ? Theme.hover : chipColor
    border.width: Theme.borderWidth
    border.color: borderColor
    topLeftRadius: flatLeft ? 0 : radius
    bottomLeftRadius: flatLeft ? 0 : radius
    topRightRadius: flatRight ? 0 : radius
    bottomRightRadius: flatRight ? 0 : radius
}
