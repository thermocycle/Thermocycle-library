within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
model Martin2010
  "The Martin approach for plate heat exchangers from VDI Heat Atlas"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPlateHeatExchangerCorrelation;

  parameter Modelica.SIunits.Length s_w(min=0,displayUnit="mm",nominal=0.00075) = 0.00075
    "Wall thickness";
  parameter Modelica.SIunits.ThermalConductivity lambda_w(min=0,nominal=15) = 15
    "Conductivity of the wall";
  parameter Modelica.SIunits.Length L_p(min=0,displayUnit="cm",nominal=0.20) = 0.2
    "Plate length";
  parameter Modelica.SIunits.ReynoldsNumber Re_turb(min=0,nominal=2000.0) = 2000.00
    "Flow transition Re";
  parameter Modelica.SIunits.ReynoldsNumber Re_tran(min=0,nominal=100.0) = 100.00
    "Flow transition range";
  parameter Real c_q(min=0,nominal=0.10) = 0.122 "Empirical constant";
  parameter Real   q(min=0,nominal=0.35) = 0.374 "Empirical constant";
  parameter Real B_0(min=0,nominal=64.0) = 64.00 "Shape factor";
  // Parameters from Focke paper
  parameter Real B_1(min=0,nominal=597.) = 597.0
    "Empirical pressure drop factor B_1";
  parameter Real C_1(min=0,nominal=3.85) = 3.850
    "Empirical pressure drop factor C_1";
  parameter Real K_1(min=0,nominal=39.0) = 39.00
    "Empirical pressure drop factor K_1";
  parameter Real   n(min=0,nominal=0.29) = 0.289
    "Empirical pressure drop factor n";
  // Parameters determined by Martin
  parameter Real   a(min=0,nominal=3.80) = 3.800
    "Empirical pressure drop factor a";
  parameter Real   b(min=0,nominal=0.18) = 0.180
    "Empirical pressure drop factor b";
  parameter Real   c(min=0,nominal=0.36) = 0.360
    "Empirical pressure drop factor c";

  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);
  Real Hg(min=0) "Hagen number";
  Real xi(min=0) "Friction factor";
  Real xi_0(min=0);
  Real xi_0_lam(min=0);
  Real xi_0_tur(min=0) "Friction factor, 0 deg";
  Real xi_1(min=0);
  Real xi_1_lam(min=0);
  Real xi_1_tur(min=0) "Friction factor, 90 deg";
  Real lamTurb(min=0,max=1,nominal=0.5) "Laminar or turbulent flow";
  Modelica.SIunits.Velocity w "Fluid velocity";
  //Modelica.SIunits.Area A_0(min=0) "Plate projection";
  //Modelica.SIunits.Area A_p(min=0) "Plate surface";

  Medium.Density rho;
  Medium.Temperature T;
  Medium.Temperature T_f_w;
  Medium.Temperature T_f_w_in;
  Medium.DynamicViscosity eta;
  Medium.DynamicViscosity eta_f_w "Viscosity of fluid at wall temperature";
  Medium.ThermalConductivity lambda;
  Medium.ThermodynamicState state_f_w "Thermodynamic state at wall";
  Medium.AbsolutePressure delta_p;
  Modelica.SIunits.VolumeFlowRate V_dot "Volume flow";
  //Modelica.SIunits.HeatFlowRate Q_dot "Heat flow";
  //Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  Real part1;
  Real part2;

equation
  // Get the required thermophysical properties
  rho = Medium.density(state);
  T   = Medium.temperature(state);
  // Get transport properties from Medium model
  Pr = min(100, Medium.prandtlNumber(state));
  assert(Pr > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
  eta = min(10, Medium.dynamicViscosity(state));
  assert(eta > 0, "Invalid viscosity, make sure transport properties are calculated.");
  lambda = min(10, Medium.thermalConductivity(state));
  assert(lambda > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
  // Get the required additional thermophysical properties
  T_f_w_in = q_dot / U + T;
  // Disable the correction term
  T_f_w = T; //min(Medium.saturationTemperature(Medium.pressure(filteredState)),T_f_w_in);
  state_f_w = Medium.setState_pTX(Medium.pressure(state),T_f_w);
  eta_f_w = min(10, Medium.dynamicViscosity(state_f_w));
  assert(eta_f_w > 0, "Invalid viscosity at wall, make sure transport properties are calculated.");

  // Implement the basic equations ...
  xi    = 2 * delta_p * d_h / rho / w^2 / L_p "Eq. 1";
  Re    = rho * w * d_h / eta "Eq. 2";
  Nu    = alpha * d_h / lambda "Eq. 3";
  // ... and the more specific ones
  //d_h   = 4 * a_hat / Phi "Eq. 4";
  //X     = 2 * Modelica.Constants.pi*a_hat/Lambda "Eq. 5";
  //Phi   = 1/6 * ( 1 + Modelica.Fluid.Utilities.regRoot(1+X^2) + 4 * Modelica.Fluid.Utilities.regRoot(1+X^2/2)) "Eq. 6";
  // Determine average velocity
  V_dot = m_dot / rho;
  w     = V_dot / A_cro "Eq. 7";
  // Account for the enhancement factor: U > alpha
  //A_0   = B_p * L_p;
  //A_p   = Phi * A_0 "Eq. 8";
  //Q_dot = q_dot * A_0;
  //alpha = Q_dot / A_p / delta_T                "Eq. 9";
  //U     = Phi * alpha "Enhanced HTC";

  // Pressure drop equations for longitudinal flow (0) and 90 deg patterns (1)
  lamTurb  = ThermoCycle.Functions.transition_factor(start=Re_turb-Re_tran, stop=Re_turb+Re_tran, position=Re);
  xi_0_lam = B_0/Re "Eq. 11";
  xi_0_tur = (1.8 * log10(Re) - 1.5) ^(-2) "Eq. 12";
  xi_0     = (1-lamTurb)*xi_0_lam + lamTurb*xi_0_tur;
  xi_1_lam = B_1 / Re + C_1 "Eq. 14";
  xi_1_tur = K_1 / Re^n "Eq. 15";
  xi_1     = a * ((1-lamTurb)*xi_1_lam + lamTurb*xi_1_tur);
  // Get the overall factor
  part1    = cos(phi)/Modelica.Fluid.Utilities.regRoot( b * tan(phi) + c * sin(phi) + xi_0/cos(phi));
  part2    = (1-cos(phi))/Modelica.Fluid.Utilities.regRoot(xi_1);
  xi       = 1/(part1 + part2)^2 "Eq. 18";

  // Continue with heat transfer equations
  //Hg  = rho * delta_p * d_h^3 / eta^2 / L_p   "Eq. 23";
  Hg  = xi / 2 * Re^2 "Eq. 18 and 23";
  Nu  = c_q * Pr^(1/3) * (eta/eta_f_w)^(1/6) * (2 * Hg * sin(2*phi))^q "Eq. 25";

  annotation (Documentation(info="<html>


<p><big> The model <b>Martin</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhasePHECorrelation\">PartialSinglePhasePHECorrelation</a> and 
 computes the heat transfer coefficient based on the correlation for plate heat exchangers developed by Holger Martin for the VDI Heat Atlas</p> 

<dl>
<dt>inbook<a name=\"Martin2010\">(Martin2010)</a></dt>
<dd>Martin, H.</dd>
<dd><i>VDI Heat Atlas</i></dd>
<dd>Stephan, P. <i>(ed.)</i></dd>
<dd>Chapter N6 Pressure Drop and Heat Transfer in Plate Heat Exchangers</dd>
<dd>Springer, <b>2010</b>, pp. 1515-1522</dd>

</dl>

<p></p>

</html>"));
end Martin2010;
