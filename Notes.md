# Drone Patch Notes

## Current Status
- Additive synthesis implemented with a drawbar concept.
- All frequencies verified with strobe tuner → stable tuning (A4 reference correct).
- Tuning parameters:
  - `A4 Ref [Hz]` (390–470 Hz, integer steps)
  - `Fine [cents]` (–50…+50)
- Octave mapping:
  - Default = Scientific (C4 = 261 Hz, A4 = 440 Hz)
  - Optional Legacy mode (C3 = 261 Hz)
- Equal vs. Just Intonation:
  - Implemented as `hslider` mode selector
  - Works, though label sits very close to control
- Vibrato/Shimmer parameters available, default = off (suitable for Tuner Mode).
- Softclip option for safe output levels.

## Verified
- Frequency stability checked with strobe tuner → bands remain still.
- FaustIDE on iPad: sometimes unreliable (audio start, missing diagram).
- Fausteditor + `Ctrl/⌘+R` as a reliable workaround.

## Next Steps
- **Tuner Mode preset**:
  - Fundamental only (8′), no vibrato, configurable A4 Ref.
- **UI improvements**:
  - Grouping: Drawbars, Tuning, Output, Temperament.
  - Cleaner label for temperament switch (“Equal/Just”).
- **Optional**:
  - HTML/Bootstrap frontend for better layout.
  - Axum server integration (preset storage, REST API).
  - iOS app export via `faust2ios`.

## Open Questions
- Which presets should ship by default (e.g. Orchestra 443, Baroque 415, Tuner Mode)?
- Should note name display (C4, A4 etc.) remain visible or be optional?
- Scope/Spectrogram integration in the web frontend?
