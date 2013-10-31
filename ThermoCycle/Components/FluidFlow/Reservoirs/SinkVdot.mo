within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkVdot "Volumetric flow sink for current working fluid"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model"  annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.VolumeFlowRate Vdot_0=0.0017
    "Imposed volumetric flow rate";
  parameter Medium.SpecificEnthalpy h_out=1e5 "Nominal specific enthalpy";
  parameter Medium.AbsolutePressure pstart = 1E6 "Start value for the pressure";
  Medium.AbsolutePressure p(start=pstart) "pressure of the fluid coming in";
  Medium.SpecificEnthalpy h "enthalpy of the fluid coming in";
  Medium.Density rho(start=Medium.density_ph(pstart,h_out))
    "density of the fluid coming in";
  Modelica.SIunits.SpecificVolume Vdot;
  Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  Modelica.Blocks.Interfaces.RealInput in_Vdot annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-24,72})));
equation
  Vdot = in_Vdot;
  h= inStream(flangeB.h_outflow);
  p= flangeB.p;
  rho= Medium.density_ph(p,h);
    flangeB.m_flow= Vdot*rho;
    flangeB.h_outflow= h_out;

    if cardinality(in_Vdot) == 0 then
 in_Vdot = Vdot_0;
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><b>Modelling options</b></p>

</html>"),
    conversion(noneFromVersion=""));
end SinkVdot;
