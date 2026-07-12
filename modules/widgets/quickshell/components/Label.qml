import QtQuick
import globals

Text {
    id: root

    property string variant: "primary"
    property string size: "base"
    property string weight: "normal"
    property string fontStyle: "sans"

    visible: text !== ""
    color: {
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

    font.family: {
        var f = Theme.font;
        if (root.fontStyle === "sans")
            return f.sans;
        if (root.fontStyle === "sansSerif")
            return f.sansSerif;
        if (root.fontStyle === "mono")
            return f.mono;
        return f.sans;
    }

    font.pointSize: {
        var sizeMap = Theme.font ? Theme.font.size : null;
        var val = 12;
        if (sizeMap && sizeMap[root.size] !== undefined) {
            val = sizeMap[root.size];
        } else if (sizeMap && sizeMap.base !== undefined) {
            val = sizeMap.base;
        }
        return val;
    }

    font.weight: {
        var weightMap = Theme.font ? Theme.font.weight : null;
        if (weightMap && weightMap[root.weight] !== undefined) {
            return weightMap[root.weight];
        }
        return (weightMap && weightMap.normal !== undefined) ? weightMap.normal : 400;
    }

    renderType: Text.NativeRendering
    antialiasing: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
