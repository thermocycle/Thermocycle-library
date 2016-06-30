within ThermoCycle.Components.FluidFlow.Sensors;
model SensP "Pressure sensor for working fluid"
  extends ThermoCycle.Icons.Water.SensP;
  replaceable package Medium = ThermoCycle.Media.DummyFluid
                                            constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium, m_flow(min= 0))
                annotation (Placement(transformation(extent={{-72,-44},{-52,-24}}),
        iconTransformation(extent={{-20,-110},{20,-72}})));
equation
  // Boundary conditions
  InFlow.m_flow = 0 "No mass flow rate entering the sensor";
  InFlow.h_outflow = Medium.h_default;
  p = InFlow.p;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-38,88},{44,28}},
          lineColor={0,0,0},
          textString="P")}),
    Documentation(info="<HTML>
    <p><big> Model <b>SensMdot</b> represents an ideal pressure sensor.
</html>
"));
end SensP;
