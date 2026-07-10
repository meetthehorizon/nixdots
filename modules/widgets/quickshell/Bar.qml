// shell.qml
import QtQuick

import "./components"
import "./services"
import "./globals"

TPanelWindow {
    id: panel

    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    TRectangle {
        anchors.fill: parent
        Item {
            anchors.fill: parent
            anchors.leftMargin: Theme.padding * 2
            anchors.rightMargin: Theme.padding * 2

            TRow {
                anchors.right: parent.right
                TText {
                    text: "BAT " + BatteryService.percent
                    color: BatteryService.isCharging ? "#00FF00" : "#FFFFFF"
                }
                TText {
                    text: TimeService.currentDate
                }

                TText {
                    text: TimeService.currentTime
                }
            }
        }
    }
}
