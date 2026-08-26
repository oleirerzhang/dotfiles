#!/usr/bin/env bash
# Apply the macOS preferences this Mac actually differs from stock on.
#
# Only preferences that were explicitly changed here are written. Anything
# left at a macOS default is deliberately absent, so a future macOS release is
# free to change its own defaults without this script fighting it. Compare
# against macos/defaults-snapshot.txt to see the full tracked list.
#
# Safe to re-run. Log out and back in afterwards for everything to take hold.
set -euo pipefail

echo "Keyboard"
# Roughly a 500 ms pause before a held key starts repeating.
defaults write NSGlobalDomain InitialKeyRepeat -int 35

echo "Appearance"
# Scrollbars stay visible rather than fading out.
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write com.apple.universalaccess reduceTransparency -bool true

echo "Dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock largesize -int 128
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-recents -bool false
# Spaces keep the order they were created in. The Space-switching shortcuts in
# skhdrc address Spaces by index, so reordering them would move the targets.
defaults write com.apple.dock mru-spaces -bool false

echo "Finder"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"
# New windows open on All My Files.
defaults write com.apple.finder NewWindowTarget -string "PfAF"

echo "Trackpad"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Spaces"
# Displays share one set of Spaces rather than each having its own.
defaults write com.apple.spaces spans-displays -bool false

echo "Restarting Dock and Finder"
killall Dock >/dev/null 2>&1 || true
killall Finder >/dev/null 2>&1 || true

cat <<'MANUAL'

Two settings this script cannot apply
-------------------------------------
macOS protects the accessibility preference domain, so `defaults write
com.apple.universalaccess reduceMotion` is ignored unless the writing process
holds Full Disk Access. Set it by hand:

  System Settings > Accessibility > Display > Reduce Motion  (on)

That one matters beyond cosmetics: it is what turns the Space-switching
animation into a quick crossfade instead of a slide, which is the whole point
of the Cmd+Option+1..4 shortcuts.

yabai and skhd each need Accessibility permission before their shortcuts work:

  System Settings > Privacy & Security > Accessibility

then `yabai --restart-service` and `skhd --restart-service`.
MANUAL
