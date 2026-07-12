import QtQuick
import Quickshell
import windows

ShellRoot {
    Variants {
        model: Quickshell.screens
        TopBar {
            required property var modelData
            screen: modelData
        }
    }
}
