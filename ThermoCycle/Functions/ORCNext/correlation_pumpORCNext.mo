within ThermoCycle.Functions.ORCNext;
function correlation_pumpORCNext
  input Real f_pp;
  input Real r_p;
  output Real epsilon_s;
algorithm
  epsilon_s := -6.53917026E-02+7.59307458E-03*f_pp+1.26794211E-04*r_p;
  epsilon_s := min(0.8, epsilon_s);
  epsilon_s := max(0, epsilon_s);
  annotation (smoothOrder=1);
end correlation_pumpORCNext;
