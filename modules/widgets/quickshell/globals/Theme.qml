pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // HIG Typography
    readonly property string fontName: "IBM Plex Sans"
    readonly property int fontSize: 12

    // HIG Spacing & Structure
    readonly property int padding: 8
    readonly property int cornerRadius: 6
    readonly property int barHeight: 32

    // Neutral utility colors (Frosted glass foundation)
    readonly property color textPrimary: "#FFFFFF"
    readonly property color background: "#66000000"
    readonly property color backgroundHover: "#99000000"

    // Animation timing
    readonly property int animDuration: 200
}
