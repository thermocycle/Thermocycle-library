within ThermoCycle.Functions.ORCNext;
function correlation_MdotORCNext
  input Real f_pp;
  output Real Mdot;
algorithm
  Mdot := -2.58550980E-01+1.72440427E-02*f_pp;
  annotation (smoothOrder=1);
end correlation_MdotORCNext;
