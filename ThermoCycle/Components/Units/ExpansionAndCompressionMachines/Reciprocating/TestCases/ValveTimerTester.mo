within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.TestCases;
model ValveTimerTester

  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.ValveTimer
    valveTimer annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=2,
    amplitude=250,
    offset=750)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Continuous.Integrator fakeCrankShaft
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(sine.y, fakeCrankShaft.u) annotation (Line(
      points={{-59,50},{-50,50},{-50,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fakeCrankShaft.y, valveTimer.angle_in) annotation (Line(
      points={{-19,10},{-10,10},{-10,-30},{-2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end ValveTimerTester;
