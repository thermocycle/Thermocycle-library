within ThermoCycle.Examples.TestComponents;
model Test_Nozzle

  ThermoCycle.Components.Units.PdropAndValves.Nozzle
    leakageNozzle(
    redeclare package Medium = Media.R718_CP,
    Afull=5e-5,
    gamma_start=1.3,
    Use_gamma=false,
    P_su_start=1500000,
    T_su_start=623.15,
    P_ex_start=1400000)
    annotation (Placement(transformation(extent={{-10,-14},{10,6}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.25,
    phase=0,
    amplitude=4.1e5,
    offset=12e5)
    annotation (Placement(transformation(extent={{-92,36},{-72,56}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    use_p_in=true,
    redeclare package Medium = Media.R718_CP)
    annotation (Placement(transformation(extent={{80,-14},{60,6}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
    nPorts=1,
    redeclare package Medium = Media.R718_CP,
    p=1500000,
    T=623.15) annotation (Placement(transformation(extent={{-80,-14},{-60,6}})));
equation
  connect(sine.y,boundary1. p_in) annotation (Line(
      points={{-71,46},{88,46},{88,4},{82,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1],leakageNozzle. su) annotation (Line(
      points={{-60,-4},{-36,-4},{-36,-3.8},{-10.2,-3.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leakageNozzle.ex,boundary1. ports[1]) annotation (Line(
      points={{10,-3.8},{36,-3.8},{36,-4},{60,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput);
end Test_Nozzle;
