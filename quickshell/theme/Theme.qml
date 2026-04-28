import QtQuick
pragma Singleton

QtObject {
    readonly property color foreground: "#cdd6f4"
    readonly property color mutedForeground: "#313244"
    readonly property color panel: "#1e1e2e"
    readonly property color border: "#181825"
    readonly property color hover: "#11111b"
    readonly property color focusedWorkspace: "#eba0ac"
    readonly property color urgentWorkspace: "#a6e3a1"
    readonly property color clock: "#fab387"
    readonly property color volume: "#89b4fa"
    readonly property color microphone: "#cba6f7"
    readonly property string fontFamily: "Cartograph CF Nerd Font"
    readonly property int fontSize: 20
    readonly property int fontWeight: Font.Bold
    readonly property int radius: 10
    readonly property int borderWidth: 1
    readonly property int chipHeight: 38
    readonly property int outerMargin: 10
    readonly property int innerSpacing: 5
    readonly property int chipPadding: 10
    readonly property int trayIconSize: 20
    readonly property int traySpacing: 10
}
