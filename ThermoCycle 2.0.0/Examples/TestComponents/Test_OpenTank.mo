within ThermoCycle.Examples.TestComponents;
model Test_OpenTank

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
  ThermoCycle.Components.Units.Tanks.OpenTank
                                  openTank(
    redeclare package Medium = ThermoCycle.Media.Water,
    H_D=2.5,
    V_tank=4,
    L_lstart=0.3,
    Mdotnom=2,
    p_ext=300000,
    Tstart=373.15)
    annotation (Placement(transformation(extent={{-16,38},{4,58}})));
  Components.HeatFlow.Sensors.SensTp sensTp(redeclare package Medium =
        ThermoCycle.Media.Water)
    annotation (Placement(transformation(extent={{12,28},{32,48}})));
equation
  connect(sourceWF.flangeB, openTank.InFlow) annotation (Line(
      points={{-57,56},{-50,56},{-50,42},{-15.8,42},{-15.8,39.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensTp.OutFlow, sinkVdot.flangeB) annotation (Line(
      points={{29,33.2},{37.5,33.2},{37.5,36},{46.2,36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(openTank.OutFlow, sensTp.InFlow) annotation (Line(
      points={{3.8,39.6},{10,39.6},{10,33.2},{15,33.2}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,0},{100,
            100}}), graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,0},{100,100}})));
end Test_OpenTank;
