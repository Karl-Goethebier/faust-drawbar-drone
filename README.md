# faust-drawbar-drone
## Drawbar Drone Synth (Faust)

A simple drone generator inspired by Hammond drawbars, written in the [Faust DSP language](https://faust.grame.fr).

Try it online in the Faust Web IDE:  
👉 https://fausteditor.grame.fr/

## Features
- 9 Hammond-style drawbars (16′ … 1′)
- 12 chromatic notes + octave selector
- Just Intonation ↔ Equal Temperament switch
- Subtle global vibrato
- Static detune for stereo width (no “Leslie” swirl)
- Optional amplitude shimmer (slow tremolo)
- Stereo spread
- Power + Master volume

## How to Run
1. Open the [Faust Web IDE](https://fausteditor.grame.fr/).
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
- Faust Web IDE: https://fausteditor.grame.fr/
- Raw DSP file (copy/paste into IDE): `DrawbarDrone.dsp`

## Changelog
- 0.1.0 — Initial release (static detune + shimmer, JI/ET switch, stereo spread)

## Contributing
Issues and PRs welcome! Ideas: presets, simple reverb (Schroeder), MIDI note input.

## Acknowledgments
- This project was prototyped with assistance from [ChatGPT](https://openai.com/chatgpt), an AI coding assistant.  
- Synth design and implementation are based on the [Faust DSP language](https://faust.grame.fr/).  
- Inspiration: Hammond organ drawbars and the tradition of sustained drone sounds in experimental and meditative music.

## Disclaimer
This software is experimental and provided **as is**, without any warranty.  
Use at your own risk — especially with headphones or high volumes.




