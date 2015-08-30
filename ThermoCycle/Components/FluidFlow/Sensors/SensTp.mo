within ThermoCycle.Components.FluidFlow.Sensors;
model SensTp "Temperature sensor for working fluid"
  extends ThermoCycle.Icons.Water.SensThrough;
replaceable package Medium = ThermoCycle.Media.DummyFluid
                                          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{-60,40},{-100,80}}, rotation=0)));
Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy of the fluid";
Medium.ThermodynamicState fluidState "Thermodynamic state of the fluid";
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium, m_flow(min= 0))
    annotation (Placement(transformation(extent={{-80,-58},{-60,-38}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium = Medium, m_flow(min= 0))
    annotation (Placement(transformation(extent={{60,-58},{80,-38}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  InFlow.p = OutFlow.p "No pressure drop";
  // Set fluid properties
  h = inStream(InFlow.h_outflow);
  fluidState = Medium.setState_ph(InFlow.p,h);
  T = Medium.temperature(fluidState);
  InFlow.p =p;
  // Boundary conditions
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-40,84},{38,34}},
          lineColor={0,0,0},
          textString="p,T"), Line(points={{-60,60},{-40,60}})}),
    Documentation(info="<HTML>
<p><big> Model <b>SensTp</b> represents an temperature and pressure sensor.
</html>"));
end SensTp;
