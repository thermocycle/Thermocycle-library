within ThermoCycle.Examples.TestComponents;
model ExpansionTank

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    h_0=2.4E5,
    redeclare package Medium = ThermoCycle.Media.Water,
    Mdot_0=3,
    UseT=true,
    p=200000,
    T_0=313.15)
              annotation (Placement(transformation(extent={{-88,-42},{-68,-22}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot sinkVdot(
    redeclare package Medium = ThermoCycle.Media.Water,
    h_out=167691,
    Vdot_0=0.001,
    pstart=200000)
    annotation (Placement(transformation(extent={{42,-42},{62,-22}})));
  Components.Units.Tanks.ExpansionTank expansionTank(
    redeclare package Medium = ThermoCycle.Media.Water,
    H_D=2.5,
    V_tank=5,
    L_lstart=0.2,
    Mdotnom=2,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
    Tstart=313.15,
    pstart=200000,
    Unom=3) annotation (Placement(transformation(extent={{4,2},{34,38}})));

  Components.HeatFlow.Sources.Source_T_cell source_T_cell
    annotation (Placement(transformation(extent={{-54,28},{-34,48}})));
  Modelica.Blocks.Sources.Constant AmbientTemperature(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
equation
  connect(sourceWF.flangeB, expansionTank.InFlow) annotation (Line(
      points={{-69,-32},{19,-32},{19,2.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expansionTank.InFlow, sinkVdot.flangeB) annotation (Line(
      points={{19,2.36},{19,-32},{42.2,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(AmbientTemperature.y, source_T_cell.Temperature) annotation (Line(
      points={{-67,54},{-43,54},{-43,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source_T_cell.ThermalPortCell, expansionTank.TankWall) annotation (
      Line(
      points={{-43.1,34.9},{-43.1,21.26},{5.2,21.26}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end ExpansionTank;
