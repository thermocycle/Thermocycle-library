within ThermoCycle.Functions;
function weightingfactor_der "transition weighting factor for initialization"
  input Real t_init;
  input Real length;
  input Real t;
  input Real t_init_der;
  input Real length_der;
  input Real t_der;
  output Real y;
algorithm
  if t < t_init then
    y := 0;
  elseif t < t_init + length then
    y := 0.5*Modelica.Constants.pi/length*sin((t - t_init)*Modelica.Constants.pi/length)*t_der;
  else
    y := 0;
  end if;
  annotation (smoothOrder=1);
end weightingfactor_der;
