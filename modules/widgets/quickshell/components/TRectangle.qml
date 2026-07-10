import QtQuick
import "../globals"

Rectangle {
    id: root
    property color defaultColor: Theme.background

    color: defaultColor
    radius: Theme.cornerRadius
    border.color: "#33FFFFFF"
    border.width: 1
}
