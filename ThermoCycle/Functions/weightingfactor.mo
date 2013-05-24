within ThermoCycle.Functions;
function weightingfactor "transition weighting factor for initialization"
  input Real t_init;
  input Real length;
  input Real t;
  output Real y;
algorithm
  if t < t_init then
    y := 0;
  elseif t < t_init + length then
    y := (0.5 - 0.5*cos((t - t_init)*Modelica.Constants.pi/length));
  else
    y := 1;
  end if;
  annotation (smoothOrder=1,derivative = weightingfactor_der);
end weightingfactor;
