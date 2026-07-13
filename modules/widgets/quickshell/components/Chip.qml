import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import components
import globals

WrapperItem {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property string icon: ""
    property string iconCollection: "lucide"
    property string iconSuffix: "original"

    property string text: ""
    property string variant: "primary"
    property string size: "base"
    property string weight: "normal"
    property string spacingSize: "s1"

    RowLayout {
        id: layout
        anchors.fill: parent

        spacing: Theme.spacing[root.spacingSize]

        Icon {
            icon: root.icon
            collection: root.iconCollection
            variant: root.variant
            size: {
                if (root.size === "xs") return Theme.spacing.s3;
                if (root.size === "sm") return Theme.spacing.s4;
                if (root.size === "base") return Theme.spacing.s5;
                if (root.size === "lg") return Theme.spacing.s6;
                return Theme.spacing.s5;
            }

            visible: root.icon && root.icon !== ""
        }

        Label {
            text: root.text
            variant: root.variant
            size: root.size
            weight: root.weight
            visible: root.text && root.text !== ""
        }
    }
}
