within ThermoCycle.Examples.TestComponents;
model Test_ExpansionTank

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    h_0=2.4E5,
    Mdot_0=3,
    UseT=true,
    redeclare package Medium = ThermoCycle.Media.Water,
    p=200000,
    T_0=313.15)
              annotation (Placement(transformation(extent={{-56,-22},{-36,-2}})));
  Components.Units.Tanks.ExpansionTank expansionTank(
    H_D=2.5,
    V_tank=5,
    L_lstart=0.2,
    Mdotnom=2,
    Unom=3,
    redeclare package Medium = ThermoCycle.Media.Water,
    p_const=false,
    Tstart=313.15,
    pstart=200000)
            annotation (Placement(transformation(extent={{6,2},{36,38}})));
   // redeclare model HeatTransfer =
    //    ThermoCycle.Components.HeatFlow.HeatTransfer.Ideal,

 Components.FluidFlow.Reservoirs.SinkVdot             sinkVdot(
    redeclare package Medium = ThermoCycle.Media.Water,
    h_out=167691,
    Vdot_0=0.001,
    pstart=200000)
    annotation (Placement(transformation(extent={{62,-22},{82,-2}})));
equation
  connect(sourceWF.flangeB, expansionTank.InFlow) annotation (Line(
      points={{-37,-12},{21,-12},{21,2.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expansionTank.InFlow, sinkVdot.flangeB) annotation (Line(
      points={{21,2.36},{21,-12},{62.2,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end Test_ExpansionTank;
