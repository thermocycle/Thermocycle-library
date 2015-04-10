within ThermoCycle.Obsolete;
model SolarCollector_24_01_2014 "Solar Collector Model"
replaceable package Medium1 = ThermoCycle.Media.R245fa_CPRP
                                           constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/*********************** PARAMETERS ****************************/

constant Real  pi = Modelica.Constants.pi;
//FOCUS
//parameter Boolean PTR "Choose type of collector";
//parameter Boolean UVAC "Choose type of collector";
/*********************** Optical Parameter Values give an eta_opt = 0.7263 ***********************/
parameter Real eps1 = 0.9754 "HCE Shadowing"
                                            annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps2 = 0.994 "Tracking error"
                                            annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps3 = 0.98 "Geometry error"
                                           annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real rho_cl = 0.935 "Mirror reflectivity"
                                                   annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps4 = 0.962566845 "Dirt on Mirrors"
                                                   annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps5 = 0.981283422 "Dirt on HCE"
                                               annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps6 = 0.96 "Unaccounted FORSE DA LEVARE"
                                                        annotation (Dialog(group="Optical Properties", tab="General"));

/*****************General Geometries**************************/
parameter Integer N = 2 "Number of cells";
parameter Integer Nt = 1 "Number of tubes";
parameter Modelica.SIunits.Length L "Length of tube";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";

final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi*Nt
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L*Nt
    "Internal volume of the metal tube";

/*********************** GLASS PROPERTIES ***********************/
parameter Modelica.SIunits.Density rho_g "Glass density"
                                                        annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp_g
    "Specific heat capacity of the glass"
                                         annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.ThermalConductivity lambda_g
    "Thermal conductivity of the glass"
                                       annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length Dext_g = 0.12 "External glass diameter"
                                                                         annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length th_g = 0.0025 "Glass thickness"
                                                                 annotation (Dialog(group="Properties of the glass envelope", tab="General"));

/***********************  TUBE PROPERTIES ***********************/
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube"
                                                                         annotation (Dialog(group="Properties of the metal envelope", tab="General"));
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.002 "tube thickness"
                                                                annotation (Dialog(group="Properties of the metal envelope", tab="General"));
                      //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
parameter Modelica.SIunits.Density rho_t "tube density"
                                                       annotation (Dialog(group="Properties of the metal envelope", tab="General"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp_t
    "Specific heat capacity of the tube"
                                        annotation (Dialog(group="Properties of the metal envelope", tab="General"));
parameter Modelica.SIunits.ThermalConductivity lambda_t
    "Thermal conductivity of the tube"
                                      annotation (Dialog(group="Properties of the metal envelope", tab="General"));

/*********************** PRESSURE VACUUM ***********************/
parameter Modelica.SIunits.Pressure Pvacuum "Vacuum Pressure [Pa]"
                                                                  annotation (Dialog(group="Vacuum properties: between metal and glass envelope", tab="General"));

/*********************** Parameter for coefficient of heat transfer air ***********************/
parameter Real Pr "Prandt number"
                                 annotation (Dialog(group="Atmospheric characteristic", tab="General"));
parameter Modelica.SIunits.Pressure Patm "Atmosphere Pressure [Pa]"
                                                                   annotation (Dialog(group="Atmospheric characteristic", tab="General"));

/*********************** TEMPERATURE INITIALIZATION GLASS AND METAL WALL ***********************/
parameter Modelica.SIunits.Temperature T_g_start_in
    "Temperature at the inlet of the glass"
                                           annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_g_start_out
    "Temperature at the outlet of the glass"
                                            annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_in
    "Temperature at the inlet of the tube"
                                          annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_out
    "Temperature at the outlet of the tube"
                                           annotation (Dialog(tab="Initialization"));
// Flow-1D

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
//parameter Real kw "Exponent of the mass flow rate in the h.t.c. correlation";
parameter Modelica.SIunits.MassFlowRate Mdotnom "Total nominal Mass flow";
// Fluid initial values
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector"
                                                            annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector"
                                                             annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector"
                                                            annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Initialization options", tab="Initialization"));

/***************************    NUMERICAL OPTION    *****************************************************/

  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));
   parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));

   /*******************************   HEAT TRANSFER MODEL    **************************************/

replaceable model FluidHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Fluid heat transfer model" annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

 /******************************* COMPONENTS ***********************************/

   ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.SolAbsForristal solAbs(
    eps1=eps1,
    eps2=eps2,
    eps3=eps3,
    rho_cl=rho_cl,
    eps4=eps4,
    eps5=eps5,
    eps6=eps6,
    N=N,
    Nt=Nt,
    L=L,
    A_P=A_P,
    rho_g=rho_g,
    Cp_g=Cp_g,
    lambda_g=lambda_g,
    rho_t=rho_t,
    Cp_t=Cp_t,
    lambda_t=lambda_t,
    Patm=Patm,
    Pr=Pr,
    Pvacuum=Pvacuum,
    T_g_start_in=T_g_start_in,
    T_g_start_out=T_g_start_out,
    T_t_start_in=T_t_start_in,
    T_t_start_out=T_t_start_out,
    Dext_g=Dext_g,
    th_g=th_g,
    Dext_t=Dext_t,
    th_t=th_t)
    annotation (Placement(transformation(extent={{-30,-16},{14,34}})));
  Components.FluidFlow.Pipes.Flow1Dim flow1Dim(redeclare package Medium = Medium1,
  redeclare final model Flow1DimHeatTransferModel = FluidHeatTransferModel,
    N=N,
    A=A_lateral,
    V=V_tube_int,
    Mdotnom=Mdotnom,
    Unom_l=Unom_l,
    Unom_tp=Unom_tp,
    Unom_v=Unom_v,
    pstart=pstart,
    Tstart_inlet=Tstart_inlet,
    Tstart_outlet=Tstart_outlet,
    Mdotconst=Mdotconst,
    max_der=max_der,
    filter_dMdt=filter_dMdt,
    max_drhodt=max_drhodt,
    TT=TT,
    steadystate=steadystate_T_fl,
    Discretization=Discretization)
                                  annotation (Placement(transformation(
        extent={{-27.5,-31.5},{27.5,31.5}},
        rotation=90,
        origin={34.5,7.5})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}}),
        iconTransformation(extent={{-10,-86},{10,-66}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-12,66},{8,86}}),
        iconTransformation(extent={{-12,66},{8,86}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-90,38},{-50,78}}),
        iconTransformation(extent={{-72,60},{-32,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-90,4},{-50,44}}),
        iconTransformation(extent={{-72,10},{-32,50}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-90,-38},{-50,2}}),
        iconTransformation(extent={{-72,-38},{-32,2}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-90,-76},{-50,-36}}),
        iconTransformation(extent={{-72,-94},{-32,-54}})));
public
record SummaryBase
  replaceable Arrays T_profile;
  record Arrays
   parameter Integer n;
   Modelica.SIunits.Temperature[n] T_fluid;
   Modelica.SIunits.Temperature[n] T_int_t;
   Modelica.SIunits.Temperature[n] T_t;
   Modelica.SIunits.Temperature[n] T_ext_t;
   Modelica.SIunits.Temperature[n] T_int_g;
   Modelica.SIunits.Temperature[n] T_g;
   Modelica.SIunits.Temperature[n] T_ext_g;
  end Arrays;
  Real Eta_solarCollector "Total efficiency of solar collector";
  Modelica.SIunits.HeatFlux Philoss "Heat Flux lost to the environment";
  Modelica.SIunits.Power Q_htf
      "Total heat through the termal heat transfer fluid flowing in the solar collector";
end SummaryBase;
replaceable record SummaryClass = SummaryBase;
SummaryClass Summary( T_profile( n=N, T_fluid = flow1Dim.Cells[:].T,  T_int_t = solAbs.T_int_t[1:1:N],T_t = solAbs.T_t[1:1:N],T_ext_t = solAbs.T_ext_t[1:1:N],T_int_g = solAbs.T_int_g[1:1:N],T_g = solAbs.T_g[1:1:N],T_ext_g = solAbs.T_ext_g[1:1:N]),Eta_solarCollector= solAbs.Eta_TOT,Philoss = solAbs.Phi_loss,Q_htf = flow1Dim.Q_tot);

equation
  connect(InFlow, flow1Dim.InFlow) annotation (Line(
      points={{0,-76},{34.5,-76},{34.5,-15.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(solAbs.wall_int, flow1Dim.Wall_int) annotation (Line(
      points={{11.8,9},{20.45,9},{20.45,7.5},{21.375,7.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(DNI, solAbs.DNI) annotation (Line(
      points={{-70,-56},{-36,-56},{-36,-10},{-27.36,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Theta, solAbs.Theta) annotation (Line(
      points={{-70,24},{-38,24},{-38,12},{-26.92,12},{-26.92,14.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v_wind, solAbs.v_wind) annotation (Line(
      points={{-70,58},{-34,58},{-34,30},{-26.92,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OutFlow, flow1Dim.OutFlow) annotation (Line(
      points={{-2,76},{34.2375,76},{34.2375,30.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Tamb, solAbs.Tamb) annotation (Line(
      points={{-70,-18},{-46,-18},{-46,2.5},{-26.92,2.5}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-80,-100},{60,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-80,-100},{60,100}},
                      preserveAspectRatio=true),
                                      graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid), Text(
          extent={{-28,18},{32,-18}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="Sol.Coll. 
")}),Documentation(info="<HTML>

<p><big>The <b>SolarCollector</b> model represents the solar field, composed by
  a single loop of parabolic collectors connected in series. The large ratio between diameter and length allows a 1-D discretization of the absorber tube.
   The model is composed by two sub-components: the <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a> and the <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolAbs\">SolAbs</a> components. 
They are connected together through a thermal port.
</p>
<p>
<img src=\"modelica://ThermoCycle/Resources/Images/SolarCollectorModel.png\">
</p>
<p><big>The <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a> models the Heat transfer fluid flow in the heat collector element.
<p><big>The <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolAbs\">SolAbs</a> represents the dynamic one-dimensional radial energy balance around the heat collector element.
</HTML>"));
end SolarCollector_24_01_2014;
