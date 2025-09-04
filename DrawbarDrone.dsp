import("stdfaust.lib");

// =========================
// Drawbar Drone (Web IDE / iOS friendly)
// - A4 tuning with integer Hz + integer fine cents
// - Scientific octave mapping by default (C4=MIDI 60), Legacy toggle available
// - Output gain (dB) + optional atan soft clip
// =========================

// ------- UI
power      = checkbox("Power");
master     = hslider("Master", 0.3, 0, 1, 0.001);

// Note selector with names
note       = hslider("Note [style:menu{'C':0; 'C#':1; 'D':2; 'D#':3; 'E':4; 'F':5; 'F#':6; 'G':7; 'G#':8; 'A':9; 'A#':10; 'B':11}]", 0, 0, 11, 1);
octave     = hslider("Octave", 4, 0, 8, 1);

// Tuning & mapping (integers)
A4RefHz    = nentry("Tuning/A4 Ref [Hz]", 440, 390, 470, 1);     // integer Hz
A4FineCt   = nentry("Tuning/Fine [cents]", 0, -50, 50, 1);       // integer cents
legacyMap  = checkbox("Mapping/Legacy Octave (no +1)");          // off = scientific (C4=MIDI60)

// Temperament: 0 = JI, 1 = ET
mode = hslider("Tuning/Temperament [style:menu{'Just':0; 'Equal':1}]", 0, 0, 1, 1);

// Output
outGainDb  = hslider("Output/Gain [unit:dB]", 6, -12, 24, 0.1);
safetyClip = checkbox("Output/Safety Soft Clip");
softK      = hslider("Output/SoftClip Knee", 2.0, 0.5, 10.0, 0.1);

// Drawbars [0..8]
db1 = hslider("drawbar[style:knob] 16'",    0, 0, 8, 1);
db2 = hslider("drawbar[style:knob] 5 1/3'", 0, 0, 8, 1);
db3 = hslider("drawbar[style:knob] 8'",     8, 0, 8, 1);
db4 = hslider("drawbar[style:knob] 4'",     0, 0, 8, 1);
db5 = hslider("drawbar[style:knob] 2 2/3'", 0, 0, 8, 1);
db6 = hslider("drawbar[style:knob] 2'",     0, 0, 8, 1);
db7 = hslider("drawbar[style:knob] 1 3/5'", 0, 0, 8, 1);
db8 = hslider("drawbar[style:knob] 1 1/3'", 0, 0, 8, 1);
db9 = hslider("drawbar[style:knob] 1'",     0, 0, 8, 1);

// ------- Helpers
midiToHz(a4, m) = a4 * pow(2.0, (m - 69.0)/12.0);
centsToRatio(x) = pow(2.0, x/1200.0);
signum(x)       = (x >= 0)*2 - 1;
db2lin(x)       = pow(10, x/20.0);

// equal-power pan (−1…+1)
epanL(x,p) = x*sqrt((1-p)/2.0);
epanR(x,p) = x*sqrt((1+p)/2.0);

// ------- Pitch & temperament
A4Ref = A4RefHz * centsToRatio(A4FineCt);     // integer Hz anchor + integer cent trim
octSel   = select2(legacyMap, octave+1, octave); // 0->oct+1 (scientific), 1->legacy
baseMidi = (octSel * 12) + note;
freqBase = midiToHz(A4Ref, baseMidi);

// JI ratios (rel. to 8′)
rJI0=0.5; rJI1=1.5; rJI2=1.0; rJI3=2.0; rJI4=3.0; rJI5=4.0; rJI6=5.0; rJI7=6.0; rJI8=8.0;
// ET ratios
s0=-12.0; s1=7.0; s2=0.0; s3=12.0; s4=19.0; s5=24.0; s6=28.0; s7=31.0; s8=36.0;
rET0=pow(2.0,s0/12.0); rET1=pow(2.0,s1/12.0); rET2=pow(2.0,s2/12.0);
rET3=pow(2.0,s3/12.0); rET4=pow(2.0,s4/12.0); rET5=pow(2.0,s5/12.0);
rET6=pow(2.0,s6/12.0); rET7=pow(2.0,s7/12.0); rET8=pow(2.0,s8/12.0);

ratio0=select2(mode,rJI0,rET0); ratio1=select2(mode,rJI1,rET1); ratio2=select2(mode,rJI2,rET2);
ratio3=select2(mode,rJI3,rET3); ratio4=select2(mode,rJI4,rET4); ratio5=select2(mode,rJI5,rET5);
ratio6=select2(mode,rJI6,rET6); ratio7=select2(mode,rJI7,rET7); ratio8=select2(mode,rJI8,rET8);

// ------- Dynamics
drawAmp(d) = pow(d/8.0, 1.3) * 0.14;

// Vibrato (Depth default 0 for precise tuning)
vibRate  = hslider("Vibrato/Rate[unit:Hz]", 0.15, 0, 2, 0.01);
vibDepth = hslider("Vibrato/Depth", 0.0, 0, 0.01, 0.0001);
vib      = 1 + vibDepth*os.osc(vibRate);

staticCents = hslider("Ensemble/StaticCents", 1.5, 0, 10, 0.1);

tremDepth = hslider("Shimmer/TremDepth", 0.02, 0, 0.2, 0.001);
tremRate  = hslider("Shimmer/TremRate[unit:Hz]", 0.20, 0, 3, 0.01);
tRate(rs) = tremRate * rs;
ampShimmer(rs) = 1 + tremDepth * os.osc(tRate(rs));

// ------- Stereo
spread = hslider("Stereo/Spread", 0.7, 0, 1, 0.01);
pan0=-spread; pan1=-spread+(2*spread)*(1.0/8.0); pan2=-spread+(2*spread)*(2.0/8.0);
pan3=-spread+(2*spread)*(3.0/8.0); pan4=0.0;
pan5= spread-(2*spread)*(3.0/8.0); pan6= spread-(2*spread)*(2.0/8.0);
pan7= spread-(2*spread)*(1.0/8.0); pan8= spread;

// One partial -> L/R (unison + detuned twin, mirrored)
partL(f, g, p, rs) =
  epanL(os.osc(f) * g * 0.5 * ampShimmer(rs), p)
+ epanL(os.osc(f * centsToRatio(staticCents * signum(p))) * g * 0.5 * ampShimmer(rs), -p);

partR(f, g, p, rs) =
  epanR(os.osc(f) * g * 0.5 * ampShimmer(rs), p)
+ epanR(os.osc(f * centsToRatio(staticCents * signum(p))) * g * 0.5 * ampShimmer(rs), -p);

// Freqs
f0=freqBase*ratio0*vib; f1=freqBase*ratio1*vib; f2=freqBase*ratio2*vib;
f3=freqBase*ratio3*vib; f4=freqBase*ratio4*vib; f5=freqBase*ratio5*vib;
f6=freqBase*ratio6*vib; f7=freqBase*ratio7*vib; f8=freqBase*ratio8*vib;

// Gains
g1=drawAmp(db1); g2=drawAmp(db2); g3=drawAmp(db3); g4=drawAmp(db4); g5=drawAmp(db5);
g6=drawAmp(db6); g7=drawAmp(db7); g8=drawAmp(db8); g9=drawAmp(db9);

// Mix
dryL = partL(f0,g1,pan0,1-0.12)+partL(f1,g2,pan1,1-0.08)+partL(f2,g3,pan2,1-0.05)
     + partL(f3,g4,pan3,1-0.02)+partL(f4,g5,pan4,1+0.00)+partL(f5,g6,pan5,1+0.02)
     + partL(f6,g7,pan6,1+0.05)+partL(f7,g8,pan7,1+0.08)+partL(f8,g9,pan8,1+0.12);

dryR = partR(f0,g1,pan0,1-0.12)+partR(f1,g2,pan1,1-0.08)+partR(f2,g3,pan2,1-0.05)
     + partR(f3,g4,pan3,1-0.02)+partR(f4,g5,pan4,1+0.00)+partR(f5,g6,pan5,1+0.02)
     + partR(f6,g7,pan6,1+0.05)+partR(f7,g8,pan7,1+0.08)+partR(f8,g9,pan8,1+0.12);

// Output
softclip(x) = (2.0/3.14159265) * atan(softK * x);
preL = dryL * (power * master * db2lin(outGainDb));
preR = dryR * (power * master * db2lin(outGainDb));
outL = select2(safetyClip, preL, softclip(preL));
outR = select2(safetyClip, preR, softclip(preR));

// Ensure integer controls are always visible in IDE
uiEval = A4RefHz + A4FineCt*0 + legacyMap*0;

// Final
process = attach(outL, uiEval), attach(outR, uiEval);
