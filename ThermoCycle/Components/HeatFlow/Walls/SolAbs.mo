within ThermoCycle.Components.HeatFlow.Walls;
model SolAbs
// It solves the 1D radial energy balance around the Heat Transfer Element based on the Forristal model see Forristal NREL 2003.
// INPUTS //
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}}),
        iconTransformation(extent={{-108,-96},{-68,-56}})));
    Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-106,64},{-66,104}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-106,2},{-66,42}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-106,-46},{-66,-6}})));
//MEDIUM //
//If PTR: true UVAC: false then Optical properties set for 2008 PTR70 receiver (data from NREL 2008 PTR70 report)
// If PTR: true UVAC true then Optical properties set for Uvac Cermet a coating with SEGS LS-2 solar collector
// else Optical properties set for Luz Cermet (Validation with SANDIA data) with SEGS LS-2 solar collector
 //parameter Boolean PTR;
 //parameter Boolean UVAC;
// CONSTANTS  //
constant Real pi = Modelica.Constants.pi;
constant Real Sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
constant Real gg = Modelica.Constants.g_n
    "Standard acceleration of gravity on earth";
// PARAMETER //
// Optical Properties //
parameter Real eps1 "HCE Shadowing";
parameter Real eps2 "Tracking error";
parameter Real eps3 "Geometry error";
parameter Real rho_cl "Mirror reflectivity";
parameter Real eps4 "Dirt on Mirrors";
parameter Real eps5 "Dirt on HCE";
parameter Real eps6 "Unaccounted";
parameter Real Tau_g = 0.963 "Glass Transmissivity"; //if PTR then 0.963 elseif UVAC then 0.965 else 0.935
   // "Glass Transmissivity";
parameter Real Alpha_g = 0.02
    "Glass Absorptivity CONSTANT see Forristal pag 18";
parameter Real Eps_g = 0.89 "Glass emissivity CONSTANT see Forristal pag 18";
//if PTR then 0.89 elseif  UVAC then 0.86 else 0.86
   // "Glass emissivity CONSTANT see Forristal pag 18";
parameter Real Alpha_t =  0.97 "Tube Absorptivity";//if PTR then 0.97 elseif  UVAC then 0.96 else 0.92
   // "Tube Absorptivity";
Real Eps_t[N] "Coating emissivity  funzione della temperature Forristal pag 18";
//General Geometries//
parameter Integer N = 2 "number of nodes";
parameter Integer Nt = 1 "number of tubes";
parameter Modelica.SIunits.Length L "length of tubes";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";
// AREA of Collector and Reflector //
Modelica.SIunits.Area A_ext_g "Lateral external area of the glass";
Modelica.SIunits.Area A_ext_t "Lateral external area of the tube";
Modelica.SIunits.Area A_ref "Area of the reflector";
Modelica.SIunits.Area Am_t "Area of the metal cross section";
Modelica.SIunits.Area Am_g "Area of the glass cross section";
//Geometries&Properties of the glass //
parameter Modelica.SIunits.Length Dext_g = 0.12 "External glass diameter";  //if PTR then 0.12 elseif UVAC then 0.115 else 0.115
parameter Modelica.SIunits.Length th_g = 0.0025 "Glass thickness"; //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
final parameter Modelica.SIunits.Length rext_g = Dext_g/2
    " External Radius Glass";
final parameter Modelica.SIunits.Length rint_g= rext_g-th_g
    "Internal Radius Glass";
parameter Modelica.SIunits.Density rho_g "Glass density";
parameter Modelica.SIunits.SpecificHeatCapacity Cp_g
    "Specific heat capacity of the glass";
parameter Modelica.SIunits.ThermalConductivity lambda_g
    "Thermal conductivity of the glass";
//Geometries&Properties of the tube  //
parameter Modelica.SIunits.Length Dext_t = 0.07 "External diameter tube";//if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t= 0.002 "tube thickness"; //if PTR then 0.002 elseif UVAC then 0.003 else 0.003
final parameter Modelica.SIunits.Length rext_t = Dext_t/2
    " External Radius Glass";
final parameter Modelica.SIunits.Length rint_t= rext_t-th_t
    "Internal Radius Glass";
parameter Modelica.SIunits.Density rho_t "tube density";
parameter Modelica.SIunits.SpecificHeatCapacity Cp_t
    "Specific heat capacity of the tube";
parameter Modelica.SIunits.ThermalConductivity lambda_t
    "Thermal conductivity of the tube";
//ATMOSPHERIC PROPERTIES//
parameter Modelica.SIunits.Pressure Patm "Atmospheric pressure";
parameter Modelica.SIunits.ThermalConductivity k_air = 0.025574811
    "Thermal conductivity of air at constant pressure";
parameter Modelica.SIunits.Density rho_air = 1.183650626 "Density of air";
parameter Modelica.SIunits.DynamicViscosity mu_air = 1.83055E-05
    "Dynamic viscosity of air at glass temperature";
Real C = if Re < 40 then
  0.75
 else
     if  Re > 40 and Re <1000 then
  0.51
 else
     if Re > 1000 and  Re < 200000 then
 0.26
 else
  0.076 "Coefficient for Nusselt number from Forristal ";
Real m = if Re < 40 then
  0.4
 else
     if  Re > 40 and Re <1000 then
  0.5
 else
     if Re > 1000 and  Re < 200000 then
 0.6
 else
  0.7 "Coefficient for Nusselt number from Forristal ";
Real n = if Pr < 10 then
     0.37
     else
0.36 "Coefficient for Nusselt number from Forristal";
parameter Real Pr;
Real Re "Reynolds number of atmosphere";
Real Nu "Nusselt number of atmophere";
// VACUUM PROPERTIES: air is considered as annulus gas//
parameter Modelica.SIunits.Pressure Pvacuum "Vacuum Pressure [Pa]";
final parameter Real P_mmhg = Pvacuum/133.322368;
parameter Real GAMMA= 1.39 "Ratio of specific heats for the annulus gas ";
parameter Real DELTA = 3.53e-8 "Molecular diameter for the annulus gas [cm]";
parameter Real BB = 1.571 "Interaction coefficient";
parameter Modelica.SIunits.ThermalConductivity k_st = 0.02551
    "Thermal conductivity at standard pressure and temperature";
Real LAMBDA[N] "mean free-path between collisions of a molecule [m]";
// HEAT TRANSFER COEFFICIENTS //
//Modelica.SIunits.CoefficientOfHeatTransfer Gamma_fluid[N]
//    "Coefficient of heat transfer fluid";
Modelica.SIunits.CoefficientOfHeatTransfer Gamma_vacuum[N]
    "Coefficient of heat transfer vacuum";
Modelica.SIunits.CoefficientOfHeatTransfer Gamma_air
    "coefficient of heat transfer";
//INITIAL VALUES OF TEMPERATURE AT THE CENTER OF TUBE & GLASS//
//Glass
parameter Modelica.SIunits.Temperature T_g_start_in
    "Temperature of the glass_inlet"
                                    annotation(Dialog(tab = "Initialisation"));
parameter Modelica.SIunits.Temperature T_g_start_out
    "Temperature of the glass outlet" annotation(Dialog(tab = "Initialisation"));
parameter Modelica.SIunits.Temperature T_g_start[N] = linspace(T_g_start_in,T_g_start_out,N)
    "start value of the tube temperature vector" annotation(Dialog(tab = "Initialisation"));
//Tube
parameter Modelica.SIunits.Temperature T_t_start_in
    "Temperature of the tube inlet" annotation(Dialog(tab = "Initialisation"));
parameter Modelica.SIunits.Temperature T_t_start_out
    "Average temperature of the tube outlet" annotation(Dialog(tab = "Initialisation"));
parameter Modelica.SIunits.Temperature T_t_start[N] = linspace(T_t_start_in,T_t_start_out,N)
    "start value of the tube temperature vector" annotation(Dialog(tab = "Initialisation"));
//TEMPERATURES //
Modelica.SIunits.Temperature Tsky "Sky temperature";
//Modelica.SIunits.Temperature T_g_air[N]
//    "Average temperature between air and external glass temperature";
//Modelica.SIunits.Temperature T_fluid[N] "temperature of the fluid";
Modelica.SIunits.Temperature T_int_t[N] "temperature of the internal tube";
Modelica.SIunits.Temperature T_t[N](start = T_t_start)
    "temperature at the center of the tube";
Modelica.SIunits.Temperature T_ext_t[N] "temperature of the external tube";
Modelica.SIunits.Temperature T_g_t[N]
    "Average temperature of the inner glass and the external tube";
Modelica.SIunits.Temperature T_int_g[N] "temperature of the internal glass";
Modelica.SIunits.Temperature T_g[N](start = T_g_start)
    "temperature at the center of the glass";
Modelica.SIunits.Temperature T_ext_g[N] "temperature of the external glass";
// THERMAL FLOW //
Modelica.SIunits.HeatFlowRate Q_glass_tot;
Modelica.SIunits.HeatFlowRate Q_tube_tot;
Modelica.SIunits.HeatFlowRate Q_abs[N];
//THERMAL FLUX //
Modelica.SIunits.HeatFlux Phi_glass_tot "heat flux absorbed by the glass";
Modelica.SIunits.HeatFlux Phi_glass_tot_N[N]
    "Heat flux from the sun to the glass at each node";
Modelica.SIunits.HeatFlux Phi_tube_tot "Heat flux absorbed by the tube";
Modelica.SIunits.HeatFlux Phi_tube_tot_N[N]
    "Heat flux from the sun to the tube at each node";
//Modelica.SIunits.HeatFlux Phi_conv_f[N] "Heat flux convection of the fluid";
Modelica.SIunits.HeatFlux Phi_tube_int[N] "Heat flux of tube internal";
Modelica.SIunits.HeatFlux Phi_tube_ext[N] "Heat flux of the tube external";
Modelica.SIunits.HeatFlux Phi_conv_gas[N] "heat flux convection in the vacuum";
Modelica.SIunits.HeatFlux Phi_rad_gas[N] "heat flux radiation in the vaccum";
Modelica.SIunits.HeatFlux Phi_glass_int[N] "heat flux of the glass internal";
Modelica.SIunits.HeatFlux Phi_glass_ext[N] "heat flux of the glass external";
Modelica.SIunits.HeatFlux Phi_conv_air[N] "Heat flux convection in the air";
Modelica.SIunits.HeatFlux Phi_rad_air[N] "heat flux radiation in the air";
Modelica.SIunits.HeatFlux Phi_loss
    "Heat losses with respect to the reflector surface";
// EFFICIENCIES //
Real eta_opt;
Real eta_opt_g;
Real eta_opt_t;
Real IAM "Incident Angle Modifier";
Real eta_th[N] "Thermal efficiency at each node";
Real eta_TOT[N] "Total efficiency : eta_th * eta_opt_t";
Real Eta_th "Average Thermal efficiency";
Real Eta_TOT "Average Total efficiency";
 Interfaces.HeatTransfer.ThermalPort wall_int(N=N)
    annotation (Placement(transformation(extent={{60,20},{80,40}}),
        iconTransformation(extent={{80,-10},{100,10}})));
equation
// Sky temperature //
Tsky =Tamb - 8 "Assumption from Forristal";
  // Incidence angle modifier //
IAM = Modelica.Math.cos(Theta*pi/180);
// Optical efficiency //
eta_opt = eps1*eps2*eps3*eps4*eps5*eps6*rho_cl*IAM;
// Optical efficiency glass //
eta_opt_g = eta_opt * Alpha_g;
// Optical efficiency tube //
eta_opt_t = eta_opt * Alpha_t * Tau_g;
//Total area of the reflector //
A_ref = L*A_P*Nt;
//Total area of the external glass//
A_ext_g = pi* Dext_g *L*Nt;
//Total area of the external tube //
A_ext_t = pi*Dext_t*L*Nt;
// Total thermal energy on the glass from the Sun //
Q_glass_tot = DNI * eta_opt_g * A_ref "heat flow";
Phi_glass_tot = Q_glass_tot / A_ext_g "heat flow";
// Total thermal energy on the tube from the Sun//
Q_tube_tot = DNI *eta_opt_t * A_ref "heat flow";
Phi_tube_tot = Q_tube_tot / A_ext_t "heat flux";
//Conduction glass&tube datas//
assert(rext_t > rint_t, "External Radius must be greater than internal radius");
Am_t = (rext_t^2 - rint_t^2)*pi "Area of the metal cross section";
assert(rext_g > rint_g, "External Radius must be greater than internal radius");
Am_g = (rext_g^2 - rint_g^2)*pi "Area of the glass cross section";
//Convective Heat Transfer Coefficient air
Re = v_wind * rho_air * Dext_g / mu_air;
Nu = C* Re^m * Pr ^ n;
Gamma_air = k_air*Nu/Dext_g;
for i in 1:N loop
// Tube Emissivity //
Eps_t[i] = 0.062 + (2E-7)*(T_ext_t[i]-273.15)^2;
//     if PTR then 0.062 + (2E-7)*(T_ext_t[i]-273.15)^2  elseif
//  UVAC then
//   (2.249E-7)*(T_ext_t[i]-273.15)^2 + (1.039E-4)*(T_ext_t[i]-273.15) + 5.599E-2
//   else
//  0.000327*(T_ext_t[i])-0.065971 "else Luz Cermet used for SANDIA experiments";
// CONVECTIVE HEAT TRANSFER FOR THE VACUUM  //
T_g_t[i] = (T_int_g[i] + T_ext_t[i])/2;
LAMBDA[i] = 2.33E-20*(T_g_t[i])/(P_mmhg * DELTA^2);
Gamma_vacuum[i] = k_st /((Dext_t/2)*log(rint_g/rext_t)+BB*LAMBDA[i]*(rext_t/rint_g+1));
// HEAT FLUX ON TUBE&GLASS //
Phi_tube_tot_N[i] = Phi_tube_tot;
Phi_glass_tot_N[i] = Phi_glass_tot;
//Convection to the external air//
Phi_conv_air[i] = Gamma_air * (T_ext_g[i] - Tamb);
//Radiation to the external air//
Phi_rad_air[i] = Eps_g * Sigma * (T_ext_g[i]^4 - Tsky^4);
//Heat to the glass //
Phi_glass_ext[i] = Phi_glass_tot_N[i] - Phi_rad_air[i] - Phi_conv_air[i];
//Conduction in the glass //
rho_g*Cp_g*Am_g*der(T_g[i]) = rint_g*2*pi*Phi_glass_int[i] + rext_g*2*pi*Phi_glass_ext[i]
      "Energy balance";
 Phi_glass_ext[i] = lambda_g/(rext_g*log((2*rext_g)/(rint_g + rext_g)))*(T_ext_g[i] - T_g[i])
      "Heat conduction through the external half-thickness";
Phi_glass_int[i] = lambda_g/(rint_g*log((rint_g + rext_g)/(2*rint_g)))*(T_int_g[i] - T_g[i])
      "Heat conduction through the internal half-thickness";
// Connection Internal Heat flow to the glass //
Phi_glass_int[i] = (Phi_conv_gas[i] + Phi_rad_gas[i]);
//Convection in the vacuum //
Phi_conv_gas[i] = Gamma_vacuum[i] *(T_ext_t[i] - T_int_g[i]);
// Radiation in the vacuum //
Phi_rad_gas[i] = Sigma*(T_ext_t[i]^4 -T_int_g[i]^4)/(1/Eps_t[N] + Dext_t/(Dext_g*(1/Eps_g-1)));
// Heat flux to the tube //
Phi_tube_ext[i] = Phi_tube_tot_N[i]- Phi_conv_air[i] - Phi_rad_air[i];
 //Conduction tube //
rho_t*Cp_t*Am_t*der(T_t[i]) = rint_t*2*pi*Phi_tube_int[i] + rext_t*2*pi*Phi_tube_ext[i]
      "Energy balance";
Phi_tube_ext[i] = lambda_t/(rext_t*log((2*rext_t)/(rint_t + rext_t)))*(T_ext_t[i] - T_t[i])
      "Heat conduction through the external half-thickness";
Phi_tube_int[i] = lambda_t/(rint_t*log((rint_t + rext_t)/(2*rint_t)))*(T_int_t[i] - T_t[i])
      "Heat conduction through the internal half-thickness";
// Constrain equation //
wall_int.phi[i]=Phi_tube_int[i];
// THERMAL EFFICIENCY AT EACH NODE //
Q_abs[i] = Phi_tube_int[i]*2*rint_t*pi*L;
if Q_tube_tot > 0 then
eta_th[i] = Q_abs[i] / Q_tube_tot;
eta_TOT[i] = eta_th[i] *eta_opt_t;
else
eta_th[i] = Q_abs[i];
eta_TOT[i] = eta_th[i] * eta_opt_t;
end if;
//Connections //
//wall_int.phi[i] = -Phi_conv_f[i];
T_int_t[i] = wall_int.T[i];
//Gamma_fluid[i] = wall_int.gamma[i];
end for;
// THERMAL LOSSES PER REFLECTOR SURFACE [W/m2]
Phi_loss =  (sum(Phi_rad_air) + sum(Phi_conv_air))*A_ext_g /(A_ref*N);
//THERMAL EFFICIENCY
Eta_th = sum(eta_th)/N;
//TOTAL EFFICIENCY
Eta_TOT = Eta_th*eta_opt_t;
                                                                                                      annotation(Dialog(tab = "Initialisation"),
             Diagram(graphics),
    Icon(graphics));
end SolAbs;
