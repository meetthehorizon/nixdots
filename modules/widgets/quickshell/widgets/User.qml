import QtQuick
import components
import globals

Card {
    Chip {
        icon: "user"
        text: Theme.user ? (Theme.user.username + "@" + Theme.user.hostname) : ""
    }
}
