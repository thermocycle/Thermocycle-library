within ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations;
model Cooper1984 "Cooper correlation for nucleate boiling"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPipeCorrelation(
     final d_h=0, final A_cro=0);
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPlateHeatExchangerCorrelation(
     final a_hat=0, final Lambda=0, final phi=0, final B_p=0, final d_h=0, final A_cro=0, final X = 0, final Phi=1);

  Real p_r(min=0,nominal=0.75) "p/p_crit";
  Real M;
  Real log_p_r;
  parameter Modelica.SIunits.Length R_p(min=Modelica.Constants.small,displayUnit="mm") = 1e-6
    "Roughness, disable with 1um";
  Real log_R_p;
  parameter Real C(min=0) = 1.0 "Enhancement term, 0.7-1.5 for plate HX";

algorithm
  M :=Medium.getMolarMass() "kg/mol, needs transform to kg/kmol";
  p_r :=Medium.pressure(state)/Medium.getCriticalPressure();
  //U = C*55*p_r^(0.12-0.2*log(R_p))*log(p_r)^(-0.55)*q_dot^(0.67)*(M*1e3)^(-0.5);

  log_p_r :=log10(max(Modelica.Constants.small, p_r));
  log_R_p :=log10(max(Modelica.Constants.small,1e6*R_p));

  U :=1;
  U :=U*C*55;
  U :=U*Modelica.Fluid.Utilities.regPow(x=p_r, a=0.12 - 0.2*log_R_p);
  U :=U*Modelica.Fluid.Utilities.regPow(x=-log_p_r, a=-0.55);
  U :=U*Modelica.Fluid.Utilities.regPow(x=q_dot, a=0.67);
  U :=U*Modelica.Fluid.Utilities.regPow(x=M*1e3, a=-0.5);
//  U = C*55*p_r^(0.12)*log_p_r^(-0.55)*q_dot^(0.67)*(M*1e3)^(-0.5);

  annotation (Documentation(info="<html>
<p>The model <b>Cooper1984</b> extends the partial model <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and calculates the heat transfer coefficient</p>
<p>The included factor of 1.5 is taken from Palm and Claesson 2006 - Plate heat exchangers: Calculation methods for singleand two-phase flow, Heat Transfer Engineering, 2006, 27, 88-98 </p>
<p><i><b>Article</b></i><a name=\"Cooper1984\"> </a>(Cooper1984)</p>
<p>Cooper, M. G.</p>
<p>Heat Flow Rates in Saturated Nucleate Pool Boiling---A Wide-Ranging Examination Using Reduced Properties</p>
<p><i>Advances in Heat Transfer, Elsevier, </i><b>1984</b><i>, 16</i>, 157-239 </p>
</html>"));
end Cooper1984;
