import QtQuick
import QtQuick.Layouts

import widgets
import globals

TopPanel {
    id: root

    Item {
        id: leftContainer
        Layout.fillWidth: true
        Layout.preferredWidth: Math.max(leftContent.implicitWidth, rightContent.implicitWidth)
        implicitHeight: leftContent.implicitHeight

        RowLayout {
            id: leftContent
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacing.s1
            Uptime {}
            Workspaces {}
        }
    }

    Item {
        id: rightContainer
        Layout.fillWidth: true
        Layout.preferredWidth: Math.max(leftContent.implicitWidth, rightContent.implicitWidth)
        implicitHeight: rightContent.implicitHeight

        RowLayout {
            id: rightContent
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacing.s1
            Battery {}
            PowerProfiles {}
            Bluetooth {}
            Brightness {}
            Volume {}
            Network {}
            Clock {}
            Calendar {}
        }
    }
}
