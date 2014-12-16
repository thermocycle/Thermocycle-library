within ThermoCycle.Functions.TestRig;
function GenericCentrifugalPump_MassFlowRate
  input Real f_pp;
  output Real Mdot;
algorithm
  Mdot := -2.95825023E-01+1.79289093E-02*f_pp;
  annotation (smoothOrder=1);
end GenericCentrifugalPump_MassFlowRate;
