within ThermoCycle.Examples.TestComponents;
model Flow1DConst
parameter Integer N = 5;
  Components.FluidFlow.Pipes.FlowConst flowConst(N=N)
    annotation (Placement(transformation(extent={{20,84},{-42,34}})));
  Components.FluidFlow.Reservoirs.Source_Cdot3 source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{50,68},{70,88}})));
  Components.HeatFlow.Sources.Source_T             source_T(N=N)
    annotation (Placement(transformation(extent={{-52,-4},{-32,16}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
equation
  connect(source_Cdot.flange, flowConst.flange_Cdot) annotation (Line(
      points={{68.2,77.9},{74,77.9},{74,59},{20,59}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(const.y,source_T. Temperature) annotation (Line(
      points={{-69,14},{-42,14},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source_T.thermalPort, flowConst.Wall_int) annotation (Line(
      points={{-42.1,1.9},{-42.1,-12},{-11,-12},{-11,46.5}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Flow1DConst;
