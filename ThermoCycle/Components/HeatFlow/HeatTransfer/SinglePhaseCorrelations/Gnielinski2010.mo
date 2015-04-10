within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
model Gnielinski2010 "Gnielinski pipe equations"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPipeCorrelation;

  import Modelica.Constants.pi;

  // General variables
  parameter Modelica.SIunits.Length d_i(min=0) = d_h
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Length l(min=0) =   0.250 "Pipe or plate length";
  //parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_i^2 / 4 "Cross-sectional area";
  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.ReynoldsNumber Re_tur(min=0);
  Modelica.SIunits.ReynoldsNumber Re_lam(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);

  // Fluid properties
  Medium.ThermalConductivity lambda;
  Medium.DynamicViscosity eta;
  Medium.SpecificHeatCapacity cp;
  Medium.Density rho;

  // VDI Heat Atlas, 2010, page 694
  Modelica.SIunits.NusseltNumber Nu_m_T_1(min=0);
  Modelica.SIunits.NusseltNumber Nu_m_T_2(min=0);
  Modelica.SIunits.NusseltNumber Nu_m_T_3(min=0);
  Modelica.SIunits.NusseltNumber Nu_m_T(min=0);

  // VDI Heat Atlas, 2010, page 696, fully developed turbulent flow
  Real gamma;
  Real xtra "Reynolds correction factor";
  Real zeta "Friction factor";
  Real K "Correction term";
  Modelica.SIunits.NusseltNumber Nu_m(min=0);

  // Other things to define
  Modelica.SIunits.Length cLen(min=0) "Characteristic length";
  Modelica.SIunits.Velocity cVel "Characteristic velocity";

  // Output variables
  Modelica.SIunits.NusseltNumber Nu(min=0);

  // General purpose variables
  Real numerator;
  Real denominator;
  Modelica.SIunits.VolumeFlowRate V_dot;

equation
  // Get transport properties from Medium model
  eta = Medium.dynamicViscosity(state);
  assert(eta > 0, "Invalid viscosity, make sure transport properties are calculated.");
  lambda = Medium.thermalConductivity(state);
  assert(lambda > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
  cp = Medium.specificHeatCapacityCp(state);
  assert(cp > 0, "Invalid heat capacity, make sure that your are not in the two-phase region.");
  rho = Medium.density(state);
  // Define some basic variables
  V_dot = m_dot / rho;
  cVel  = V_dot / A_cro "Characteristic velocity";
  cLen  = d_i;
  Pr    = cp * eta / lambda;
  //assert(Pr >= 0.1, "Invalid Prandtl number, the correlation is not valid.");
  //assert(Pr <= 1e3, "Invalid Prandtl number, the correlation is not valid.");
  Re    = (rho * abs(cVel) * cLen) / eta;
  Re_lam = noEvent(min(Re,2300));
  Re_tur = noEvent(max(Re,1e4));

  // VDI Heat Atlas, 2010, page 694, constant wall temperature
  Nu_m_T_1 = 3.66 "Eq. 4";
  Nu_m_T_2 = 1.615 * ( Re_lam * Pr * d_i/l) ^(1/3) "Eq. 5";
  Nu_m_T_3 = (2/(1+22*Pr))^(1/6) * ( Re_lam * Pr * d_i/l) ^(1/2) "Eq. 11";
  Nu_m_T   = (Nu_m_T_1^3 + 0.7^3 + (Nu_m_T_2-0.7)^3 + Nu_m_T_3^3)^(1/3) "Eq. 12";

  // VDI Heat Atlas, 2010, page 696, fully developed turbulent flow
  zeta  = (1.80 * log10(Re_tur)-1.50)^(-2) "Eq. 27";
  xtra  = 0.;
  K     = 1.;
  numerator   = (zeta/8.) * (Re_tur-xtra) * Pr;
  denominator = 1 + 12.7 * sqrt(zeta/8.) *( Pr^(2./3.) - 1.);
  Nu_m        = numerator / denominator *( 1 + (d_i/l)^(2./3.))*K;

  // Instead of the linear transition, we employ a smoother one
  gamma = ThermoCycle.Functions.transition_factor(start=2300, stop=1e4, position=Re);
  Nu    = (1-gamma)*Nu_m_T + gamma*Nu_m;
  U     = Nu * lambda / cLen;

  annotation(Documentation(info="<html>

<p><big> The model <b>Gnielinski</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation\">PartialSinglePhaseCorrelation</a> and 
 computes the heat transfer coefficient based on the Gnielinski correlation.
 </p>

<dl>
<dt>inbook<a name=\"Gnielinski2010\">(Gnielinski2010)</a></dt>
<dd>Gnielinski, V.</dd>
<dd><i>VDI Heat Atlas</i></dd>
<dd>Stephan, P. <i>(ed.)</i></dd>
<dd>Chapter G1 Heat Transfer in Pipe Flow</dd>
<dd>Springer, <b>2010</b>, pp. 691-700</dd>

</dl>
<p></p>

</html>"));
end Gnielinski2010;
