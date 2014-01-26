within ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber;
model AbsSchottSopo
// It solves the 1D radial energy balance around the Heat Transfer Element based on the Schott test analysis (see NREL "Heat loss Testing of Schott's 2008 PTR70 Parabolic Trough Receiver")
/*********************** INPUTS ***********************/
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-114,46},{-86,74}}),
        iconTransformation(extent={{-104,70},{-74,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta "In Radiants"
    annotation (Placement(transformation(extent={{-114,26},{-86,54}}),
        iconTransformation(extent={{-106,18},{-76,48}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-114,-16},{-86,12}}),
        iconTransformation(extent={{-106,-84},{-76,-54}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-114,8},{-86,36}}),
        iconTransformation(extent={{-106,-34},{-78,-6}})));

/****************** CONSTANTS  *********************/
constant Real Sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
constant Real gg = Modelica.Constants.g_n
    "Standard acceleration of gravity on earth";

/****************** GEOMETRY  *********************/
inner replaceable parameter
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.BaseGeometry
                                                                                        geometry
constrainedby
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.BaseGeometry
                                                                                       annotation (choicesAllMatching=true);

/************** PARAMETER ***********************/
// Optical Parameter //
parameter Real eps6= 1
    "Unaccounted losses in calculating collector optical efficiency"
                                   annotation (Dialog(group="Optical Properties", tab="General"));

/*****************General Geometries**************************/
parameter Integer N = 2 "number of cells";
final parameter Modelica.SIunits.Length ll= geometry.L/(N-1)
    "Length of each cell";

/*************************** VARIABLES ****************************************/

/********************* TEMPERATURES **********************************/
Modelica.SIunits.Temperature T_fluid[N] "temperature of the fluid";

/************* THERMAL FLOW ****************************************/
Modelica.SIunits.HeatFlowRate Q_tube_tot;

/**************************************** THERMAL FLOW per cell length [W/m] ****************************************/
Real HL[N] "Heat losses per meter";

/****************************************THERMAL FLUX ****************************************/
Modelica.SIunits.HeatFlux Phi_tube_tot[N] "Heat flux to the tube";
Modelica.SIunits.HeatFlux Phi_conv_f[N] "Heat flux to the fluid";
Modelica.SIunits.HeatFlux Phi_loss_tube[N] "Heat flux loss per tube surface";
Modelica.SIunits.HeatFlux Phi_loss_ref[N]
    "Heat flux loss per reflector surface";
Modelica.SIunits.HeatFlux Phi_loss_ref_m
    "Medium heat flux loss per reflector surface";

/**************************************** EFFICIENCIES ****************************************/
Real eta_opt;
Real eta_opt_t;
Real IAM "Incident Angle Modifier";
Real eta_th[N] "Thermal efficiency at each node";
Real eta_TOT[N] "Total efficiency : eta_th * eta_opt_t";
Real Eta_th "Average thermal efficiency";
Real Eta_TOT "Total Average efficiency";
  Interfaces.HeatTransfer.ThermalPort wall_int(N=N)
    annotation (Placement(transformation(extent={{78,-6},{98,14}}),
        iconTransformation(extent={{80,-10},{100,10}})));
equation
// Incidence angle modifier //
IAM = Modelica.Math.cos(Theta);

//Geometries of the tube //
assert(geometry.rext_t > geometry.rint_t, "External Radius must be greater than internal radius");

// Optical efficiency //
eta_opt = geometry.rho_cl*eps6*IAM;

// Optical efficiency tube //
eta_opt_t =  geometry.Alpha_t*geometry.tau_g*eta_opt;

//Total thermal energy flow on the tube from the Sun [W]//
Q_tube_tot = DNI *eta_opt_t * geometry.A_reflector;

for i in 1:N loop
//Heat losses from the absorber [W/m]
HL[i] = geometry.A0 + geometry.A1*(T_fluid[i]- Tamb) + geometry.A2*(T_fluid[i]-273.15)^2 + geometry.A3*(T_fluid[i]-273.15)^3 + geometry.A4*DNI*IAM*(T_fluid[i]-273.15)^2 + (v_wind)^(1/2)*(geometry.A5+geometry.A6*(T_fluid[i]-Tamb));

//Heat loss flux [W/m2]
Phi_loss_tube[i] = HL[i]/(geometry.pi*2*geometry.rint_t);

// Heat flux to the tube [W/m2]
Phi_tube_tot[i] = Q_tube_tot / geometry.A_int_t;

//Heat flux to the fluid

Phi_conv_f[i]= Phi_tube_tot[i] - Phi_loss_tube[i];

//Heat flux losses per reflector area needed for thermal efficiency validation [W/m2]
Phi_loss_ref[i] = HL[i]*geometry.L/ geometry.A_reflector;

//Efficiency
if Q_tube_tot > 0 then
eta_th[i] = Phi_conv_f[i] / Phi_tube_tot[i];
eta_TOT[i] = eta_th[i]*eta_opt_t;
else
eta_th[i] = 0;
eta_TOT[i] = 0;
end if;

//Connection
T_fluid[i] = wall_int.T[i];
wall_int.phi[i] = -Phi_conv_f[i];
end for;
//Thermal loss per reflector surface
Phi_loss_ref_m = sum(Phi_loss_ref)/N;
//THERMAL EFFICIENCY
Eta_th = sum(eta_th)/N;
//TOTAL EFFICIENCY
Eta_TOT = Eta_th * eta_opt_t;
                                                                                                      annotation(Dialog(tab = "Initialisation"),
             Diagram(graphics),
    Icon(graphics),Documentation(info="<HTML> 
    
    <p><big>It solves the 1D radial energy balance around the Heat Collector Element of a solar collector based on a correlation derived in 
  <em>F. Burkholder and C. Klutscher Heat loss Testing of Schott's 2008 PTR70 Parabolic Trough Receiver. Technical report. NREL May 2009</em> 
     
     <p><b><big>Modelling options</b></p>
    <p><big><ul><li>Geometry: It allows to choose between the Schott PTR70 receiver and the Sopogy  micro receiver -  Soponova (<a href=\"http://sopogy.com/products/index.php?id=31\">http://www.sopogy.com</a>). 
    
    
    

    
    
    
    
    </HTML>"));
end AbsSchottSopo;
