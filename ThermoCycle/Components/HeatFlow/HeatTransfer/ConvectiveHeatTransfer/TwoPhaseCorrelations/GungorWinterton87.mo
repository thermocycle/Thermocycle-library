within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
model GungorWinterton87
  "The simplified Gungor-Winterton correlation for turbulent two phase flow"
  extends BaseClasses.PartialTwoPhaseCorrelation;

  parameter Modelica.SIunits.Length d_hyd(min=0)
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
    "Hydraulic diameter";

  replaceable model LiquidCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side" annotation(Dialog(group="Correlations"),choicesAllMatching=true);
  LiquidCorrelation liquidCorrelation(
    d_hyd = d_hyd,
    A_cro = A_cro,
    redeclare final package Medium = Medium,
    state = state,
    m_dot = m_dot*(1-x),
    q_dot = q_dot);

  Real G(unit="kg/(s.m.m)") "Mass flux";
  Modelica.SIunits.FroudeNumber Fr_l;
  Real Bo(unit="1") "Boiling number";
  Real Term1,Term2 "Boiling enhancement terms";

  Medium.Density rho_l,rho_v;
  Medium.SpecificEnthalpy h_l,h_v;

equation
  rho_l = Medium.density(bubbleState);
  rho_v = Medium.density(dewState);
  h_l   = Medium.specificEnthalpy(bubbleState);
  h_v   = Medium.specificEnthalpy(dewState);

  G = m_dot / A_cro;
  Fr_l = G^2/(rho_l^2*Modelica.Constants.g_n*d_hyd);
  //calculation of E_new
  Bo =  q_dot/(abs(G)*(h_v - h_l));  //Boiling number
  Term1 =  1 + 3000*Bo^0.86 + 1.12*x/(1-x)^0.75*(rho_l/rho_v)^0.41;
  Term2 =  if (Fr_l<0.05) then Fr_l^(0.1-2*Fr_l) else 1;
  U = liquidCorrelation.U*Term1*Term2;

end GungorWinterton87;
