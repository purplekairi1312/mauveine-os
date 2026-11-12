# Maintenance

How nekozame os stays updated, and what to do when something breaks.

## How updates flow

1. GitHub Actions builds all three images every day (`nekozame-os`, `nekozame-os-amd`, `nekozame-os-deck`) on top of the latest Bazzite.
2. Every build runs the smoke tests in [`build_files/test.sh`](build_files/test.sh). If one fails, that image isn't pushed, so nobody gets it.
3. A build that passes becomes `:latest`.
4. On Sundays, [`promote.yml`](.github/workflows/promote.yml) copies `:latest` to `:stable`. Users follow `:stable`.
5. On each machine, Bazzite's `uupd` installs updates in the background. If a boot after an update doesn't reach the login screen three times in a row, greenboot rolls that machine back to the previous image by itself.

## When a build fails

GitHub emails you. Open the failed run (Actions tab), expand the red step, scroll to the first error.

- **A smoke test failed**: the log lists `FAIL  <what>`. Something the image should have went missing, usually because Bazzite or Fedora changed a package. Fix `build_files/build.sh`, push.
- **dnf can't install something / "filtered out by exclude filtering"**: Bazzite ships its own versions of some packages (mesa and friends) and blocks Fedora's. Don't install `-devel` packages into the image; build things in their own stage instead (see the mpvpaper stage in the [`Containerfile`](Containerfile)).
- **A COPR has no build for the new Fedora version yet** (right after a Fedora release): wait a few days, or pin the COPR to the previous Fedora version in `build.sh`.
- **A download 404s**: a pinned release moved. Update the version (see below).

Nothing breaks for users while a build is failing: they keep the last good image.

## Updating pinned versions

[Renovate](https://github.com/apps/renovate) opens a pull request when mpvpaper, yazi, yabridge, quickemu or a GitHub Action has a new release. The pull request runs the full build and the smoke tests; if it's green, merge it.

To pin something new, put a `# renovate: datasource=github-releases depName=owner/repo` line right above its `NAME=version` line.

## Rolling everyone back

If a bad image made it to `:stable`:

1. Actions → **Promote to stable** → **Run workflow**.
2. Set **from** to the date tag of the last good build, like `20261110` (tags are listed on the package page on GitHub).

Everyone on `:stable` goes back to that build on their next update.

## Rolling one machine back

```sh
rpm-ostree rollback   # back to the previous image
systemctl reboot
```

Or pick the previous entry in the boot menu.

## Testing a change before users get it

Push to a branch and open a pull request: it builds all three images and runs the smoke tests, without pushing anything.
