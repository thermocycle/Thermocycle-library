within ThermoCycle.Components.Units.ControlSystems.Blocks;
model DELTAT
  // Calculate the superheating with the temperature and the pressure as inputs
  Modelica.Blocks.Interfaces.RealInput P "measured pressure" annotation (
      Placement(transformation(extent={{-110,54},{-86,78}}, rotation=0),
        iconTransformation(extent={{-110,54},{-86,78}})));
  Modelica.Blocks.Interfaces.RealInput T "measured" annotation (Placement(
        transformation(extent={{-112,-54},{-88,-30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput DELTAT annotation (Placement(
        transformation(extent={{92,-38},{130,0}}), iconTransformation(extent=
            {{94,20},{114,40}})));
  Modelica.Blocks.Interfaces.RealOutput Tsat annotation (Placement(
        transformation(extent={{92,20},{130,58}}), iconTransformation(extent=
            {{94,-20},{114,0}})));
equation
  Tsat = 273.15 - 328.62 - 0.361218*P^(1/2) + 35.9736*P^(1/3) - 260.867*P^(1/
    4) + 342.702*P^(1/5);
  DELTAT = T - Tsat;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-98,90},{102,-78}},
          lineColor={0,0,0},
          lineThickness=0.5), Text(
          extent={{-76,50},{92,-32}},
          lineColor={0,0,0},
          textString="DELTAT     ")}));
end DELTAT;
