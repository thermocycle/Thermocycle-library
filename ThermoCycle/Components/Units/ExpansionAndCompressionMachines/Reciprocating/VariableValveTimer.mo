within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
block VariableValveTimer
  "Open and close valves according to degree or time input."
  extends Modelica.Blocks.Interfaces.SO;

  parameter Boolean use_angle_in=true "Enable input connector";
  parameter Modelica.SIunits.AngularVelocity rpm=
      Modelica.SIunits.Conversions.from_rpm(60)
    annotation (Evaluate = true,
                Dialog(enable = not use_angle_in));
  parameter Boolean input_in_rad=false "Input in radians, else degrees"
    annotation (Evaluate = true,
                Dialog(enable = use_angle_in));

    Modelica.Blocks.Interfaces.RealInput angle_in if use_angle_in
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0), iconTransformation(extent={{-140,-20},{-100,20}})));

                input Modelica.SIunits.Angle open = Modelica.SIunits.Conversions.from_deg(170)
    "Half opened";

    input Modelica.SIunits.Angle close = Modelica.SIunits.Conversions.from_deg(190)
    "Half closed";

    input Modelica.SIunits.Angle switch = Modelica.SIunits.Conversions.from_deg(5)
    "Length for valve operation.";

protected
  Real value1;
  Real value2;
  Modelica.SIunits.Angle closeTmp;
  Modelica.SIunits.Angle openTmp;
  Modelica.SIunits.Angle angleTmp;
  Modelica.SIunits.Angle deltaOpen;
  Modelica.SIunits.Angle deltaClose;
  Modelica.Blocks.Interfaces.RealInput angle_in_internal;
algorithm

  openTmp  := noEvent(mod(open, 2*Modelica.Constants.pi));
  closeTmp := noEvent(mod(close,2*Modelica.Constants.pi));

  if noEvent(input_in_rad) then
    angleTmp := noEvent(mod(angle_in_internal,2*Modelica.Constants.pi));
  else
    angleTmp := noEvent(mod(Modelica.SIunits.Conversions.from_deg(angle_in_internal),2*Modelica.Constants.pi));
  end if;

  deltaOpen := angleTmp-openTmp;

  if noEvent((deltaOpen)<(-Modelica.Constants.pi)) then
    // use last revolution's values
    openTmp := openTmp - 2*Modelica.Constants.pi;
  elseif noEvent((deltaOpen)>(Modelica.Constants.pi)) then
    // use next revolution's values
    openTmp := openTmp + 2*Modelica.Constants.pi;
  end if;

  deltaClose := angleTmp-closeTmp;

  if noEvent((deltaClose)<(-Modelica.Constants.pi)) then
    // use last revolution's values
    closeTmp := closeTmp - 2*Modelica.Constants.pi;
  elseif noEvent((deltaClose)>(Modelica.Constants.pi)) then
    // use next revolution's values
    closeTmp := closeTmp + 2*Modelica.Constants.pi;
  end if;

  value1 := ThermoCycle.Functions.transition_factor(start=openTmp-switch/2,stop=openTmp+switch/2,position=angleTmp);
  value2 := ThermoCycle.Functions.transition_factor(start=closeTmp-switch/2,stop=closeTmp+switch/2,position=angleTmp);

  y := noEvent(max(0,value1-value2));

equation
  connect(angle_in, angle_in_internal);
  if noEvent(not use_angle_in) then
    angle_in_internal = Modelica.SIunits.Conversions.to_deg(time*rpm);
  end if;

  annotation (Icon(graphics={
        Text(
          extent={{100,60},{-100,100}},
          lineColor={175,175,175},
          textString="valve"),
    Line(points={{-82,60},{-82,-88}}, color={192,192,192}),
    Polygon(
      points={{-82,82},{-90,60},{-74,60},{-82,82}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-92,-78},{80,-78}}, color={192,192,192}),
    Polygon(
      points={{88,-78},{66,-70},{66,-86},{88,-78}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-83,-78},{-62,-78},{-32,32},{7,32},{37,-78},{59,-78},{88,32}},
                   color={0,0,0})}), Diagram(graphics));
end VariableValveTimer;
