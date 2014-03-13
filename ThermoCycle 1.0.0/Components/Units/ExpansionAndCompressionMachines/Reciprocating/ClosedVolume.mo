within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model ClosedVolume "Model of a confined volume without mass transfer"

  Modelica.Blocks.Interfaces.RealInput volume
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(extent={{120,-20},{80,20}})));
  Modelica.Blocks.Interfaces.RealOutput pressure
    annotation (Placement(transformation(extent={{-58,-10},{-78,10}}),
        iconTransformation(extent={{-80,-10},{-100,10}})));
    outer Modelica.Fluid.System system;
  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  Medium.BaseProperties props;
  //parameter Medium.Density rho_start = 1.2;
  parameter Medium.Temperature T_start = 1500 "Initial temperature";
  parameter Medium.AbsolutePressure p_start = 40*system.p_ambient
    "Initial pressure";
  parameter Modelica.SIunits.HeatFlowRate Q_dot = -10 "Constant heat flux";
  Modelica.SIunits.Mass m;
  Modelica.SIunits.InternalEnergy U;
  Modelica.SIunits.Power W_dot;
// initial algorithm
//    Medium.setState_pTX(p_start,T_start,{1});
initial algorithm
    m := Medium.density_pTX(p_start,T_start,{1})*volume;
    U := m*(Medium.specificEnthalpy_pTX(p_start,T_start,{1}) - p_start / Medium.density_pTX(p_start,T_start,{1}));
//    props.T =T_start;
//    props.p =p_start;
equation
    props.p = pressure;
    U    = m*props.u;
    der(m) = 0;
    props.d * volume = m;
    der(U) = W_dot + Q_dot;
    W_dot = -der(volume) * pressure;
  annotation (Icon(coordinateSystem(extent={{-80,-100},{80,100}},
          preserveAspectRatio=true),
                   graphics={
        Polygon(
          points={{-48,60},{-48,-60},{-40,-60},{-40,50},{40,50},{40,-60},
              {48,-60},{48,60},{-48,60}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          lineColor={0,0,0}),Text(
          extent={{60,40},{100,20}},
          lineColor={0,0,255},
          textString="V",
          textStyle={TextStyle.Italic}),
                           Text(
          extent={{-100,40},{-60,20}},
          lineColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="p"),
        Polygon(
          points={{-40,0},{40,0},{40,-20},{6,-20},{6,-80},{-6,-80},{-6,
              -20},{-40,-20},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-60,100},{60,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward,
          textString="closed")}),
                             Diagram(coordinateSystem(extent={{-80,-100},
            {80,100}}),              graphics));
end ClosedVolume;
