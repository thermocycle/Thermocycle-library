within ThermoCycle.Functions.TestRig;
function PressureDropCorrelation_LP
  input Real M_flow;
  output Real DELTAp;
protected
  Real k1 = 38453.9;
  Real k2 = 23282.7;
algorithm
  DELTAp :=k1*M_flow + k2*M_flow^2;
  annotation (smoothOrder=1);
end PressureDropCorrelation_LP;
