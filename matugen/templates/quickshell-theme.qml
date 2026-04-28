import QtQuick

QtObject {
    readonly property string themeName: "matugen"
    readonly property color foreground: "{{colors.on_surface.default.hex}}"
    readonly property color mutedForeground: "{{colors.on_surface_variant.default.hex}}"
    readonly property color panel: "{{colors.surface.default.hex}}"
    readonly property color border: "{{colors.outline.default.hex}}"
    readonly property color hover: "{{colors.surface_variant.default.hex}}"
    readonly property color focusedWorkspace: "{{colors.primary_container.default.hex}}"
    readonly property color focusedWorkspaceForeground: "{{colors.on_primary_container.default.hex}}"
    readonly property color urgentWorkspace: "{{colors.error_container.default.hex}}"
    readonly property color urgentWorkspaceForeground: "{{colors.on_error_container.default.hex}}"
    readonly property color clock: "{{colors.tertiary.default.hex}}"
    readonly property color volume: "{{colors.primary.default.hex}}"
    readonly property color microphone: "{{colors.secondary.default.hex}}"
    readonly property color buttonHover: "{{colors.secondary_container.default.hex}}"
    readonly property color dayHover: "{{colors.surface_variant.default.hex}}"
    readonly property color todayFill: "{{colors.primary_container.default.hex}}"
    readonly property color todayBorder: "{{colors.primary.default.hex}}"
}
