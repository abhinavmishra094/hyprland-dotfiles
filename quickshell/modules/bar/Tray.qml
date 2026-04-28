import "../../components"
import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Chip {
    id: root

    required property var panelWindow

    implicitWidth: row.implicitWidth + Theme.chipPadding * 2

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: Theme.chipPadding
        anchors.rightMargin: Theme.chipPadding
        spacing: Theme.traySpacing

        Repeater {
            model: SystemTray.items

            delegate: Item {
                required property var modelData

                function panelPoint(localX, localY) {
                    const target = root.panelWindow.contentItem || root.panelWindow;
                    return mapToItem(target, localX, localY);
                }

                implicitWidth: Theme.trayIconSize
                implicitHeight: Theme.trayIconSize

                Image {
                    anchors.fill: parent
                    source: modelData ? modelData.icon : ""
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        if (!modelData)
                            return ;

                        if (mouse.button === Qt.LeftButton) {
                            if (modelData.onlyMenu && modelData.hasMenu) {
                                const point = parent.panelPoint(0, parent.height);
                                modelData.display(root.panelWindow, point.x, point.y);
                            } else {
                                modelData.activate();
                            }
                        } else if (mouse.button === Qt.MiddleButton) {
                            modelData.secondaryActivate();
                        } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                            const point = parent.panelPoint(0, parent.height);
                            modelData.display(root.panelWindow, point.x, point.y);
                        }
                    }
                    onWheel: function(wheel) {
                        if (!modelData)
                            return ;

                        if (wheel.angleDelta.y !== 0)
                            modelData.scroll(wheel.angleDelta.y, false);

                    }
                }

            }

        }

    }

}
