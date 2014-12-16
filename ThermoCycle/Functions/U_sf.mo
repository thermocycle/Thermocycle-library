within ThermoCycle.Functions;
function U_sf "Returns the secondary fluid heat transfer coefficient"
  input Real Unom;
  input Real Mdot;
  output Real y;
algorithm
  y := Unom*Mdot^0.8;
  annotation (smoothOrder=100);
end U_sf;
