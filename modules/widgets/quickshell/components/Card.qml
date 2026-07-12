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
        return Qt.rgba(c.r, c.g, c.b, Theme.effects.surfaceVariantAlpha);
    }

    radius: Theme.radius.r1

    border.color: {
        var baseColor = root.variant === "accent" ? (Theme.color ? Theme.color.accent : "transparent") : (Theme.color ? Theme.color.border : "transparent");
        var opacity = (Theme.effects && Theme.effects.borderOpacity !== undefined) ? Theme.effects.borderOpacity : 0.4;
        
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

    data: [
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: root.hoverable

            acceptedButtons: root.hoverable ? Qt.LeftButton : Qt.NoButton
            onClicked: root.clicked()
            z: 1
        }
    ]
}
