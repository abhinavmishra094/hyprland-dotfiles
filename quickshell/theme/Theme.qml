import QtQuick
pragma Singleton

QtObject {
    id: root

    readonly property GeneratedTheme
    generated: GeneratedTheme {
    }

    readonly property string themeName: generated.themeName
    readonly property color foreground: generated.foreground
    readonly property color mutedForeground: generated.mutedForeground
    readonly property color panel: generated.panel
    readonly property color border: generated.border
    readonly property color hover: generated.hover
    readonly property color focusedWorkspace: generated.focusedWorkspace
    readonly property color focusedWorkspaceForeground: generated.focusedWorkspaceForeground
    readonly property color urgentWorkspace: generated.urgentWorkspace
    readonly property color urgentWorkspaceForeground: generated.urgentWorkspaceForeground
    readonly property color clock: generated.clock
    readonly property color volume: generated.volume
    readonly property color microphone: generated.microphone
    readonly property color buttonHover: generated.buttonHover
    readonly property color dayHover: generated.dayHover
    readonly property color todayFill: generated.todayFill
    readonly property color todayBorder: generated.todayBorder
    readonly property string fontFamily: "Cartograph CF Nerd Font"
    readonly property int fontSize: 20
    readonly property int fontWeight: Font.Bold
    readonly property int radius: 10
    readonly property int borderWidth: 1
    readonly property int chipHeight: 38
    readonly property int outerMargin: 4
    readonly property int innerSpacing: 5
    readonly property int chipPadding: 10
    readonly property int trayIconSize: 20
    readonly property int traySpacing: 10
}
