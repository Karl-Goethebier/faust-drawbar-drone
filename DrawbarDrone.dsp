import("stdfaust.lib");

// ===== Drawbar Drone — no MIDI, static detune, shimmer =====

power  = checkbox("Power");
master = hslider("Master", 0.3, 0, 1, 0.001);

midiToHz(m) = 440 * pow(2.0, (m - 69.0)/12.0);

note   = hslider("Note [0=C … 11=B]", 0, 0, 11, 1);
octave = hslider("Octave", 4, 0, 8, 1);
baseMidi = (octave*12) + note;
freqBase = midiToHz(baseMidi);

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

// Temperament: 0 = JI, 1 = ET
mode = checkbox("EqualTemperament");

// JI ratios
rJI0=0.5; rJI1=1.5; rJI2=1.0; rJI3=2.0; rJI4=3.0; rJI5=4.0; rJI6=5.0; rJI7=6.0; rJI8=8.0;

// ET ratios (semitones rel. to 8′)
s0=-12.0; s1=7.0; s2=0.0; s3=12.0; s4=19.0; s5=24.0; s6=28.0; s7=31.0; s8=36.0;
rET0=pow(2.0,s0/12.0); rET1=pow(2.0,s1/12.0); rET2=pow(2.0,s2/12.0);
rET3=pow(2.0,s3/12.0); rET4=pow(2.0,s4/12.0); rET5=pow(2.0,s5/12.0);
rET6=pow(2.0,s6/12.0); rET7=pow(2.0,s7/12.0); rET8=pow(2.0,s8/12.0);

// pick JI or ET
ratio0=select2(mode,rJI0,rET0); ratio1=select2(mode,rJI1,rET1); ratio2=select2(mode,rJI2,rET2);
ratio3=select2(mode,rJI3,rET3); ratio4=select2(mode,rJI4,rET4); ratio5=select2(mode,rJI5,rET5);
ratio6=select2(mode,rJI6,rET6); ratio7=select2(mode,rJI7,rET7); ratio8=select2(mode,rJI8,rET8);

drawAmp(d) = pow(d/8.0, 1.3) * 0.14;

// Vibrato
vibRate  = hslider("Vibrato/Rate[unit:Hz]", 0.15, 0, 2, 0.01);
vibDepth = hslider("Vibrato/Depth", 0.0015, 0, 0.01, 0.0001);
vib = 1 + vibDepth*os.osc(vibRate);

// Static detune
signum(x) = (x >= 0)*2 - 1;
staticCents = hslider("Ensemble/StaticCents", 1.5, 0, 10, 0.1);
centsToRatio(x) = pow(2.0, x/1200.0);

// Shimmer (amplitude tremolo)
tremDepth = hslider("Shimmer/TremDepth", 0.02, 0, 0.2, 0.001);
tremRate  = hslider("Shimmer/TremRate[unit:Hz]", 0.20, 0, 3, 0.01);
tRate(rs) = tremRate * rs;
ampShimmer(rs) = 1 + tremDepth * os.osc(tRate(rs));

// Panning
epanL(x,p)=x*sqrt((1-p)/2.0);
epanR(x,p)=x*sqrt((1+p)/2.0);
spread = hslider("Stereo/Spread", 0.7, 0, 1, 0.01);
pan0=-spread; pan1=-spread+(2*spread)*(1.0/8.0); pan2=-spread+(2*spread)*(2.0/8.0);
pan3=-spread+(2*spread)*(3.0/8.0); pan4=0.0;
pan5= spread-(2*spread)*(3.0/8.0); pan6= spread-(2*spread)*(2.0/8.0);
pan7= spread-(2*spread)*(1.0/8.0); pan8= spread;

// Partials
partL(f,d,p,rs) =
  epanL(os.osc(f) * drawAmp(d) * 0.5 * ampShimmer(rs), p)
+ epanL(os.osc(f * centsToRatio(staticCents * signum(p))) * drawAmp(d) * 0.5 * ampShimmer(rs), -p);

partR(f,d,p,rs) =
  epanR(os.osc(f) * drawAmp(d) * 0.5 * ampShimmer(rs), p)
+ epanR(os.osc(f * centsToRatio(staticCents * signum(p))) * drawAmp(d) * 0.5 * ampShimmer(rs), -p);

f0=freqBase*ratio0*vib; f1=freqBase*ratio1*vib; f2=freqBase*ratio2*vib;
f3=freqBase*ratio3*vib; f4=freqBase*ratio4*vib; f5=freqBase*ratio5*vib;
f6=freqBase*ratio6*vib; f7=freqBase*ratio7*vib; f8=freqBase*ratio8*vib;

dryL= partL(f0,db1,pan0,1-0.12)+partL(f1,db2,pan1,1-0.08)+partL(f2,db3,pan2,1-0.05)
   + partL(f3,db4,pan3,1-0.02)+partL(f4,db5,pan4,1+0.00)+partL(f5,db6,pan5,1+0.02)
   + partL(f6,db7,pan6,1+0.05)+partL(f7,db8,pan7,1+0.08)+partL(f8,db9,pan8,1+0.12);

dryR= partR(f0,db1,pan0,1-0.12)+partR(f1,db2,pan1,1-0.08)+partR(f2,db3,pan2,1-0.05)
   + partR(f3,db4,pan3,1-0.02)+partR(f4,db5,pan4,1+0.00)+partR(f5,db6,pan5,1+0.02)
   + partR(f6,db7,pan6,1+0.05)+partR(f7,db8,pan7,1+0.08)+partR(f8,db9,pan8,1+0.12);

g=power*master;
process = dryL*g, dryR*g;