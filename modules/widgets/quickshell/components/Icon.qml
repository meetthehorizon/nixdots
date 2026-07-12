import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import globals

Item {
    id: root

    property string icon: ""
    property string collection: "lucide"
    property string variant: "primary"
    property int size: Theme.spacing.s4

    readonly property bool colorize: !root.icon.match(/\.(png|jpg|jpeg|gif)$/i)

    property color iconColor: {
        if (root.variant === "primary")
            return Theme.color.text;
        if (root.variant === "muted")
            return Theme.color.textMuted;
        if (root.variant === "accent")
            return Theme.color.accent;
        if (root.variant === "error")
            return Theme.color.error;

        return Theme.color.text;
    }

    implicitWidth: size
    implicitHeight: size

    Image {
        id: rawIcon
        anchors.fill: parent

        source: {
            if (root.icon === "")
                return "";
            if (root.collection === "simpleicons") {
                return "../icons/simpleicons/" + root.icon + ".svg";
            } else if (root.collection === "custom") {
                if (root.icon.indexOf(".") !== -1) {
                    return "../icons/custom/" + root.icon;
                } else {
                    return "../icons/custom/" + root.icon + ".svg";
                }
            } else {
                return "../icons/lucide/" + root.icon + ".svg";
            }
        }

        sourceSize: Qt.size(root.size, root.size)
        fillMode: Image.PreserveAspectFit

        visible: !root.colorize
    }

    MultiEffect {
        source: rawIcon
        anchors.fill: parent

        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.iconColor

        visible: root.colorize
    }
}
