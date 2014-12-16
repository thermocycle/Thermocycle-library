within ThermoCycle.Examples.TestFunctions;
model transition_tester
  parameter Integer n = 5;
  Real fValue "value before transition";
  Real gValue "value after transition";
  Real start "start of transition interval";
  Real stop "end of transition interval";
  Real position "current position";
  Real derF;
  Real derG "Derivatives of input functions";
  Real der0a;
  Real der0b;
  Real der0c;
  Real der0d;
  Real[n] derR08_0;
  Real[n] derR08_1;
  Real[n] derR08_2;
  Real[n] derGLF;
  Real R08_0th;
  Real R08_1st;
  Real R08_2nd;
  Real GLF_v;
  Real[n] derR08_0th;
  Real[n] derR08_1st;
  Real[n] derR08_2nd;
  Real[n] derGLF_v;
equation
  fValue = time;
  gValue = time^3;
  start = 0.3;
  stop  = 0.6;
  position = time;
  derF = der(fValue);
  derG = der(gValue);
  der0a = ThermoCycle.Functions.transition_factor(
                                             start=start,stop=stop,position=position,order=0);
  der0b = ThermoCycle.Functions.transition_factor(
                                             start=start,stop=stop,position=position,order=1);
  der0c = ThermoCycle.Functions.transition_factor(
                                             start=start,stop=stop,position=position,order=2);
  der0d = ThermoCycle.Functions.transition_factor(
                                             start=start,stop=stop,position=position,order=3);
  R08_0th = der0a*fValue + (1 - der0a)*gValue;
  R08_1st = der0b*fValue + (1 - der0b)*gValue;
  R08_2nd = der0c*fValue + (1 - der0c)*gValue;
  GLF_v   = der0d*fValue + (1 - der0d)*gValue;
  derR08_0[1] = der(der0a);
  derR08_1[1] = der(der0b);
  derR08_2[1] = der(der0c);
  derGLF[1]   = der(der0d);
  derR08_0th[1] = der(R08_0th);
  derR08_1st[1] = der(R08_1st);
  derR08_2nd[1] = der(R08_2nd);
  derGLF_v[1]   = der(GLF_v);
  for i in 2:n loop
    // factors
    derR08_0[i] = der(derR08_0[i-1]);
    derR08_1[i] = der(derR08_1[i-1]);
    derR08_2[i] = der(derR08_2[i-1]);
    derGLF[i]   = der(derGLF[i-1]);
    // and values
    derR08_0th[i] = der(derR08_0th[i-1]);
    derR08_1st[i] = der(derR08_1st[i-1]);
    derR08_2nd[i] = der(derR08_2nd[i-1]);
    derGLF_v[i]   = der(derGLF_v[i-1]);
  end for;
end transition_tester;
