within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36.ParametrizedModels;
model orcMassFlow
  Real x;
  Modelica.Blocks.Interfaces.RealOutput  M_dot_orc
  annotation (Placement(transformation(extent={{90,-8},{110,12}})));

equation
  x = time;
  M_dot_orc =
  if x <300
    then 0.3061
  elseif x<2062
    then 0.3061 - 0.0929
 else  0.3058;

// the mass flow after the step up of the pump has a value a bit smaller than the previous one: 0.3058 instead of 0.3061
end orcMassFlow;
