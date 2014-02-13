within ThermoCycle.Examples.TestComponents;
model TestNozzle
  Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.Nozzle
    leakageNozzle(
    redeclare package Medium = CoolProp2Modelica.Media.R718_CP,
    A_leak=5e-5,
    P_su_start=1500000,
    T_su_start=623.15,
    P_ex_start=1400000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.25,
    amplitude=3e5,
    phase=1.5707963267949,
    offset=14e5)
    annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
  Modelica.Fluid.Sources.Boundary_ph boundary1(
    nPorts=1,
    use_p_in=true,
    redeclare package Medium = CoolProp2Modelica.Media.R718_CP)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(
    nPorts=1,
    redeclare package Medium = CoolProp2Modelica.Media.R718_CP,
    p=1500000,
    T=623.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(sine.y, boundary1.p_in) annotation (Line(
      points={{-71,50},{88,50},{88,8},{82,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], leakageNozzle.su) annotation (Line(
      points={{-60,0},{-36,0},{-36,0.2},{-10.2,0.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leakageNozzle.ex, boundary1.ports[1]) annotation (Line(
      points={{10,0.2},{36,0.2},{36,0},{60,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestNozzle;
