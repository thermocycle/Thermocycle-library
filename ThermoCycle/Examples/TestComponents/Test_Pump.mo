within ThermoCycle.Examples.TestComponents;
model Test_Pump

  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump
                                          pump(
    PumpType=ThermoCycle.Functions.Enumerations.PumpTypes.UD,
    X_pp0=1,
    eta_em=1,
    eta_is=1,
    epsilon_v=1,
    f_pp0=50,
    V_dot_max=0.0039,
    M_dot_start=3,
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.FF)
    annotation (Placement(transformation(extent={{-14,-16},{12,10}})));
  Components.FluidFlow.Reservoirs.SourceP sourceP(
    redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66,
    p0=115794,
    T_0=389.15)
    annotation (Placement(transformation(extent={{-98,-16},{-78,4}})));
  Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package Medium =
        ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66, p0=
        150000) annotation (Placement(transformation(extent={{54,2},{74,22}})));
  Modelica.Blocks.Sources.Constant const(k=0.5)
    annotation (Placement(transformation(extent={{-62,42},{-42,62}})));
equation
  connect(sourceP.flange, pump.InFlow) annotation (Line(
      points={{-78.6,-6},{-46,-6},{-46,-2.35},{-10.36,-2.35}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.OutFlow, sinkP.flangeB) annotation (Line(
      points={{6.28,6.62},{30.14,6.62},{30.14,12},{55.6,12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(const.y, pump.flow_in) annotation (Line(
      points={{-41,52},{-18,52},{-18,54},{-5.16,54},{-5.16,7.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Test_Pump;
