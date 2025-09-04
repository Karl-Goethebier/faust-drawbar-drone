# faust-drawbar-drone
## Drawbar Drone Synth

A simple drone generator inspired by Hammond drawbars, written in the [Faust DSP language](https://faust.grame.fr).

Try it online in the [Faust Web Editor](https://fausteditor.grame.fr)  

## Features
- 9 Hammond-style drawbars (16′ … 1′)
- 12 chromatic notes + octave selector
- Just Intonation ↔ Equal Temperament switch
- Subtle global vibrato
- Static detune for stereo width (no “Leslie” swirl)
- Optional amplitude shimmer (slow tremolo)
- Stereo spread
- Power + Master volume


## Installation

### Run in the Faust Web Editor
1. Open [Faust Web Editor](https://fausteditor.grame.fr) 
2. Paste the contents of `drawbar-drone.dsp`.
3. Adjust drawbars and tuning to taste.

### Local build (optional)
If you have Faust installed:

```bash
faust2jaqt drawbar-drone.dsp
```

This creates a standalone Qt application with built-in scope and spectrum.

## Usage

### Drawbars
- Nine virtual drawbars replicate a Hammond-style additive synth.
- Each ranges **0–8**; higher = more volume for that harmonic.
- Example: pull only **8′** to hear a pure sine drone at the fundamental.

### Tuning
- **A4 Ref [Hz]**: set the concert pitch between **390–470 Hz** (integer steps).
- **Fine [cents]**: adjust ±50 cents for precise matching.
- **Legacy Octave**: toggle if your environment counts octaves differently.
  - Off (default) = *Scientific Pitch Notation* (**C4 = 261 Hz, A4 = 440 Hz**).
  - On = “Legacy” convention (**C3 = 261 Hz**).

### Temperament
- **EqualTemperament** checkbox:  
  - Off = Just Intonation (JI).  
  - On = Equal Temperament (ET).

### Modulation
- **Vibrato Rate / Depth**: slow pitch wobble (depth default = 0 for exact tuning).
- **Static Cents**: add subtle detuning between channels.
- **Shimmer TremDepth / TremRate**: slow amplitude beating.

### Stereo
- **Stereo Spread**: widens or narrows the panning of partials.

### Output
- **Master**: overall level control.
- **Output Gain**: extra boost/cut in dB (–12 to +24).
- **Soft Clip**: optional safety limiter using arctan curve.
- **Knee**: sets the softness of the clipping transition.

## Examples
- **Pure Drone**: A4=440 Hz, pull only **8′**, vibrato/shimmer off.  
- **Orchestra 443 Hz**: A4=443 Hz, use **8′ + 4′ + 2′**, add slight vibrato.  
- **Baroque 415 Hz**: A4=415 Hz, pull **8′ + 5 1/3′**, shimmer depth small.

## How to Run
1. Open the [Faust Web Editor](https://fausteditor.grame.fr/).
2. Paste the contents of `DrawbarDrone.dsp` into the editor.
3. Click **Run**.

## Preset Tips
- **Pure Still Drone**  
  StaticCents=0.0, VibratoDepth=0.0, ShimmerDepth=0.0
- **Wide Ensemble Drone**  
  StaticCents≈2.0, VibratoDepth≈0.0015, StereoSpread≈0.7
- **Subtle Breathing**  
  StaticCents≈1.0, VibratoDepth≈0.002, ShimmerDepth≈0.02, ShimmerRate≈0.2 Hz
- **Organ-like Richness**  
  Pull drawbars 16′, 8′, 4′ to ~8, StaticCents≈1.5, Spread≈0.6

## Drawbar Reference
| Drawbar | Footage | Harmonic Relation                           |
|---------|---------|---------------------------------------------|
| db1     | 16′     | Sub-octave (fundamental one octave lower)   |
| db2     | 5 1/3′  | 12th below fundamental (subharmonic colour) |
| db3     | 8′      | Fundamental pitch                           |
| db4     | 4′      | One octave above                            |
| db5     | 2 2/3′  | Octave + fifth (adds 5th harmonic)          |
| db6     | 2′      | Two octaves above                           |
| db7     | 1 3/5′  | Two octaves + major third (3rd harmonic)    |
| db8     | 1 1/3′  | Two octaves + fifth (5th harmonic)          |
| db9     | 1′      | Three octaves above                         |


## Links
- [Drawbars](https://en.wikipedia.org/wiki/Hammond_organ#Drawbars)
- [Just Intonation](https://en.wikipedia.org/wiki/Just_intonation)
- [Equal temperament](https://en.wikipedia.org/wiki/Equal_temperament)
- [Registration](https://en.wikipedia.org/wiki/Registration_(organ))
- [Faust Web Editor](https://fausteditor.grame.fr/)
- Raw DSP file (copy/paste into the Web Editor): `DrawbarDrone.dsp`

## Changelog
- 0.1.0 — Initial release (static detune + shimmer, JI/ET switch, stereo spread)

## Contributing
Issues and PRs welcome! Ideas: presets, simple reverb, MIDI note input.

## Acknowledgments
- This project was prototyped with assistance from [ChatGPT](https://openai.com/chatgpt), an AI coding assistant.  
- Synth design and implementation are based on the [Faust DSP language](https://faust.grame.fr/).  
- Inspiration: Hammond organ drawbars and the tradition of sustained drone sounds in experimental and meditative music.

## Disclaimer
This software is experimental and provided **as is**, without any warranty.  
Use at your own risk — especially with headphones or high volumes.

## Development

See [CHANGELOG.md](CHANGELOG.md) for current changes. Contributions welcome.

## License

[MIT](LICENSE)

---

*This project uses [Faust](https://faust.grame.fr/).*




