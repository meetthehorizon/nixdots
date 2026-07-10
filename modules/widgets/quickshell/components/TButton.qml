import QtQuick
import "../globals"

TRectangle {
    id: root
    property string text: "Button"

    signal clicked

    implicitWidth: label.implicitWidth + (Theme.padding * 4)
    implicitHeight: 24

    defaultColor: mouseArea.containsMouse ? Theme.backgroundHover : Theme.background
    Behavior on defaultColor {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

    TText {
        id: label
        text: root.text
        anchors.centerIn: parent
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.clicked();
        }
    }
}
