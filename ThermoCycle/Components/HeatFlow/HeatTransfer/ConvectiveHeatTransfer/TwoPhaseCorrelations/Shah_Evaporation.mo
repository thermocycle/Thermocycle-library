within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
partial model Shah_Evaporation "Shah correlation for evaporation"
  extends BaseClasses.PartialTwoPhaseCorrelation;

//   parameter Modelica.SIunits.Length d_hyd(min=0)
//     "Hydraulic diameter (2*V/A_lateral)";
//   parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
//     "Hydraulic diameter";
//
//   replaceable model LiquidCorrelation =
//     ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
//   constrainedby
//     ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
//     "correlated heat transfer coefficient liquid side" annotation(Dialog(group="Correlations"),choicesAllMatching=true);
//   LiquidCorrelation liquidCorrelation(
//     d_hyd = d_hyd,
//     A_cro = A_cro,
//     redeclare final package Medium = Medium,
//     state = state,
//     m_dot = m_dot*(1-x),
//     q_dot = q_dot);
//
//   Real G(unit="kg/(s.m.m)") "Mass flux";
//   Modelica.SIunits.FroudeNumber Fr_l;
//   Real Bo(unit="1") "Boiling number";
//   Real Term1;
//   Real Term2 "Boiling enhancement terms";
//
//   Medium.Density rho_l;
//   Medium.Density rho_v;
//   Medium.SpecificEnthalpy h_l;
//   Medium.SpecificEnthalpy h_v;
//
//   input Modelica.SIunits.Length Dhyd "Hydraulic diameter";
//   input Real G(unit="kg/(s.m.m)") "Mass flux";
//   input Modelica.SIunits.SpecificEnthalpy h_liq;
//   input Modelica.SIunits.SpecificEnthalpy h_vap;
//   input Modelica.SIunits.QualityFactor x "quality";
//   input Modelica.SIunits.Density rho_vap;
//   input Modelica.SIunits.Density rho_liq;
//   input Modelica.SIunits.HeatFlux q "Heat flux [W/m2]";
//   input Modelica.SIunits.ThermalConductivity k_liq;
//   input Modelica.SIunits.DynamicViscosity my_liq;
//   input Modelica.SIunits.SpecificHeatCapacity cp_liq;
//   input Integer theta "Tube orientation, if 0 then horizontal else vertical";
//   output Modelica.SIunits.CoefficientOfHeatTransfer htc
//     "Heat transfer coefficient";
// protected
//   Modelica.SIunits.CoefficientOfHeatTransfer htc_liq;
//   Modelica.SIunits.CoefficientOfHeatTransfer htc_c;
//   Modelica.SIunits.CoefficientOfHeatTransfer htc_NcB;
//   Real Fr_liq;
//   Real Co;
//   Real Bo;
//   Real N;
//   Real F;
//   Real Re_liq;
//   Real Pr_liq;
//   Real Nu_liq;
// algorithm
//Dividing by zero is avoided
//   Co := abs((1 - x)/max(x,1e-6))^0.8*(rho_vap/rho_liq)^0.5;
//   Fr_liq :=G^2/(rho_liq^2*Modelica.Constants.g_n*Dhyd);
//   Bo := if G == 0 then 0 else abs(q/(G*(h_vap - h_liq)));
//   N := if Fr_liq == 0 then 0 else if (theta == 0) and (Fr_liq < 0.04) then 0.38*Co*Fr_liq^(-0.3) else Co;
//Calculation of liquid htc using Dittus Boelter for heating
//   Re_liq :=abs(G*(1 - x)*Dhyd/my_liq);
//   Pr_liq :=my_liq*cp_liq/k_liq;
//   Nu_liq :=0.023*Re_liq^0.8*Pr_liq^0.4;
//   htc_liq :=Nu_liq*k_liq/Dhyd;
//This if statement is made linearly smooth to avoid chattering
//  F :=if Bo > 11E-4 then 14.7 else 15.43;
//   if (Bo > 12E-4) then
//     F :=14.7;
//   elseif (Bo < 10E-4) then
//     F :=15.43;
//   else //linear fit
//   F:=(15.43 - 14.7)*(12E-4 - Bo)/(12E-4 - 10E-4) + 14.7;
//   end if;
//   htc_c := if N == 0 then 0 else htc_liq*1.8/N^0.8;
//The nucleate boiling coefficient goes to infinity at x -> 1
//   if x > 0.98 or N==0 then
//     htc_NcB := 0;
//   else
//     if N > 1 then // The 3E-5 needs to be verified
//       htc_NcB :=if Bo > 3E-5 then htc_liq*230*Bo^0.5 else htc_liq*(1 + 46*Bo^0.5);
//     elseif N < 0.1 then
//       htc_NcB :=htc_liq*F*Bo^0.5*Modelica.Math.exp(2.47*N^(-0.15));
//     else
//       htc_NcB :=htc_liq*F*Bo^0.5*Modelica.Math.exp(2.74*N^(-0.1));
//     end if;
//   end if;
//   htc :=max(htc_NcB,htc_c);
//
// equation
//   rho_l = Medium.density(bubbleState);
//   rho_v = Medium.density(dewState);
//   h_l   = Medium.specificEnthalpy(bubbleState);
//   h_v   = Medium.specificEnthalpy(dewState);
//
//   G = m_dot / A_cro;
//   Fr_l = G^2/(rho_l^2*Modelica.Constants.g_n*d_hyd);
//   //calculation of E_new
//   Bo =  q_dot/(abs(G)*(h_v - h_l));  //Boiling number
//   Term1 =  1 + 3000*Bo^0.86 + 1.12*x/(1-x)^0.75*(rho_l/rho_v)^0.41;
//   Term2 =  if (Fr_l<0.05) then Fr_l^(0.1-2*Fr_l) else 1;
//   U = liquidCorrelation.U*Term1*Term2;

end Shah_Evaporation;
