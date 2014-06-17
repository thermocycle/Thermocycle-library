within ThermoCycle.Obsolete;
model AbsorberSchott_24_01_2014
// It solves the 1D radial energy balance around the Heat Transfer Element based on the Schott test analysis (see NREL "Heat loss Testing of Schott's 2008 PTR70 Parabolic Trough Receiver")
/*********************** INPUTS ***********************/
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-114,46},{-86,74}}),
        iconTransformation(extent={{-104,70},{-74,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-114,26},{-86,54}}),
        iconTransformation(extent={{-106,18},{-76,48}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-114,-16},{-86,12}}),
        iconTransformation(extent={{-106,-84},{-76,-54}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-114,8},{-86,36}}),
        iconTransformation(extent={{-106,-34},{-78,-6}})));

 parameter Boolean PTR "Set true to use the 2008 PTR collector";
/****************** CONSTANTS  *********************/
constant Real pi = Modelica.Constants.pi;
constant Real Sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
constant Real gg = Modelica.Constants.g_n
    "Standard acceleration of gravity on earth";

/************** PARAMETER ***********************/
// Optical Parameter //
parameter Real eps1 "HCE Shadowing"
                                   annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps2 "Tracking error"
                                    annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps3 "Geometry error"
                                    annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real rho_cl "Mirror reflectivity"
                                           annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps4 "Dirt on Mirrors"
                                     annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps5 "Dirt on HCE"
                                 annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps6 "Unaccounted"
                                 annotation (Dialog(group="Optical Properties", tab="General"));
//parameter Real Tau_g = if PTR then 0.963 else 0.95 "Glass Transmissivity";
//parameter Real Alpha_g = 0.02
    //"Glass Absorptivity CONSTANT see Forristal pag 18";
//parameter Real Eps_g = if PTR then 0.89 else 0.86
//    "Glass emissivity CONSTANT see Forristal pag 18";
parameter Real Alpha_t = if PTR then 0.97 else 0.96 "Tube Absorptivity";

/***********Heat loss Coefficients for Vacuum 2008 PTR70 ***********************/
parameter Real A0 = 4.05 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A1 = 0.247 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A2 = -0.00146 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A3 = 5.65E-6 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A4 = 7.62E-8 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A5 = -1.7 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));
parameter Real A6 = 0.0125 annotation (Dialog(group="Thermal energy loss correlation coefficients", tab="General"));

/*****************General Geometries**************************/
parameter Integer N = 2 "number of cells";
parameter Integer Nt = 1 "number of tubes";
parameter Modelica.SIunits.Length L "length of tubes";
final parameter Modelica.SIunits.Length ll= L/(N-1) "Length of each cell";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";

/******************** Geometries&Properties of the tube  *******************************/
parameter Modelica.SIunits.Length Dext_t "External diameter tube" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length th_t "tube thickness" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
final parameter Modelica.SIunits.Length rext_t = Dext_t/2
    " External Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
final parameter Modelica.SIunits.Length rint_t= rext_t-th_t
    "Internal Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));

/*************************** VARIABLES ****************************************/

/******************* Area of Collector and Reflector *****************************/
Modelica.SIunits.Area A_ext_t "Lateral external area of the tube";
Modelica.SIunits.Area Am_t "Area of the metal cross section";
Modelica.SIunits.Area A_ref "Area of the reflector";
Modelica.SIunits.Area A_int_t "Total Internal area";
Modelica.SIunits.Area A_int_t_l "Internal area of a cell";

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
IAM = Modelica.Math.cos(Theta*pi/180);

//Total area of the reflector //
A_ref = L*A_P*Nt;

//Geometries of the tube //
A_ext_t = pi*Dext_t*L*Nt;
assert(rext_t > rint_t, "External Radius must be greater than internal radius");
Am_t= (rext_t^2 - rint_t^2)*pi "Area of the metal cross section";
A_int_t = pi*(Dext_t-2*th_t)*L*Nt "Total Area of the internal tube";
A_int_t_l = pi*(Dext_t-2*th_t)*ll*Nt "Total Area of the internal tube";

// Optical efficiency //
eta_opt = eps1*eps2*eps3*eps4*eps5*eps6*rho_cl*IAM;

// Optical efficiency tube //
eta_opt_t = eta_opt * Alpha_t;

//Total thermal energy flow on the tube from the Sun [W]//
Q_tube_tot = DNI *eta_opt_t * A_ref;
for i in 1:N loop

//Heat losses from the absorber [W/m]
HL[i] = A0 + A1*(T_fluid[i]- Tamb) + A2*(T_fluid[i]-273.15)^2 + A3*(T_fluid[i]-273.15)^3 + A4*DNI*IAM*(T_fluid[i]-273.15)^2 + (v_wind)^(1/2)*(A5+A6*(T_fluid[i]-Tamb));

//Heat loss flux [W/m2]
Phi_loss_tube[i] = HL[i]/(pi*2*rint_t);

// Heat flux to the tube [W/m2]
Phi_tube_tot[i] = Q_tube_tot / A_int_t;

//Heat flux to the fluid

Phi_conv_f[i]= Phi_tube_tot[i] - Phi_loss_tube[i];

//Heat flux losses per reflector area needed for thermal efficiency validation [W/m2]
Phi_loss_ref[i] = HL[i]*L/ A_ref;

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
    
    <p><big>It solves the 1D radial energy balance around the Heat Collector Element of a solar collector based on the Schott test analysis
     (see <em>NREL Heat loss Testing of Schott's 2008 PTR70 Parabolic Trough Receiver</em> )
    
    
    
    
    </HTML>"));
end AbsorberSchott_24_01_2014;
