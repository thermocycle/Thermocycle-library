within ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations;
model GungorWinterton1987
  "The simplified Gungor-Winterton correlation for turbulent two phase flow"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPipeCorrelation;

  replaceable model LiquidCorrelation =
    ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.DittusBoelter1930
  constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side" annotation(Dialog(group="Correlations"),choicesAllMatching=true);
  LiquidCorrelation liquidCorrelation(
    d_h = d_h,
    A_cro = A_cro,
    redeclare package Medium = Medium,
    state = bubbleState,
    m_dot = m_dot*(1-x),
    q_dot = q_dot);

  Real G(unit="kg/(s.m.m)") "Mass flux";
  Modelica.SIunits.FroudeNumber Fr_l;
  Real Bo(unit="1") "Boiling number";
  Real Term1;
  Real Term2 "Boiling enhancement terms";

  Medium.Density rho_l;
  Medium.Density rho_v;
  Medium.SpecificEnthalpy h_l;
  Medium.SpecificEnthalpy h_v;

equation
  rho_l = Medium.density(bubbleState);
  rho_v = Medium.density(dewState);
  h_l   = Medium.specificEnthalpy(bubbleState);
  h_v   = Medium.specificEnthalpy(dewState);

  G = m_dot / A_cro;
  Fr_l = G^2/(rho_l^2*Modelica.Constants.g_n*d_h);
  //calculation of E_new
  Bo =  abs(q_dot)/(abs(G)*(h_v - h_l));  //Boiling number
  Term1 =  1 + 3000*Bo^0.86 + 1.12*(x/(1-x))^0.75*(rho_l/rho_v)^0.41;
  Term2 =  if (Fr_l<0.05) then Fr_l^(0.1-2*Fr_l) else 1;
  U = liquidCorrelation.U*Term1*Term2;
    annotation(Documentation(info="<html>

<p><big> The model <b>GungorWinterton1987</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and 
 calculates the heat transfer coefficient based on the GungerWinterton correlation.
 </p>

<dl>
<dt>article<a name=\"Shah1982\">(GungorWinterton87)</a></dt>
<dd>Gungor, K. E. and Winterton, R. H. S.</dd>
<dd><i>Simplified general correlation for saturated flow boiling and ccomparison of correlations with data</i></dd>
<dd>Chemical Engineering Research and Design, <b>1987</b>, Vol. 65        , pp. 148-156</dd>

</dl>

<p></p>

</html>"));
end GungorWinterton1987;
