within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
model Shah_Evaporation "Shah correlation for evaporation"
  extends BaseClasses.PartialTwoPhaseCorrelation;

  parameter Modelica.SIunits.Length d_hyd(min=0)
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
    "Hydraulic diameter";

  parameter Boolean vertical = true "Vertical or horizontal flow";

  replaceable model LiquidCorrelation =
     ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation
    "correlated heat transfer coefficient liquid side"  annotation(Dialog(group="Correlations"),choicesAllMatching=true);
  LiquidCorrelation liquidCorrelation(
     d_hyd = d_hyd,
     final A_cro = A_cro,
     redeclare final package Medium = Medium,
     state = bubbleState,
     m_dot = m_dot*(1-x),
     q_dot = q_dot);

  Real G(unit="kg/(s.m.m)") "Mass flux";
  Modelica.SIunits.FroudeNumber Fr_l;
  Modelica.SIunits.CoefficientOfHeatTransfer htc_l;
  Modelica.SIunits.CoefficientOfHeatTransfer htc_TP;
  Real Bo(unit="1") "Boiling number";

  // Constants and factors
  Real Co(unit="1");
  Real F_hi(unit="1");
  Real F_lo(unit="1");
  Real F_trans(unit="1");
  Real F(unit="1");
  Real N_hi(unit="1");
  Real N_lo(unit="1");
  Real N_trans(unit="1");
  Real N(unit="1");
  Real Fr_l_start(unit="1");
  Real Fr_l_stop(unit="1");

  //Boiling enhancement terms
  Real psi_nb_hi(unit="1");
  Real psi_nb_lo(unit="1");
  Real psi_nb_trans(unit="1");
  Real psi_nb(unit="1");
  Real psi_cb(unit="1");
  Real psi_N10(unit="1");
  Real psi_nbbs(unit="1");
  Real psi_N05(unit="1");
  Real psi_bs(unit="1");
  Real psi_N01(unit="1");
  Real psi_0105_trans(unit="1");
  Real psi_0105_hi(unit="1");
  Real psi_0105_lo(unit="1");
  Real psi_0105(unit="1");
  Real psi_0510_trans(unit="1");
  Real psi_0510_hi(unit="1");
  Real psi_0510_lo(unit="1");
  Real psi_0510(unit="1");
  Real psi_trans(unit="1");
  Real psi_hi(unit="1");
  Real psi_lo(unit="1");
  Real psi(unit="1");

  Medium.Density rho_l;
  Medium.Density rho_v;
  Medium.SpecificEnthalpy h_l;
  Medium.SpecificEnthalpy h_v;
  Medium.SpecificEnthalpy i_fg;

equation
  rho_l = Medium.density(bubbleState);
  rho_v = Medium.density(dewState);
  h_l   = Medium.specificEnthalpy(bubbleState);
  h_v   = Medium.specificEnthalpy(dewState);
  i_fg  = (h_v-h_l);

  // Determine dimensionless numbers
  G     = m_dot / A_cro "mass flux";
  psi   = htc_TP / htc_l "Eq. 1";
  Co    = (1/max(Modelica.Constants.small,x) -1)^0.8 * sqrt(rho_v/rho_l) "Eq. 2";
  Bo    = q_dot / (G*i_fg) "Eq. 3";
  Fr_l  = G^2/(rho_l^2*Modelica.Constants.g_n*d_hyd) "Eq. 4";
  htc_l = liquidCorrelation.U "Eq. 5";

  // Convective (cb) and fully nucleate boiling (nb), N>1.0
  psi_nb_hi    = 230 * sqrt(Bo) "Eq. 6";
  psi_nb_lo    = 1 + 46 * sqrt(Bo) "Eq. 7";
  psi_nb_trans = ThermoCycle.Functions.transition_factor(start=0.29e-4, stop=0.31e-4, position=Bo);
  psi_nb       = (1-psi_nb_trans)*psi_nb_lo + psi_nb_trans*psi_nb_hi;
  psi_cb       =  1.8 / N^0.8 "Eq. 8";
  psi_N10      = max(psi_nb,psi_cb);

  // Bubble nucleation is partly suppressed (nbbs), 0.1<N<=1.0
  psi_nbbs     = F * sqrt(Bo) * exp(2.74*N^(-0.1)) "Eq. 9";
  psi_N05      = max(psi_nbbs,psi_cb);

  // Bubble nucleation is suppressed (bs), N<=0.1
  psi_bs       = F * sqrt(Bo) * exp(2.47*N^(-0.15)) "Eq. 10";
  psi_N01      = max(psi_bs,psi_cb);

  // Constants
  F_hi         = 14.70 "Eq. 11";
  F_lo         = 15.43 "Eq. 12";
  F_trans      = ThermoCycle.Functions.transition_factor(start=10.9e-4, stop=11.1e-4, position=Bo);
  F            = (1-F_trans)*F_lo + F_trans*F_hi;

  // Determining parameter N
  if vertical then
    Fr_l_start = -1e6;
    Fr_l_stop  = 0;
  else
    Fr_l_start = 0.039;
    Fr_l_stop  = 0.041;
  end if;
  N_trans      = ThermoCycle.Functions.transition_factor(start=Fr_l_start, stop=Fr_l_stop, position=Fr_l);
  N_hi         = Co "Eq. 13";
  N_lo         = 0.38*Fr_l^(-0.3)*Co "Eq. 14";
  N            = (1-N_trans)*N_lo + N_trans*N_hi;

  // In the end we merge all three calculated psi values from N < 0.1 to N > 1.0
  psi_0105_trans = ThermoCycle.Functions.transition_factor(start=0.09, stop=0.11, position=N);
  psi_0105_hi    = psi_N05;
  psi_0105_lo    = psi_N01;
  psi_0105       = (1-psi_0105_trans)*psi_0105_lo + psi_0105_trans*psi_0105_hi;

  psi_0510_trans = ThermoCycle.Functions.transition_factor(start=0.99, stop=1.01, position=N);
  psi_0510_hi    = psi_N10;
  psi_0510_lo    = psi_N05;
  psi_0510       = (1-psi_0510_trans)*psi_0510_lo + psi_0510_trans*psi_0510_hi;

  psi_trans = ThermoCycle.Functions.transition_factor(start=0.1, stop=1.0, position=N);
  psi_hi    = psi_0510;
  psi_lo    = psi_0105;
  psi       = (1-psi_trans)*psi_lo + psi_trans*psi_hi;

  htc_TP = U;

  annotation (Documentation(info="<html>


<p><big> The model <b>Shah_Evaporation</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and
 calculates the heat transfer coefficient based on the Shah correlation for evaporation
 </p>

<dl>
<dt>article<a name=\"Shah1982\">(Shah1982)</a></dt>
<dd>Shah, M.M.</dd>
<dd><i>Chart Correlation For Saturated Boiling Heat Transfer: Equations And Further Study</i></dd>
<dd>ASHRAE Transactions, <b>1982</b>, Vol. 88, pp. 185-196</dd>

</dl>

<p></p>
</html>"));
end Shah_Evaporation;
