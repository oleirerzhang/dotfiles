# macOS dotfiles

Private, reproducible setup for Oliver's Macs.

This repository is the recovery and clean-install layer. For the current Mac-to-Mac move, use Migration Assistant first: it transfers applications, the user account, documents, and many settings in one pass. Then use this repository to audit what arrived and to rebuild command-line tools or shell configuration later.

## What is included

- `Brewfile`: current top-level Homebrew formulae and casks, plus detected Mac App Store apps.
- `home/`: a reviewed subset of portable dotfiles.
- `scripts/bootstrap`: installs Homebrew dependencies and links the reviewed dotfiles.
- `scripts/capture`: creates fresh application and Homebrew snapshots for review.
- `macos/applications.txt`: inventory of applications found on the source Mac.
- `alfred/README.md`: the supported Alfred migration procedure.

The live `Alfred.alfredpreferences` bundle is intentionally excluded. It may contain workflow credentials and executable files; Alfred's built-in sync is a better transport for it.

## Fast path on the new Mac

If you used Migration Assistant, first verify the migrated apps and Alfred. The bootstrap is mainly useful for missing tools or a future clean install.

```sh
git clone https://github.com/ZhangO999/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap
```

The installer backs up an existing destination before replacing it with a symlink. It does not modify unrelated files.

## Refresh snapshots on this Mac

```sh
cd ~/dotfiles
./scripts/capture
```

This refreshes `macos/applications.txt` and writes `Brewfile.generated` for inspection. Compare the generated file with the curated `Brewfile` before replacing anything.

## Migration checklist

See [macos/MIGRATION.md](macos/MIGRATION.md) before wiping or trading in the old Mac.
