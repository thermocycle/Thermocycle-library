within ThermoCycle.Functions.TestRig;
function GenericCentrifugalPump_IsentropicEfficiency
  input Real f_pp;
  input Real r_p;
  output Real epsilon_s;
protected
  Real r_p_star;
  Real f_pp_star;
algorithm
  r_p_star := (r_p-9)/9;
  f_pp_star := (f_pp - 30) / 30;
  epsilon_s := 1.64002163E-01 +  2.61635282E-01*f_pp_star  -   3.93078704E-01*f_pp_star^2 - 7.82556670E-03*r_p_star + 1.91223439E-05*r_p_star^2 + 5.89131488E-02*f_pp_star*r_p_star;
  epsilon_s := min(0.8, epsilon_s);
  epsilon_s := max(0, epsilon_s);
  annotation (smoothOrder=1);
end GenericCentrifugalPump_IsentropicEfficiency;
