within ThermoCycle.Components.FluidFlow.Pipes;
model MultiFlow1D
  "1-D fluid flow model. The Cells are in parallel and a pressure drop is considered"

  replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby
    Modelica.Media.Interfaces.PartialMedium  annotation (choicesAllMatching = true);

/************ Thermal and fluid ports ***********/
ThermoCycle.Interfaces.Fluid.FlangeA flangeA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB flangeB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Modelica.Fluid.Fittings.MultiPort multiPort(redeclare package Medium = Medium,nPorts_b=N)
    annotation (Placement(transformation(extent={{-78,-20},{-62,20}})));
  Modelica.Fluid.Fittings.MultiPort multiPort1(redeclare package Medium = Medium,nPorts_b=N)
    annotation (Placement(transformation(extent={{70,-20},{54,20}})));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL[N] thermalPortCell
    annotation (Placement(transformation(extent={{-10,44},{10,64}}),
        iconTransformation(extent={{-40,40},{40,60}})));

  /************ Geometric characteristics **************/
  parameter Integer N(min=1) = 10 "number of Cells";
  parameter Modelica.SIunits.Volume V_f= 0.0397 "Total volume of fluid";
  parameter Modelica.SIunits.Area A_f= 2.7 "Total Lateral surface";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 2 "Nominal fluid flow rate"
                                                                              annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom= 100
    "Constant heat transfer coefficient" annotation (Dialog(tab="Nominal Conditions"));
   parameter Boolean UseNom=false
    "Use Nominal conditions to compute pressure drop characteristics";

    /************************** PRESSURE DROP COEFFICIENTS *********************/

 parameter Modelica.SIunits.Length h=0 "Static fluid head (dp = h * rho * g)"  annotation (Dialog(enable=(not UseNom)));
  parameter Real k= 38.4E3*9.5
    "Coefficient for linear pressure drop (dp = k * V_dot)"                            annotation (Dialog(enable=(not UseNom)));
  parameter Modelica.SIunits.Area A=(2*9.5*23282.7)^(-0.5)
    "Valve throat area for quadratic pressure drop (dp = 1/A²*M_dot²/(2*rho))"
                                                                                 annotation (Dialog(enable=(not UseNom)));
 parameter Modelica.SIunits.Pressure DELTAp_0=500
    "Pressure drop below which a 3rd order interpolation is used for the computation of the flow rate in order to avoid infinite derivative at 0";

/************************** NOMINAL VALUES *********************/
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

/************************** INITIALIZATION OPTIONS *********************/
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

/******************************* HEAT TRANSFER MODEL **************************************/

replaceable model MultiFlow1DimHeatTransferModel =
      ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Fluid heat transfer model" annotation (choicesAllMatching = true);

   /****************************  CELLS ***************************************/
 ThermoCycle.Components.FluidFlow.Pipes.AirCell[N] simpleAirCell(
   redeclare each final package Medium = Medium,
   redeclare each final model HeatTransfer = MultiFlow1DimHeatTransferModel,
    each Mdotnom=Mdotnom/N,
    each Unom=Unom,
    each Vi=V_f/N,
    each Ai=A_f/N)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
ThermoCycle.Components.Units.PdropAndValves.DP[N] dP(redeclare package Medium
      =                                                                               Medium,
    each UseNom=UseNom,
    each h=h,
    each k=k,
    each A=A,
    each DELTAp_0=DELTAp_0,
    each Mdot_nom=Mdotnom/N,
    each p_nom=p_nom,
    each T_nom=T_nom,
    each rho_nom=rho_nom,
    each DELTAp_stat_nom=DELTAp_stat_nom/N,
    each DELTAp_lin_nom=DELTAp_lin_nom/N,
    each DELTAp_quad_nom=DELTAp_quad_nom/N,
    each use_rho_nom=use_rho_nom,
    each constinit=constinit,
    each UseHomotopy=UseHomotopy,
    each DELTAp_start=DELTAp_start/N,
    each t_init=t_init)
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));

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
      points={{-10,0.1},{-12,0.1},{-12,0},{7,0}},
      color={0,0,255},
      smooth=Smooth.None));
  for j in 1:N loop
  connect(multiPort.ports_b[j], simpleAirCell[j].InFlow);
  connect(dP[j].OutFlow, multiPort1.ports_b[j]);
  end for
  annotation (Diagram(graphics));

  annotation (Icon(graphics={
        Rectangle(
          extent={{-92,24},{86,10}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-92,40},{86,26}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-88,8},{90,-6}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Rectangle(
          extent={{-90,-8},{88,-22}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Forward,
          fillColor={175,175,175}),
        Text(
          extent={{-84,-10},{-46,-18}},
          lineColor={0,0,0},
          textString="nCells",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-96,36},{-58,28}},
          lineColor={0,0,0},
          textString="1",
          textStyle={TextStyle.Bold})}),
    Diagram(graphics(Line(
          points={{-60,-16},{-34,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{-32,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{24,0},{52,0}},
          color={0,0,255},
          smooth=Smooth.None))=
                     {Line(
          points={{-60,0},{-32,0}},
          color={0,0,255},
          smooth=Smooth.None), Line(
          points={{24,0},{52,0}},
          color={0,0,255},
          smooth=Smooth.None)}), Documentation(info="<HTML>  <p><big>This model describes the flow of a constant heat capacity fluid in parallel pipes. Each pipe is represented by the lumped model.
           It is obtained by connecting in parallel <b>N</b> <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.AirCell\">AirCell</a>
           The resulting discretization scheme is of the staggered type i.e. state variables are computed at the center of each cell and the node variables are calculated depending on the local discretization  (Upwind or Central difference). 
 </HTML>"));
end MultiFlow1D;
