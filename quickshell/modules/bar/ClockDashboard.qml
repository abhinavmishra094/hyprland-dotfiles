import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var anchorItem
    required property var panelWindow
    property bool open: false
    property date monthDate: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
    property string networkType: "disconnected"
    property string networkName: "Disconnected"
    property string activeInterface: ""
    property int signalStrength: 0
    property string downloadRate: "--"
    property string uploadRate: "--"
    property double lastRxBytes: -1
    property double lastTxBytes: -1
    property double lastSampleMs: 0
    property var wifiRows: []

    function monthTitle() {
        return Qt.formatDateTime(monthDate, "MMMM yyyy");
    }

    function weekdayLabel(index) {
        const labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        return labels[index];
    }

    function monthCell(index) {
        const year = monthDate.getFullYear();
        const month = monthDate.getMonth();
        const firstDay = new Date(year, month, 1);
        const startOffset = firstDay.getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const dayNumber = index - startOffset + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth)
            return ({
            "day": "",
            "today": false
        });

        const today = new Date();
        return ({
            "day": `${dayNumber}`,
            "today": today.getFullYear() === year && today.getMonth() === month && today.getDate() === dayNumber
        });
    }

    function shiftMonth(delta) {
        monthDate = new Date(monthDate.getFullYear(), monthDate.getMonth() + delta, 1);
    }

    function refreshNetwork() {
        activeConnectionProcess.running = false;
        signalProcess.running = false;
        wifiListProcess.running = false;
        trafficProcess.running = false;
        activeConnectionProcess.running = true;
        signalProcess.running = true;
        wifiListProcess.running = true;
        trafficProcess.running = true;
    }

    function formatRate(bytesPerSecond) {
        if (bytesPerSecond >= 1024 * 1024)
            return `${(bytesPerSecond / (1024 * 1024)).toFixed(1)} MB/s`;

        if (bytesPerSecond >= 1024)
            return `${(bytesPerSecond / 1024).toFixed(1)} KB/s`;

        return `${Math.round(bytesPerSecond)} B/s`;
    }

    function networkIcon() {
        if (networkType === "wifi") {
            if (signalStrength >= 80)
                return "󰤨";

            if (signalStrength >= 60)
                return "󰤥";

            if (signalStrength >= 40)
                return "󰤢";

            if (signalStrength >= 20)
                return "󰤟";

            return "󰤯";
        }
        if (networkType === "ethernet")
            return "󰈀";

        return "󰌙";
    }

    function networkLabel() {
        return networkType === "wifi" ? "Wi-Fi" : networkType === "ethernet" ? "Ethernet" : "Disconnected";
    }

    function anchorCenterX() {
        const target = root.panelWindow.contentItem || root.panelWindow;
        const point = root.anchorItem.mapToItem(target, root.anchorItem.width / 2, 0);
        return point.x;
    }

    width: 0
    height: 0
    onOpenChanged: {
        overlay.visible = open;
        popup.visible = open;
        if (open) {
            lastRxBytes = -1;
            lastTxBytes = -1;
            lastSampleMs = 0;
            refreshNetwork();
        }
    }

    PanelWindow {
        id: overlay

        visible: false
        color: "transparent"
        aboveWindows: true
        focusable: true
        screen: root.panelWindow.screen

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        margins {
            top: root.panelWindow.height + 6
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = false
        }

    }

    PopupWindow {
        id: popup

        visible: false
        color: "transparent"
        implicitWidth: 620
        implicitHeight: 470

        anchor {
            window: root.panelWindow
            rect.x: Math.max(Theme.outerMargin, Math.min(root.panelWindow.width - Theme.outerMargin - popup.implicitWidth, root.anchorCenterX() - (popup.implicitWidth / 2)))
            rect.y: root.panelWindow.height + 6
            adjustment: PopupAdjustment.All
        }

        Process {
            id: activeConnectionProcess

            command: ["sh", "-c", "nmcli -t -f TYPE,STATE,DEVICE,NAME connection show --active 2>/dev/null | head -1 || true"]

            stdout: StdioCollector {
                onStreamFinished: {
                    const line = text.trim();
                    if (!line) {
                        root.networkType = "disconnected";
                        root.networkName = "Disconnected";
                        root.activeInterface = "";
                        return ;
                    }
                    const parts = line.split(":");
                    const rawType = parts[0] || "";
                    root.networkType = rawType.includes("wireless") || rawType.includes("wifi") ? "wifi" : "ethernet";
                    root.activeInterface = parts[2] || "";
                    root.networkName = parts[3] || "Connected";
                }
            }

        }

        Process {
            id: signalProcess

            command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | grep '^\\*' | cut -d':' -f2 || true"]

            stdout: StdioCollector {
                onStreamFinished: root.signalStrength = parseInt(text.trim()) || 0
            }

        }

        Process {
            id: wifiListProcess

            command: ["sh", "-c", "nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan no 2>/dev/null | head -n 6 || true"]

            stdout: StdioCollector {
                onStreamFinished: {
                    const lines = text.trim() ? text.trim().split("\n") : [];
                    root.wifiRows = lines.map((line) => {
                        const parts = line.split(":");
                        return {
                            "active": parts[0] === "*",
                            "ssid": parts[1] || "",
                            "signal": parts[2] || "--",
                            "security": parts.slice(3).join(":") || "Open"
                        };
                    }).filter((row) => {
                        return row.active || row.ssid !== "";
                    }).slice(0, 5);
                }
            }

        }

        Process {
            id: trafficProcess

            command: ["sh", "-c", `iface="${root.activeInterface}"; if [ -z "$iface" ]; then iface=$(ip route | awk '/default/ {print $5; exit}'); fi; if [ -n "$iface" ]; then rx=$(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0); tx=$(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0); echo "$rx $tx"; fi`]

            stdout: StdioCollector {
                onStreamFinished: {
                    const parts = text.trim().split(" ");
                    if (parts.length < 2)
                        return ;

                    const rx = parseFloat(parts[0]) || 0;
                    const tx = parseFloat(parts[1]) || 0;
                    const now = Date.now();
                    if (root.lastSampleMs > 0 && root.lastRxBytes >= 0 && root.lastTxBytes >= 0) {
                        const elapsedSeconds = Math.max((now - root.lastSampleMs) / 1000, 0.1);
                        root.downloadRate = root.formatRate(Math.max(0, rx - root.lastRxBytes) / elapsedSeconds);
                        root.uploadRate = root.formatRate(Math.max(0, tx - root.lastTxBytes) / elapsedSeconds);
                    }
                    root.lastRxBytes = rx;
                    root.lastTxBytes = tx;
                    root.lastSampleMs = now;
                }
            }

        }

        Timer {
            interval: 15000
            repeat: true
            running: root.open
            onTriggered: root.refreshNetwork()
        }

        Timer {
            interval: 2000
            repeat: true
            running: root.open
            onTriggered: {
                trafficProcess.running = false;
                trafficProcess.running = true;
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 14
            color: Theme.panel
            border.width: 1
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Rectangle {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 240
                    radius: 12
                    color: Theme.hover
                    border.width: 1
                    border.color: Theme.border

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8

                        Row {
                            width: parent.width
                            height: 40

                            Rectangle {
                                width: 32
                                height: 32
                                radius: 6
                                color: prevMouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.16) : "transparent"

                                MouseArea {
                                    id: prevMouseArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.shiftMonth(-1)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "◀"
                                    font.pixelSize: 14
                                    color: Theme.foreground
                                }

                            }

                            Text {
                                width: parent.width - 64
                                height: parent.height
                                text: root.monthTitle()
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.family: Theme.fontFamily
                                font.pixelSize: 18
                                font.weight: Theme.fontWeight
                                color: Theme.foreground
                            }

                            Rectangle {
                                width: 32
                                height: 32
                                radius: 6
                                color: nextMouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.16) : "transparent"

                                MouseArea {
                                    id: nextMouseArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.shiftMonth(1)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "▶"
                                    font.pixelSize: 14
                                    color: Theme.foreground
                                }

                            }

                        }

                        Grid {
                            width: parent.width
                            columns: 7
                            columnSpacing: 4
                            rowSpacing: 4

                            Repeater {
                                model: 7

                                delegate: Text {
                                    required property int modelData

                                    text: root.weekdayLabel(modelData)
                                    width: (parent.width - 24) / 7
                                    height: 20
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 12
                                    font.weight: Theme.fontWeight
                                    color: Theme.clock
                                }

                            }

                            Repeater {
                                model: 42

                                delegate: Rectangle {
                                    id: dayCell

                                    required property int modelData
                                    readonly property var cellData: root.monthCell(modelData)

                                    width: (parent.width - 24) / 7
                                    height: 35
                                    radius: 8
                                    color: cellMouse.containsMouse && cellData.day !== "" ? Qt.rgba(1, 1, 1, 0.1) : (cellData.today ? Qt.rgba(0.92, 0.63, 0.67, 0.3) : "transparent")
                                    border.width: cellData.today ? 1 : 0
                                    border.color: Qt.rgba(0.92, 0.63, 0.67, 0.55)

                                    MouseArea {
                                        id: cellMouse

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: dayCell.cellData.day !== "" ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: dayCell.cellData.day
                                        color: Theme.foreground
                                        opacity: dayCell.cellData.day === "" ? 0 : 1
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 14
                                        font.weight: dayCell.cellData.today ? Theme.fontWeight : Font.Normal
                                    }

                                }

                            }

                        }

                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 12
                    color: Theme.hover
                    border.width: 1
                    border.color: Theme.border

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Row {
                            width: parent.width
                            spacing: 12

                            Text {
                                text: root.networkIcon()
                                font.pixelSize: 28
                                color: Theme.volume
                                font.family: "Symbols Nerd Font"
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Column {
                                spacing: 4
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: root.networkLabel()
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 16
                                    font.weight: Theme.fontWeight
                                    color: Theme.foreground
                                }

                                Text {
                                    text: root.networkName
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 13
                                    color: Theme.clock
                                }

                            }

                        }

                        Column {
                            spacing: 4

                            Text {
                                text: root.networkType === "wifi" ? `${root.signalStrength}% signal` : (root.networkType === "ethernet" ? "Wired connection active" : "No active connection")
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                color: Theme.foreground
                            }

                            Text {
                                text: `↓ ${root.downloadRate}   ↑ ${root.uploadRate}`
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                                color: Theme.clock
                            }

                        }

                        Text {
                            text: "Available Wi-Fi"
                            font.family: Theme.fontFamily
                            font.pixelSize: 15
                            font.weight: Theme.fontWeight
                            color: Theme.foreground
                        }

                        ColumnLayout {
                            width: parent.width
                            spacing: 6

                            Repeater {
                                model: root.wifiRows

                                delegate: Rectangle {
                                    required property var modelData

                                    Layout.fillWidth: true
                                    implicitHeight: 36
                                    radius: 10
                                    color: modelData.active ? Theme.panel : "transparent"
                                    border.width: 1
                                    border.color: Theme.border

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10
                                        spacing: 8

                                        Text {
                                            text: modelData.active ? "●" : "○"
                                            color: modelData.active ? Theme.volume : Theme.mutedForeground
                                            font.pixelSize: 12
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.ssid
                                            elide: Text.ElideRight
                                            color: Theme.foreground
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 13
                                            font.weight: Theme.fontWeight
                                        }

                                        Text {
                                            text: `${modelData.signal}%`
                                            color: Theme.clock
                                            font.family: Theme.fontFamily
                                            font.pixelSize: 12
                                        }

                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
