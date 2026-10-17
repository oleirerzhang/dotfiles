# Alfred migration

## Current source-Mac state

- Alfred 5.7.3 and Alfred 4.8 are installed.
- Preferences are local at `~/Library/Application Support/Alfred/Alfred.alfredpreferences` rather than in a sync provider.
- The preference bundle is about 47 MB and contains 14 workflows: Chrome Control, Chrome History, Clear Your Desktop, Instagram Toolkit, Kill Process, Notion Search, Numi, Reminders for Alfred 3, Run Command, Search Notes, Search Raindrop.io, Shorten URL, Trash Your Downloads Folder, and Words.

## Recommended transfer

Use Alfred's built-in Preferences Sync with iCloud Drive (or another supported local sync client). This carries preferences, workflows, snippets, and themes while preserving the bundle structure and executable permissions.

On the old Mac:

1. Make a Time Machine backup first.
2. Open Alfred 5 Preferences → **Advanced**.
3. Under Syncing, choose **Set preferences folder…** and select an `Alfred` folder in iCloud Drive.
4. Let Alfred restart and wait until iCloud finishes uploading `Alfred.alfredpreferences`.
5. In Finder, right-click that bundle and choose **Keep Downloaded**.

On the new Mac:

1. Install Alfred 5 and activate the Powerpack.
2. Wait for iCloud Drive to download the whole preferences bundle, then mark it **Keep Downloaded**.
3. In Alfred Preferences → **Advanced**, set the preferences folder to the same iCloud Drive folder and restart Alfred.
4. Re-grant macOS permissions requested by Alfred and test each important workflow.

Alfred deliberately does not sync every machine-local choice. Recheck the main hotkey, search scope, selected theme, Clipboard History, snippet auto-expansion, browser-bookmark source/profile, workflow proxy, and update settings.

Once Alfred 5 has been verified, Alfred recommends manually removing Alfred 4 if it is no longer needed. Do not use an app cleaner for that removal because it may delete the current preference data too.

## Why the live bundle is not in Git

Workflow environment variables and scripts can contain tokens, account identifiers, or other secrets. The bundle also contains cache-like data and files whose executable permissions matter. The repository therefore ignores `Alfred.alfredpreferences` and exported `.alfredworkflow` files by default.

For workflows you actively develop, use a separate source repository per workflow or add only reviewed source files here. Keep credentials in Alfred's workflow configuration or the macOS Keychain, never in Git.

Official guide: https://www.alfredapp.com/help/advanced/sync/

## Desk workflow

Named Desktops is a reviewed source workflow installed by `scripts/setup-desk`
from the pinned Desk repository. Keyword: `desk`. It shares names with the
Terminal CLI and Spaceman and includes the custom workspace icon. Reinstalling
Desk restores this workflow without importing unrelated Alfred preferences.
