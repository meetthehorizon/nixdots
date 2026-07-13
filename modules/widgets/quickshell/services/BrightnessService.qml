pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string brightnessText: "100"

    // Responsive 250ms polling timer for backlight changes
    Timer {
        id: pollTimer
        interval: 250
        repeat: true
        running: true
        onTriggered: {
            if (!brightnessProcess.running) {
                brightnessProcess.running = true;
            }
        }
    }

    // Query current brightness from correct display device (amdgpu_bl1)
    Process {
        id: brightnessProcess
        command: ["brightnessctl", "-d", "amdgpu_bl1", "-m"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var textVal = this.text.trim();
                var parts = textVal.split(",");
                if (parts.length >= 4) {
                    var pct = parts[3].trim();
                    root.brightnessText = pct.replace("%", "");
                }
            }
        }
    }
}
