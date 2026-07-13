import QtQuick
import Quickshell.Widgets
import globals

WrapperRectangle {
    id: root

    property string variant: "surfaceVariant"
    property bool hoverable: false

    readonly property bool hovered: hoverable && mouseArea.containsMouse
    default property alias contentItem: root.child

    signal clicked
    margin: Theme.spacing.s1

    color: {
        let actualVariant = root.variant === "accent" ? "surfaceVariant" : root.variant;
        let baseColor = Theme.color[actualVariant] !== undefined ? Theme.color[actualVariant] : Theme.color.surfaceVariant;

        let c = Qt.color(baseColor);
        let alpha = Theme.effects.surfaceVariantAlpha;
        if (root.hovered) {
            alpha = Math.min(alpha + 0.25, 1.0);
        }
        return Qt.rgba(c.r, c.g, c.b, alpha);
    }

    radius: Theme.radius.r1

    border.color: {
        var baseColor = root.variant === "accent" ? (Theme.color ? Theme.color.accent : "transparent") : (Theme.color ? Theme.color.border : "transparent");
        var opacity = (Theme.effects && Theme.effects.borderOpacity !== undefined) ? Theme.effects.borderOpacity : 0.4;
        if (root.hovered) {
            opacity = Math.min(opacity + 0.3, 1.0);
        }
        
        var c = Qt.color(baseColor);
        return Qt.rgba(c.r, c.g, c.b, opacity);
    }
    border.width: {
        var borderMap = Theme.border;
        if (root.variant === "accent") {
            return (borderMap && borderMap.w2 !== undefined) ? borderMap.w2 : 2;
        }
        return (borderMap && borderMap.w1 !== undefined) ? borderMap.w1 : 1;
    }

    scale: root.hovered ? 1.03 : 1.0

    Behavior on color {
        ColorAnimation { duration: Theme.animDuration.f }
    }

    Behavior on border.color {
        ColorAnimation { duration: Theme.animDuration.f }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Theme.animDuration.f
            easing.type: Easing.OutQuad
        }
    }

    data: [
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: root.hoverable

            acceptedButtons: root.hoverable ? Qt.LeftButton : Qt.NoButton
            onClicked: root.clicked()
            z: -1
        }
    ]
}
