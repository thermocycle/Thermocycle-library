within ThermoCycle.Components.FluidFlow.Sensors;
model SensP "Pressure sensor for working fluid"
  extends ThermoCycle.Icons.Water.SensThrough;
  replaceable package Medium = Media.R245fa constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
                annotation (Placement(transformation(extent={{-72,-44},{-52,-24}}),
        iconTransformation(extent={{-80,-58},{-40,-20}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium = Medium)
                 annotation (Placement(transformation(extent={{44,-50},{64,-30}}),
        iconTransformation(extent={{40,-60},{80,-20}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  // Boundary conditions
  InFlow.p = OutFlow.p;
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
  p = InFlow.p;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{-38,88},{44,28}},
          lineColor={0,0,0},
          textString="P")}),
    Documentation(info="<HTML>
    <p><big> Model <b>SensMdot</b> represents an ideal pressure sensor.
</html>
"));
end SensP;
