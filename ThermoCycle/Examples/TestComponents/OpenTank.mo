within ThermoCycle.Examples.TestComponents;
model OpenTank

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    h_0=2.4E5,
    redeclare package Medium = ThermoCycle.Media.Water,
    Mdot_0=3,
    UseT=true,
    p=200000,
    T_0=313.15)
              annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot(
    redeclare package Medium = ThermoCycle.Media.Water,
    h_out=167691,
    Vdot_0=0.001,
    pstart=200000)
    annotation (Placement(transformation(extent={{46,26},{66,46}})));
  Components.Units.Tanks.OpenTank openTank(
    redeclare package Medium = ThermoCycle.Media.Water,
    H_D=2.5,
    V_tank=4,
    L_lstart=0.3,
    Mdotnom=2,
    p_ext=300000,
    Tstart=313.15,
    pstart=200000)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(sourceWF.flangeB, openTank.InFlow) annotation (Line(
      points={{-57,56},{-50,56},{-50,36},{-10,36},{-10,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(openTank.InFlow, sinkVdot.flangeB) annotation (Line(
      points={{-10,40},{-10,36},{46.2,36}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end OpenTank;
