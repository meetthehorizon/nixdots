import QtQuick
import QtQuick.Layouts

import Quickshell.Widgets

import widgets
import globals

TopPanel {
    RowLayout {
        Layout.alignment: Qt.AlignLeft
        Uptime {}
        Workspaces {}
    }

    Item {
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        spacing: Theme.spacing.s2
        Calendar {}
        Clock {}
    }

    Item {
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.alignment: Qt.AlignRight
        Battery {}
        Bluetooth {}
        Brightness {}
        Network {}
    }
}
