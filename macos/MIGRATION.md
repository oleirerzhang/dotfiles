# Mac-to-Mac migration

## Recommended one-time move

Use Apple's Migration Assistant. It is the quickest route to the closest copy of the old Mac because it can transfer applications, user accounts, documents, privacy and security settings, and system/network settings.

1. Update both Macs, connect both to power, and make a fresh Time Machine backup of the old Mac.
2. Turn off VPN/firewall utilities for the transfer. This source Mac has VPN software installed, so this step matters.
3. Connect the Macs directly with a Thunderbolt/USB-C or Ethernet connection when possible; a cable is typically faster than Wi-Fi.
4. On the new Mac during Setup Assistant, choose transfer from another Mac. If setup is already complete, open **System Settings → General → Transfer or Reset → Open Migration Assistant**.
5. On the old Mac, open Migration Assistant and choose **To another Mac**.
6. Select **Applications**, the user account, **Other Files & Folders**, **Privacy & Security Settings**, and **System & Network**.
7. Keep the old Mac untouched until the new one has been used successfully for several days and a new backup exists.

Expect to sign in again to some licensed apps, mail accounts, VPNs, developer tools, and cloud services. macOS may also require privacy permissions to be granted again.

## Clean-install alternative

For a deliberately clean Mac:

1. Clone this repository and run `./scripts/bootstrap`.
2. Sign in to the Mac App Store before `brew bundle` installs App Store apps.
3. Use `macos/applications.txt` as the audit list for apps that were installed outside Homebrew or the App Store.
4. Follow `alfred/README.md` for Alfred.
5. Clone the existing Neovim configuration separately from `https://github.com/ZhangO999/kickstart.nvim`.

The clean route is more reproducible but is not a complete replacement for Migration Assistant: many commercial applications, licences, app data, and system permissions are not represented by a Brewfile.
