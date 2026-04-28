import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var panelWindow

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row

        anchors.fill: parent
        spacing: 0

        ClockChip {
            panelWindow: root.panelWindow
            Layout.alignment: Qt.AlignVCenter
        }

        AudioGroup {
            Layout.alignment: Qt.AlignVCenter
        }

    }

}
