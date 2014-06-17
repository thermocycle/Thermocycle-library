within ThermoCycle.Functions.Solar;
function T_start_inlet
  "Definition of inlet temperatures for collectors in series"
  extends Modelica.Icons.Function;

input Real T_start_inlet "inlet temperature";
input Real T_start_outlet "outlet temperature";
input Integer Ns "Number of emlement in series";
constant Real D_T = (T_start_outlet - T_start_inlet)/Ns;
output Real T_start_in[Ns];

algorithm
for i in 1:Ns loop
  T_start_in[i] :=T_start_inlet + D_T*(i - 1);
end for;

end T_start_inlet;
