within ThermoCycle.Functions.Solar;
function T_start_outlet
  "Definition of outlet temperatures for collectors in series"
extends Modelica.Icons.Function;
input Real T_start_inlet;
input Real T_start_outlet;
input Integer Ns;
constant Real D_T = (T_start_outlet - T_start_inlet)/Ns;
output Real T_start_out[Ns];

algorithm
for i in 1:Ns loop
  T_start_out[i] :=T_start_inlet + D_T*(i);
end for;

end T_start_outlet;
