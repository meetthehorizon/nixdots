import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import globals

// qmllint disable uncreatable-type
PanelWindow {
    default property alias content: mainLayout.data

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
        right: 0
        bottom: 0
        left: 0
    }

    color: {
        var c = Theme.color.surface;
        return Qt.rgba(c.r, c.g, c.b, Theme.effects.surfaceAlpha);
    }
    WlrLayershell.namespace: "quickshell"

    implicitHeight: mainLayout.implicitHeight
    implicitWidth: mainLayout.implicitWidth
    RowLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 10
    }
}
