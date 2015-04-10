within ThermoCycle.Obsolete;
model SolarCollectorInc_24_01_2014
replaceable package Medium1 =
      ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66                         constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/************************************* PARAMETERS ********************************************************/

constant Real  pi = Modelica.Constants.pi;
//FOCUS
//parameter Boolean PTR "Choose type of collector";
//parameter Boolean UVAC "Choose type of collector";
/**************************** Optical Parameter Values give an eta_opt = 0.7263 ****************************/
parameter Real eps1 = 0.9754 "HCE Shadowing" annotation (Dialog(group="Optical Properties", tab="General"));
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

/**************************** GEOMETRIES ****************************/
parameter Integer N = 2 "Number of nodes";
parameter Integer Nt = 1 "Number of tubes";
parameter Modelica.SIunits.Length L "Length of tube";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi*Nt
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L*Nt
    "Internal volume of the metal tube";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";

/**************************** GLASS PROPERTIES****************************/
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

/**************************** TUBE PROPERTIES ****************************/
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube"
                                                                         annotation (Dialog(group="Properties of the metal envelope", tab="General"));
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.0025 "tube thickness"
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

/**************************** PRESSURE VACUUM ****************************/
parameter Modelica.SIunits.Pressure Pvacuum "Vacuum Pressure [Pa]"
                                                                  annotation (Dialog(group="Vacuum properties: between metal and glass envelope", tab="General"));

/**************************** Parameter for coefficient of heat transfer air ****************************/
parameter Real Pr "Prandt number"
                                 annotation (Dialog(group="Atmospheric characteristic", tab="General"));
parameter Modelica.SIunits.Pressure Patm "Atmosphere Pressure [Pa]"
                                                                   annotation (Dialog(group="Atmospheric characteristic", tab="General"));

/**************************** TEMPERATURE INITIALIZATION GLASS AND METAL WALL ****************************/
parameter Modelica.SIunits.Temperature T_g_start_in
    "Temperature at the inlet of the glass" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_g_start_out
    "Temperature at the outlet of the glass" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_in
    "Temperature at the inlet of the tube" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_out
    "Temperature at the outlet of the tube" annotation (Dialog(tab="Initialization"));
// Flow-1D
// Parameters for convective heat transfer in the fluid //

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient" annotation (Dialog(group="Heat transfer", tab="General"));
//parameter Real kw "Exponent of the mass flow rate in the h.t.c. correlation";
parameter Modelica.SIunits.MassFlowRate Mdotnom "Total nominal Mass flow";
// Fluid initial values
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Initialization options", tab="Initialization"));

/********************************************    NUMERICAL OPTION   ********************************************************/

  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

   /*************************** HEAT TRANSFER ************************************/

replaceable model FluidHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

/******************************************************************* COMPONENTS **************************************************/

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
    annotation (Placement(transformation(extent={{-30,-10},{14,36}})));
  ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc     SolarTube(redeclare
      package Medium =                                                                        Medium1,
    redeclare final model Flow1DimIncHeatTransferModel =
        FluidHeatTransferModel,
    N=N,
    A=A_lateral,
    V=V_tube_int,
    Unom=Unom,
    pstart=pstart,
    Tstart_inlet=Tstart_inlet,
    Tstart_outlet=Tstart_outlet,
    Mdotnom=Mdotnom,
    steadystate=steadystate_T_fl,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-32,-24},{32,24}},
        rotation=90,
        origin={48,14})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-88,54},{-48,94}}),
        iconTransformation(extent={{-72,60},{-32,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-88,12},{-48,52}}),
        iconTransformation(extent={{-72,10},{-32,50}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-88,-26},{-48,14}}),
        iconTransformation(extent={{-72,-38},{-32,2}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-90,-80},{-50,-40}}),
        iconTransformation(extent={{-72,-94},{-32,-54}})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,88},{10,108}}),
        iconTransformation(extent={{-10,92},{10,112}})));
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
SummaryClass Summary( T_profile( n=N, T_fluid = SolarTube.Cells[:].T,  T_int_t = solAbs.T_int_t[1:1:N],T_t = solAbs.T_t[1:1:N],T_ext_t = solAbs.T_ext_t[1:1:N],T_int_g = solAbs.T_int_g[1:1:N],T_g = solAbs.T_g[1:1:N],T_ext_g = solAbs.T_ext_g[1:1:N]),Eta_solarCollector= solAbs.Eta_TOT,Philoss = solAbs.Phi_loss,Q_htf = SolarTube.Q_tot);

equation
  connect(solAbs.wall_int, SolarTube.Wall_int) annotation (Line(
      points={{11.8,13},{21.7,13},{21.7,14},{38,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(SolarTube.OutFlow, OutFlow) annotation (Line(
      points={{47.8,40.6667},{47.8,98},{0,98}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, SolarTube.InFlow) annotation (Line(
      points={{10,-90},{48,-90},{48,-12.6667}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(DNI, solAbs.DNI) annotation (Line(
      points={{-70,-60},{-46,-60},{-46,-54},{-38,-54},{-38,-4.48},{-27.36,-4.48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb, solAbs.Tamb) annotation (Line(
      points={{-68,-6},{-44,-6},{-44,7.02},{-26.92,7.02}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Theta, solAbs.Theta) annotation (Line(
      points={{-68,32},{-46,32},{-46,18.06},{-26.92,18.06}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v_wind, solAbs.v_wind) annotation (Line(
      points={{-68,74},{-40,74},{-40,32.32},{-26.92,32.32}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-60,-100},{60,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-60,-100},{
            60,100}}, preserveAspectRatio=true),
                                      graphics={Rectangle(
          extent={{-60,100},{60,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid), Text(
          extent={{-26,32},{34,-4}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="Sol.Coll. 
 Inc.")}),Documentation(info="<HTML>

<p><big>The <b>SolarCollectorInc</b> model is based on the same modeling concept of the <a href=\"modelica://ThermoCycle.Components.Units.Solar.SolarCollector\">SolarCollector</a> model.
<p><big> The heat transfer fluid in this case is considered incompressible and so the  <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc\">Flow1DimInc</a> is used.
 

</HTML>"));
end SolarCollectorInc_24_01_2014;
