within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
model MuleyManglik1999
  "Heat transfer in plate heat exchangers, Muley and Manglik 1999"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhaseCorrelation;
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialPlateHeatExchangerCorrelation;

  parameter Modelica.SIunits.ReynoldsNumber Re_lam =  400 "Fully laminar";
  parameter Modelica.SIunits.ReynoldsNumber Re_tur = 1000 "Fully turbulent";
  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Real lamTur(min=-0.1,max=1.1);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);
  Modelica.SIunits.NusseltNumber Nu_lam(min=0);
  Modelica.SIunits.NusseltNumber Nu_tur(min=0);

  Medium.Density rho;
  Medium.Temperature T;
  Medium.Temperature T_f_w;
  Medium.Temperature T_f_w_in;
  Medium.DynamicViscosity eta;
  Medium.DynamicViscosity eta_f_w "Viscosity of fluid at wall temperature";
  Medium.ThermalConductivity lambda;
  Medium.ThermodynamicState state_f_w "Thermodynamic state at wall";
  Modelica.SIunits.VolumeFlowRate V_dot "Volume flow";
  Modelica.SIunits.Velocity w "Fluid velocity";

  Real commonTerm;

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

  V_dot = m_dot / rho;
  w  = abs(V_dot) / A_cro;
  // Use transport properties to determine dimensionless numbers
  Re    = rho * w * d_h / eta;
  lamTur = ThermoCycle.Functions.transition_factor(
    start=Re_lam,
    stop=Re_tur,
    position=Re);

  Nu = alpha * d_h / lambda;
  Nu = (1-lamTur)*Nu_lam + lamTur*Nu_tur;

  commonTerm = Pr^(1/3) * ( eta/eta_f_w) ^(0.14);
  Nu_tur = (2.668e-1 - 6.967e-3*phi + 7.244e-5*phi^2)
  * ( 2.078e+1 - 5.094e+1*Phi + 4.116e+1*Phi^2 - 1.015e+1*Phi^3)
  * Re^( 0.728+0.0543*sin( Modelica.Constants.pi * phi/Modelica.SIunits.Conversions.from_deg(45) + 3.7))
  * commonTerm;

  Nu_lam = 0.44*(phi/Modelica.SIunits.Conversions.from_deg(30))^(0.38)
  * Re^(1/2) * commonTerm;

  annotation (Documentation(info="<html>
<dl><dt>article <a name=\"Muley1999\">(</a>Muley1999)</dt>
<dd>Muley, A. and Manglik, R. M.</dd>
<dd><i>Experimental Study of Turbulent Flow Heat Transfer and Pressure Drop in a Plate Heat Exchanger With Chevron Plates</i></dd>
<dd>Journal of Heat Transfer, <b>1999</b>, Vol. 121(1), pp. 110-117 </dd>
</dl></html>"));
end MuleyManglik1999;
