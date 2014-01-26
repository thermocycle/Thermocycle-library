within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model RecipMachine_PV
  "Model of single cylinder with pressure and volume connectors"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.VolumeForces
    volumeForces(bore=bore) annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=-90,
        origin={73,135})));
  Modelica.Blocks.Interfaces.RealOutput volume( displayUnit="cm3")
    annotation (Placement(transformation(extent={{100,110},{120,130}}),
        iconTransformation(extent={{100,110},{120,130}})));
  Modelica.Blocks.Interfaces.RealInput pressure
    annotation (Placement(transformation(extent={{-120,100},{-80,140}}),
        iconTransformation(extent={{-120,100},{-80,140}})));
  outer Modelica.Fluid.System system;
  parameter Boolean use_p_crank = false "Use non-ambient crankcase pressure?";
  parameter Modelica.SIunits.AbsolutePressure p_crank(min=10,displayUnit="bar") = 101325
    "Custom crankcase pressure, counteracts chamber pressure forces"
  annotation (Evaluate = true,
                Dialog(enable = use_p_crank));
protected
Modelica.SIunits.Volume tmp;
Modelica.SIunits.AbsolutePressure p_crank_internal;
equation
  if use_p_crank then
    p_crank_internal = p_crank;
  else
    p_crank_internal = system.p_ambient;
  end if;
  tmp = volumeForces.s_rel * Modelica.Constants.pi * bore^2/4;
  volume = tmp;
  volumeForces.pressure = pressure - p_crank_internal;
  connect(slider.axis, volumeForces.flange_b) annotation (Line(
      points={{9,123},{52,123},{52,108},{74,108},{74,120},{73,120}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(slider.support, volumeForces.flange_a) annotation (Line(
      points={{9,141},{52,141},{52,160},{74,160},{74,150},{73,150}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-180},
            {180,180}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-180,-180},{180,180}}), graphics={Text(
          extent={{-120,80},{-80,40}},
          lineColor={0,0,255},
          textString="p",
          textStyle={TextStyle.Italic}), Text(
          extent={{100,80},{140,40}},
          lineColor={0,0,255},
          textString="V",
          textStyle={TextStyle.Italic}),
        Polygon(
          points={{-52,-32},{-52,150},{72,150},{72,-32},{80,-32},{80,160},
              {-60,160},{-60,-32},{-52,-32}},
          lineColor={0,0,0},
          fillColor={150,150,150},
          fillPattern=FillPattern.Solid)}));
end RecipMachine_PV;
