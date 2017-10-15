within ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber;
model AbsSoltigua
// It solves the 1D radial energy balance around the Heat Transfer Element based on the SOLTIGUA PTMx Datasheet (see PTMx REV03-04/2013 and REV09-08/2013)
// min oil flow rate: 50 l/min @ 100-150 °C , 25 l/min @ 151-200 °C , 20 l/min @ 201 - 250 °C

/*********************** PORTS ***********************/
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort wall_int(N=N)
   annotation (Placement(transformation(extent={{78,-6},{98,14}}),
        iconTransformation(extent={{80,-10},{100,10}})));

/*********************** INPUTS ***********************/
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-114,46},{-86,74}}),
        iconTransformation(extent={{-104,70},{-74,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta "In Radiants"
    annotation (Placement(transformation(extent={{-114,26},{-86,54}}),
        iconTransformation(extent={{-104,30},{-74,60}})));

  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-114,-16},{-86,12}}),
        iconTransformation(extent={{-102,-46},{-72,-16}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-114,8},{-86,36}}),
        iconTransformation(extent={{-104,-6},{-76,22}})));

  Modelica.Blocks.Interfaces.IntegerInput Focusing( start=1)
    "Internal focusing signal. TRUE Defocusing = 0, FALSE Defocusing =1"
    annotation (Placement(transformation(extent={{-120,-106},{-80,-66}})));

/****************** CONSTANTS  *********************/

constant Real Sigma = Modelica.Constants.sigma "Stefan-Boltzmann constant";
constant Real gg = Modelica.Constants.g_n
    "Standard acceleration of gravity on earth";

 //constrainedby  ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.BaseGeometry
 //                                                                                      annotation (choicesAllMatching=true);
inner replaceable parameter
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.BaseGeometry
                                                                                        geometry
constrainedby
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.BaseGeometry
                                                                                       annotation (choicesAllMatching=true);

/************** PARAMETER ***********************/
/*****************General Geometries**************************/
parameter Integer N = 2 "number of cells";
final parameter Modelica.SIunits.Length ll= geometry.L/(N-1)
    "Length of each cell";
    parameter Real Defocusing = 25
    "Percentage value of the SF surface that goes to defocusing (25-50-75)";
/*************************** VARIABLES ****************************************/

/******************* Area of Collector and Reflector *****************************/
 Modelica.SIunits.Area S_eff "effective collecting area - Depend on focusing";
Real K_l( min=0,max=1) "Longitudinal Incident Angle Modifier (IAM)";
Real Theta_deg;

/********************* TEMPERATURES **********************************/
Modelica.SIunits.Temperature T_fluid[N] "Temperature of the fluid";

/************* THERMAL FLOW ****************************************/
Modelica.SIunits.HeatFlowRate Q_tube_tot
    "Total thermal energy on one solar collector";

/****************************************THERMAL FLUX ****************************************/
Modelica.SIunits.HeatFlux Phi_conv_f[N] "Heat flux to the fluid";
Modelica.SIunits.HeatFlux Phi_amb[N] "Heat flux to the ambient";
/**************************************** EFFICIENCIES ****************************************/
Real Eta_tot_N[N] "Efficiency based on Soltigua data sheet";
Real Eta_tot "Averaged overall Efficiency";
parameter Boolean TotalDefocusing = false "Set to true for total defocusing";
Real S_defocusing;
equation

  /* Focusing effect */
//if Focusing ==1 then S_eff =geometry.S_net;
//else  S_eff = geometry.S_ext_t;
//end if;
if TotalDefocusing then
  S_defocusing = geometry.A_ext_t;
else S_defocusing = geometry.S_net*(1-Defocusing/100);
end if;

if Focusing ==1 then S_eff =geometry.S_net;
else  S_eff = S_defocusing;
end if;

/* Get Theta in degree */
Theta_deg = Theta *180/geometry.pi;

/* Incidence angle modifier */
K_l = geometry.A_3*Theta_deg^3 - geometry.A_2*Theta_deg^2 + geometry.A_1*Theta_deg + geometry.A_0;

Q_tube_tot = DNI*S_eff*Modelica.Math.cos(Theta);

for i in 1:N loop
  if DNI > 0 then
  Eta_tot_N[i] = max(Modelica.Constants.small,K_l*0.747 - 0.64*(T_fluid[i] - Tamb)/max(Modelica.Constants.small,DNI));
  Phi_amb[i] = 0.64*(Tamb -T_fluid[i]);
  else
  Eta_tot_N[i] = 0;
  Phi_amb[i] = 0.64*(Tamb -T_fluid[i]);
  end if;
  Phi_conv_f[i]= Q_tube_tot*Eta_tot_N[i]/ geometry.A_ext_t;
/* Connection */
T_fluid[i] = wall_int.T[i];
wall_int.phi[i] = - Phi_conv_f[i] - Phi_amb[i];
end for;

Eta_tot =sum(Eta_tot_N)/N;

                                                                                                      annotation(Dialog(tab = "Initialisation"),
             Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics),Documentation(info="<HTML> 
    
    <p><big>It solves the 1D radial energy balance around the Heat Collector Element of the Soltigua PTMx parabolic trough solar collector based on the Soltigua data sheet
     (see <a href=\"http://www.soltigua.com/prodotti/ptm/\">http://www.soltigua.com</a>.)</p>
     <p><big>The model allows to defocusing the collectors based on the Internal focusing signal. TRUE Defocusing = 0, FALSE Defocusing =1
    
    <p><b><big>Modelling options</b></p>
    <p><big><ul><li>Geometry: It allows to choose one of the different PTMx model. 
     
    </ul>
    </HTML>"));
end AbsSoltigua;
