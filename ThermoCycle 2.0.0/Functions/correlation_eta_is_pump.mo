within ThermoCycle.Functions;
function correlation_eta_is_pump
  input Real Xpp;
  output Real eta_is;
algorithm
  eta_is := 0.931 - 0.11*ln(Xpp) - 0.2*ln(Xpp)^2 - 0.06*ln(Xpp)^3;
end correlation_eta_is_pump;
