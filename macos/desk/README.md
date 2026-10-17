# Desk desktop setup

Source: https://github.com/oleirerzhang/Desk (private).
Both Terminal and Alfred use `desk`. `desk overview` opens the named Mission
Control overview. The Alfred workflow and app have the same custom icon.

Run `./scripts/setup-desk` after the main bootstrap. It builds and installs the
source revision in `source.json`, installs the reviewed Alfred workflow, and
enables Desk Overlay at login. Xcode command-line tools, Python 3, yabai,
Spaceman, and Alfred with Powerpack are required. Authenticate GitHub before
cloning the private Desk repository.

`profile.json` captures the current desktop names by UUID, index and display,
plus Spaceman appearance and shortcut settings. It is a reference snapshot:
installation deliberately does not create/delete desktops or apply names by
position on a different Mac. Use `desk list` and `desk rename N "name"` to map
names to the intended desktops there. Spaceman preferences can be restored
through its own settings UI using this profile.

SIP remains enabled. Switching and labels need no new Accessibility access.
Adding/removing requires `desk setup` and Desk Helper's Accessibility permission.
Do not commit macOS privacy databases or the live Alfred preference bundle.

## Recovery

The `pre-optimization-20261018` tag in Desk preserves the original overlay,
CLI, icons, and workflow. To reinstall that version, set the source commit to
the tag's commit in `source.json` and run `./scripts/setup-desk`. The original
installed apps and Spaceman preferences are also saved locally under
`~/.local/share/named-desktops/checkpoints/pre-optimization-20261018/`.

## Optimized overlay

The current source pin includes event-driven Mission Control notifications,
release-optimized Swift, a small label-row window, and corrected eight-desktop
alignment. Open with `desk overview`, or hover over the desktop strip after
opening Mission Control normally. Labels appear after the thumbnails settle.
The two Desk event hooks are restored by yabairc after a service restart when
the overlay is running. `desk overlay stop` removes just those hooks.

The tested local sample fell from about 3.0% to 0.6% CPU while expanded; the
backing surface shrank by 97.3%. Tests include independent WindowServer checks,
rapid open/close, name/ID agreement, and repeated overview behavior. Physical
trackpad gestures and other monitor layouts still need hands-on verification.
