import QtQuick
import "../globals"

Text {
    id: root

    font.family: Theme.fontName
    font.pointSize: Theme.fontSize
    color: Theme.textPrimary

    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter

    antialiasing: true
}
