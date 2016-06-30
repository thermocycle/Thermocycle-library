within ThermoCycle.Components.FluidFlow.Sensors;
model SensTpw "Temperature sensor for moist air"
  extends ThermoCycle.Icons.Water.SensP;
replaceable package Medium = ThermoCycle.Media.DummyFluid
                                          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);

  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{-60,40},{-100,80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput w "Absolute humidity ratio" annotation (Placement(transformation(
          extent={{32,112},{72,152}},rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,136})));

  Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy of the fluid";
  Medium.MassFraction[2] X
    "Mass fraction of the moist air, see moist air media information";
Medium.ThermodynamicState fluidState "Thermodynamic state of the fluid";
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium,
      m_flow(min=0))
    annotation (Placement(transformation(extent={{-8,-108},{12,-88}}),
        iconTransformation(extent={{-16,-112},{16,-78}})));

equation
  InFlow.m_flow = 0 "Mass balance";
  // Set fluid properties
  X[1] = inStream(InFlow.Xi_outflow[1]);
  X[2] = 1 - inStream(InFlow.Xi_outflow[1]);
  w = X[1]/(1-X[1]);
  h = inStream(InFlow.h_outflow);
  fluidState = Medium.setState_phX(InFlow.p,h,X);
  T = Medium.temperature(fluidState);
  InFlow.p =p;
  // Boundary conditions
  InFlow.h_outflow = Medium.h_default;
  InFlow.Xi_outflow = inStream(InFlow.Xi_outflow);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{120,
            160}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{120,160}}),
                    graphics={Text(
          extent={{-38,68},{40,18}},
          lineColor={0,0,0},
          textString="p,T,w
"),                          Line(points={{-60,60},{-40,60}}),
        Line(points={{-6,-2.90699e-016},{10,0}},
          origin={0,106},
          rotation=90)}),
    Documentation(info="<HTML>
<p><big> Model <b>SensTp</b> represents an temperature and pressure sensor.
</html>"));
end SensTpw;
