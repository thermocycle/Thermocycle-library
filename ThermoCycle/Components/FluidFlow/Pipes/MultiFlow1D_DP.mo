within ThermoCycle.Components.FluidFlow.Pipes;
model MultiFlow1D_DP
  replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby
    Modelica.Media.Interfaces.PartialMedium  annotation (choicesAllMatching = true);
parameter Integer nCells=2;
 parameter Modelica.SIunits.Volume V_f= 0.0397 "Total volume of fluid";
  parameter Modelica.SIunits.Area A_f= 2.7 "Total Lateral surface";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 2 "Nominal fluid flow rate"
                                                                              annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom= 100
    "Constant heat transfer coefficient" annotation (Dialog(tab="Nominal Conditions"));
   parameter Boolean UseNom=false
    "Use Nominal conditions to compute pressure drop characteristics";
 parameter Modelica.SIunits.Length h=0 "Static fluid head (dp = h * rho * g)"  annotation (Dialog(enable=(not UseNom)));
  parameter Real k= 38.4E3*9.5
    "Coefficient for linear pressure drop (dp = k * V_dot)"                            annotation (Dialog(enable=(not UseNom)));
  parameter Modelica.SIunits.Area A=(2*9.5*23282.7)^(-0.5)
    "Valve throat area for quadratic pressure drop (dp = 1/A²*M_dot²/(2*rho))"
                                                                                 annotation (Dialog(enable=(not UseNom)));

 parameter Modelica.SIunits.Pressure DELTAp_0=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0";
parameter Modelica.SIunits.Pressure p_nom=1e5 "Nominal pressure"
                       annotation (Dialog(tab="Nominal Conditions"));
parameter Modelica.SIunits.Temperature T_nom=423.15 "Nominal temperature"
                          annotation (Dialog(tab="Nominal Conditions"));
 parameter Modelica.SIunits.Density rho_nom=Medium.density_pT(
          p_nom,
          T_nom) "Nominal density"    annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_stat_nom=0
    "Nominal static pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_lin_nom=0
    "Nominal linear pressure drop"
                           annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_quad_nom=0
    "Nominal quadratic pressure drop"                                                      annotation (Dialog(tab="Nominal Conditions"));
   parameter Boolean   use_rho_nom=false
    "Use the nominal density for the computation of the pressure drop (i.e it depends only the flow rate)"
                           annotation (Dialog(tab="Nominal Conditions"));
      parameter Boolean constinit=false
    "if true, sets the pressure drop to a constant value at the beginning of the simulation in order to avoid oscillations"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean UseHomotopy=false
    "if true, uses homotopy to set the pressure drop to zero in the first initialization"
  annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure   DELTAp_start=DELTAp_stat_nom + DELTAp_lin_nom + DELTAp_quad_nom
    "Start Value for the pressure drop"                                                         annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Time t_init=10
    "if constinit is true, time during which the pressure drop is set to the constant value DELTAp_start"
    annotation (Dialog(tab="Initialization", enable=constinit));

 ThermoCycle.Components.FluidFlow.Pipes.AirFlowL[nCells] simpleAirCell(
    each Mdotnom=Mdotnom/nCells,
    each Unom=Unom,
    each Vi=V_f/nCells,
    each Ai=A_f/nCells)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
ThermoCycle.Components.Units.PdropAndValves.DP[ nCells] dP(redeclare package
      Medium =                                                                        Medium,
    each UseNom=UseNom,
    each h=h,
    each k=k,
    each A=A,
    each DELTAp_0=DELTAp_0,
    each Mdot_nom=Mdotnom/nCells,
    each p_nom=p_nom,
    each T_nom=T_nom,
    each rho_nom=rho_nom,
    each DELTAp_stat_nom=DELTAp_stat_nom/nCells,
    each DELTAp_lin_nom=DELTAp_lin_nom/nCells,
    each DELTAp_quad_nom=DELTAp_quad_nom/nCells,
    each use_rho_nom=use_rho_nom,
    each constinit=constinit,
    each UseHomotopy=UseHomotopy,
    each DELTAp_start=DELTAp_start/nCells,
    each t_init=t_init)
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
 ThermoCycle.Interfaces.Fluid.FlangeA flangeA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB flangeB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Modelica.Fluid.Fittings.MultiPort multiPort(redeclare package Medium = Medium,nPorts_b=nCells)
    annotation (Placement(transformation(extent={{-78,-20},{-62,20}})));
  Modelica.Fluid.Fittings.MultiPort multiPort1(redeclare package Medium = Medium,nPorts_b=nCells)
    annotation (Placement(transformation(extent={{70,-20},{54,20}})));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL[nCells] thermalPortCell
    annotation (Placement(transformation(extent={{-10,44},{10,64}}),
        iconTransformation(extent={{-40,40},{40,60}})));
equation
  connect(flangeA, multiPort.port_a) annotation (Line(
      points={{-98,0},{-78,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(multiPort1.port_a, flangeB) annotation (Line(
      points={{70,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleAirCell.Wall_ext, thermalPortCell) annotation (Line(
      points={{-20,5},{-20,54},{0,54}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(simpleAirCell.OutFlow, dP.InFlow) annotation (Line(
      points={{-10,0.1},{-12,0.1},{-12,0},{-1,0}},
      color={0,0,255},
      smooth=Smooth.None));

  for j in 1:nCells loop
  connect(multiPort.ports_b[j], simpleAirCell[j].InFlow);
  connect(dP[j].OutFlow, multiPort1.ports_b[j]);
  end for
  annotation (Diagram(graphics));

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-90,40},{88,26}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-90,24},{88,10}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-86,8},{92,-6}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-88,-8},{90,-22}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Text(
          extent={{-94,36},{-56,28}},
          lineColor={0,0,0},
          textString="1",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-82,-10},{-44,-18}},
          lineColor={0,0,0},
          textString="nCells",
          textStyle={TextStyle.Bold})}));
end MultiFlow1D_DP;
