within ThermoCycle.Functions;
function correlation_open_expander_FF
  input Real log_Nrot;
  input Real rho;
  output Real FF;
algorithm
  FF := 8.36779658E+00 - 1.41098700E+00*log_Nrot + 6.19613713E-02*log_Nrot^
    2 - 5.13791668E-04*(rho) - 5.77341306E-07*(rho)^2;
  FF := min(1.592, FF);
  FF := max(0.576, FF);
  annotation (smoothOrder=1);
end correlation_open_expander_FF;
