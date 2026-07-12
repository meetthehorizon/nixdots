import QtQuick
import QtQuick.Layouts
import components
import globals

RowLayout {
    spacing: Theme.spacing.s2
    RowLayout {
        Card {
            variant: "accent"
            Icon {
                icon: "neovim"
                collection: "simpleicons"
            }
        }
    }
    RowLayout {
        Card {
            Icon {
                icon: "firefox"
                collection: "simpleicons"
            }
        }
    }
    RowLayout {
        Card {
            Icon {
                icon: "kitty.png"
                collection: "custom"
            }
        }
    }
    RowLayout {
        Card {
            Icon {
                icon: "spotify"
                collection: "simpleicons"
            }
        }
    }
    RowLayout {
        Card {
            Icon {
                icon: "obsidian"
                collection: "simpleicons"
            }
        }
    }
}
