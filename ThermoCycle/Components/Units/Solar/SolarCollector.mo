within ThermoCycle.Components.Units.Solar;
model SolarCollector
replaceable package Medium1 = Media.R245fa constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/*********************** PARAMETERS ****************************/

constant Real  pi = Modelica.Constants.pi;
//FOCUS
//parameter Boolean PTR "Choose type of collector";
//parameter Boolean UVAC "Choose type of collector";
// Optical Parameter Values give an eta_opt = 0.7263 //
parameter Real eps1 = 0.9754 "HCE Shadowing";
parameter Real eps2 = 0.994 "Tracking error";
parameter Real eps3 = 0.98 "Geometry error";
parameter Real rho_cl = 0.935 "Mirror reflectivity";
parameter Real eps4 = 0.962566845 "Dirt on Mirrors";
parameter Real eps5 = 0.981283422 "Dirt on HCE";
parameter Real eps6 = 0.96 "Unaccounted FORSE DA LEVARE";
// Parameter for coefficient of heat transfer air
parameter Real Pr "Prandt number";
parameter Modelica.SIunits.Pressure Patm "Atmosphere Pressure [Pa]";
//GEOMETRIES
parameter Integer N = 2 "Number of cells";
parameter Integer Nt = 1 "Number of tubes";
parameter Modelica.SIunits.Length L "Length of tube";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
    "Internal volume of the metal tube";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";
// GLASS PROPERTIES
parameter Modelica.SIunits.Density rho_g "Glass density";
parameter Modelica.SIunits.SpecificHeatCapacity Cp_g
    "Specific heat capacity of the glass";
parameter Modelica.SIunits.ThermalConductivity lambda_g
    "Thermal conductivity of the glass";
parameter Modelica.SIunits.Length Dext_g = 0.12 "External glass diameter";
parameter Modelica.SIunits.Length th_g = 0.0025 "Glass thickness";
// PRESSURE VACUUM
parameter Modelica.SIunits.Pressure Pvacuum "Vacuum Pressure [Pa]";
// TUBE PROPERTIES
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube";
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.002 "tube thickness";
                      //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
parameter Modelica.SIunits.Density rho_t "tube density";
parameter Modelica.SIunits.SpecificHeatCapacity Cp_t
    "Specific heat capacity of the tube";
parameter Modelica.SIunits.ThermalConductivity lambda_t
    "Thermal conductivity of the tube";
//TEMPERATURE INITIALIZATION GLASS AND METAL WALL
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
                                                                                                      annotation (Dialog(group="Intialization options", tab="Initialization"));

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
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
    "Fluid heat transfer model" annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

 /******************************* COMPONENTS ***********************************/

    Components.HeatFlow.Walls.SolAbs solAbs(
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
    annotation (Placement(transformation(extent={{-22,-24},{12,30}})));
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
        origin={48.5,7.5})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,92},{10,112}}),
        iconTransformation(extent={{-10,92},{10,112}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-88,60},{-48,100}}),
        iconTransformation(extent={{-72,60},{-32,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-84,10},{-44,50}}),
        iconTransformation(extent={{-72,10},{-32,50}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-80,-22},{-40,18}}),
        iconTransformation(extent={{-72,-38},{-32,2}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-84,-80},{-44,-40}}),
        iconTransformation(extent={{-72,-94},{-32,-54}})));
equation
  connect(OutFlow, flow1Dim.OutFlow) annotation (Line(
      points={{0,102},{38,102},{38,104},{48.2375,104},{48.2375,30.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, flow1Dim.InFlow) annotation (Line(
      points={{0,-100},{48.5,-100},{48.5,-15.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(solAbs.wall_int, flow1Dim.Wall_int) annotation (Line(
      points={{10.3,3},{20.45,3},{20.45,7.5},{35.375,7.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(DNI, solAbs.DNI) annotation (Line(
      points={{-64,-60},{-28,-60},{-28,-17.52},{-19.96,-17.52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb, solAbs.Tamb) annotation (Line(
      points={{-60,-2},{-19.62,-2},{-19.62,-4.02}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Theta, solAbs.Theta) annotation (Line(
      points={{-64,30},{-44,30},{-44,12},{-19.62,12},{-19.62,8.94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v_wind, solAbs.v_wind) annotation (Line(
      points={{-68,80},{-28,80},{-28,25.68},{-19.62,25.68}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-40,-100},{40,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-40,-100},{
            40,100}}, preserveAspectRatio=true),
                                      graphics={Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid)}));
end SolarCollector;
