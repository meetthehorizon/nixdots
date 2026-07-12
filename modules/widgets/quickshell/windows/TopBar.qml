import QtQuick
import QtQuick.Layouts

import Quickshell.Widgets

import widgets

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
        Clock {}
    }

    Item {
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.alignment: Qt.AlignRight
        Bluetooth {}
        Brightness {}
        Network {}
    }
}
