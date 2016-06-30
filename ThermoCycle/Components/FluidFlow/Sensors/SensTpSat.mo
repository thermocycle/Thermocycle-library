within ThermoCycle.Components.FluidFlow.Sensors;
model SensTpSat
  "Temperature and pressure sensor for working fluid, compute the saturation properties as well"
  extends ThermoCycle.Icons.Water.SensP;
replaceable package Medium = ThermoCycle.Media.DummyFluid
                                          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);

 /********************* CONNECTORS *********************/
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{60,46},{100,86}}, rotation=0),
        iconTransformation(extent={{60,46},{100,86}})));

  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{-60,40},{-100,80}}, rotation=0)));

  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium, m_flow(min= 0))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-16,-112},{18,-80}})));

Modelica.Blocks.Interfaces.RealOutput Tsat annotation (Placement(
        transformation(extent={{60,4},{100,44}},  rotation=0),
        iconTransformation(extent={{60,4},{100,44}})));

/********************* VARIABLES *********************/
Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy of the fluid";
Medium.ThermodynamicState fluidState "Thermodynamic state of the fluid";
Medium.SaturationProperties sat "Saturation state";

equation
  //Saturation
  sat = Medium.setSat_p(p);

  // Set fluid properties
  h = actualStream(InFlow.h_outflow);
  fluidState = Medium.setState_ph(InFlow.p,h);
  T = Medium.temperature(fluidState);
  InFlow.p =p;
  Tsat = sat.Tsat;

  InFlow.m_flow = 0 "Mass balance";
  // Boundary conditions
  InFlow.h_outflow = Medium.h_default;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-40,84},{38,34}},
          lineColor={0,0,0},
          textString="p,T"), Line(points={{-60,60},{-40,60}}),
        Text(
          extent={{64,8},{108,-14}},
          lineColor={0,0,255},
          textString="Tsat")}),
    Documentation(info="<HTML>
<p><big> Model <b>SensTp</b> represents an temperature and pressure sensor.
<p><b><big>Modelling options</b></p>
<p><big> <li> ComputeSat: if false saturation properties are not computed in the fluid model and they can be passed as a parameter.
</html>"));
end SensTpSat;
