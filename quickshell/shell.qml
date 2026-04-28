//@ pragma UseQApplication
import QtQuick
import Quickshell
import "modules/bar"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData

            shellScreen: modelData
        }

    }

}
