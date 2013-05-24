within ThermoCycle.Functions.ORCNext;
function correlation_pumpORCNext
  input Real f_pp;
  input Real r_p;
  output Real epsilon_s;
algorithm
  epsilon_s := -5.75342869E-02+9.11118956E-03*f_pp-7.77495730E-03*r_p;
  epsilon_s := min(0.8, epsilon_s);
  epsilon_s := max(0, epsilon_s);
  annotation (smoothOrder=1);
end correlation_pumpORCNext;
