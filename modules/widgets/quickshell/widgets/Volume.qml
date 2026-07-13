import QtQuick
import components
import services

Card {
    Chip {
        icon: {
            if (VolumeService.muted) {
                return "volume-x";
            }
            var vol = VolumeService.volume;
            if (vol === 0) {
                return "volume";
            } else if (vol < 0.5) {
                return "volume-1";
            } else {
                return "volume-2";
            }
        }
        iconCollection: "lucide"
        text: ""
    }
}
