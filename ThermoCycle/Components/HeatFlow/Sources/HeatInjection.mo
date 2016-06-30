within ThermoCycle.Components.HeatFlow.Sources;
model HeatInjection "Lumped heat injection in a fluid flow"

replaceable package Medium = ThermoCycle.Media.DummyFluid
                                          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model"                                                     annotation (choicesAllMatching = true);

Modelica.SIunits.MassFlowRate M_dot "Exhaust mass flow rate";

  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium,
      m_flow(min=0))
    annotation (Placement(transformation(extent={{-86,-30},{-66,-10}}),
        iconTransformation(extent={{-86,-30},{-66,-10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium, m_flow(min=0))
    annotation (Placement(transformation(extent={{90,-30},{110,-10}}),
        iconTransformation(extent={{90,-30},{110,-10}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow(start=Q_flow_start) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-10}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={2,20})));  //Heat transfer rate [W]
  parameter Real Q_flow_start = 200 "Heat injection start value [W]"
                                   annotation (Dialog(tab="Initialization"));
equation

  //Mass Balance
  M_dot = InFlow.m_flow;
  M_dot = -OutFlow.m_flow;

  //No pressure drop
  InFlow.p = OutFlow.p;

//*A_heatinjection

  // Boundary conditions
  InFlow.h_outflow = if (M_dot<0) then inStream(OutFlow.h_outflow)-Q_flow/M_dot else 1E6;
  OutFlow.h_outflow = if (M_dot>0) then inStream(InFlow.h_outflow)+Q_flow/M_dot else 1E6;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-80,-60},{100,
            20}}),      graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-80,-60},{100,20}}),
                    graphics={Rectangle(
          extent={{-80,20},{100,-60}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0})}),
    Documentation(info="<HTML>
<p><big> Model <b>SensTp</b> represents an temperature and pressure sensor.
</html>"));
end HeatInjection;
