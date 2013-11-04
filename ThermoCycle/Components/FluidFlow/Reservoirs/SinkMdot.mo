within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkMdot "Mass sink for current working fluid"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model";
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Imposed volumetric flow rate";
  parameter Medium.SpecificEnthalpy h_out=1e5 "Nominal specific enthalpy";
  parameter Medium.AbsolutePressure pstart = 1E6 "Start value for the pressure";
  Modelica.SIunits.MassFlowRate Mdot;
  Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
equation
  flangeB.m_flow= Mdot;
  Mdot = Mdot_0;
  flangeB.h_outflow= h_out;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><big> Model <b>SinkMdot</b> sets the boundary mass flow of the fluid flowing from the port to the model (i.e. into the model).


 


</html>"),
    conversion(noneFromVersion=""));
end SinkMdot;
