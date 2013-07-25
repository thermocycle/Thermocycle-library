within ThermoCycle.Examples.TestComponents;
model failure_Cdot
  "check button gives an error, alghouth it calculates fine. If the upper or downer part is removed the error disappears"
 ThermoCycle.Components.FluidFlow.Reservoirs.Source_Cdot2  Heat_source1(
    cp=4232,
    Mdot_0=0.15,
    T_0=473.15)
    annotation (Placement(transformation(extent={{68,28},{84,44}})));
  ThermoCycle.Components.FluidFlow.Pipes.FlowConst flowConst(
    A=1,
    V=1e-3,
    Mdotnom=2,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff,
    N=2,
    Tstart_inlet=473.15,
    Tstart_outlet=473.15,
    steadystate_T=true)
    annotation (Placement(transformation(extent={{40,4},{20,24}})));
  Modelica.Blocks.Sources.Constant const2(k=0.15)
    annotation (Placement(transformation(extent={{-14,68},{-4,78}})));
  Modelica.Blocks.Sources.Constant const3(k=273.15 + 200)
    annotation (Placement(transformation(extent={{-28,50},{-18,60}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.Source_Cdot2 source_Cdot3_1
    annotation (Placement(transformation(extent={{20,54},{40,74}})));
equation
  connect(Heat_source1.flange, flowConst.flange_Cdot) annotation (Line(
      points={{82.56,35.92},{92,35.92},{92,14},{40,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const3.y, source_Cdot3_1.source[2]) annotation (Line(
      points={{-17.5,55},{2.25,55},{2.25,64.65},{22.9,64.65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y, source_Cdot3_1.source[1]) annotation (Line(
      points={{-3.5,73},{9.25,73},{9.25,63.15},{22.9,63.15}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                               Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end failure_Cdot;
