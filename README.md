# YouLite+

```text
Tweak: YouLite+
Author/Maintainer: hieucocc
Forked from: dayanch96
Base: last free YTLite source (v5.2b4)
```

YouLite+ is a deliberately small YouTube enhancement tweak. The current
runtime feature set is:

- ad and Premium-prompt blocking
- background playback
- optional Premium logo
- a compact YouLite+ section at the top of YouTube Settings

The original YTLite source included many renderer/UI hooks. They were removed
because they are unsafe on modern YouTube versions and can cause an empty Home
feed. PiP and iSponsorBlock are not claimed as features until their own source
has been integrated and device-tested.

## Build an IPA

Open **Actions → Build YouLite+ IPA → Run workflow**, then provide a direct
link to a decrypted YouTube IPA. The workflow records the YouTube version,
builds the tweak, injects it, and uploads the IPA as an artifact and draft
release.

## Compatibility

The upstream free source documented YouTube 20.32.4 as its last confirmed
version. Each new YouTube version must be tested on-device; a successful build
only proves packaging, not runtime compatibility.

## Credits and license

This project retains the upstream license and attribution chain. See the Git
history and source comments for individual upstream projects.
