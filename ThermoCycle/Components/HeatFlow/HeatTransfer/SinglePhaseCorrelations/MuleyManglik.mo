within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
model MuleyManglik
  "Heat transfer in plate heat exchangers, Muley and Manglik 1999"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialRePrCorrelation;

  parameter Modelica.SIunits.Length a_hat(min=0,displayUnit="mm",nominal=0.002) = 0.002
    "Corrugation amplitude";
  parameter Modelica.SIunits.Angle phi(min=0,displayUnit="deg",nominal=1) = 45*Modelica.Constants.pi/180
    "Corrugation angle";
  parameter Modelica.SIunits.Length Lambda(min=0,displayUnit="mm",nominal=0.01) = 0.0126
    "Corrugation wavelength";
  parameter Modelica.SIunits.Length B_p(min=0,displayUnit="cm",nominal=0.10) = 0.1
    "Plate width";
  parameter Modelica.SIunits.Length L_p(min=0,displayUnit="cm",nominal=0.20) = 0.2
    "Plate length";
  parameter Modelica.SIunits.ReynoldsNumber Re_tur(min=0,nominal=1000.0) = 1000.00
    "Fully turbulent";
  parameter Modelica.SIunits.ReynoldsNumber Re_lam(min=0,nominal=400.0) = 400.00
    "Fully laminar";

  Real X "Wave number";
  Real Phi "Enhancement factor";
  Modelica.SIunits.Length d_h(min=0,displayUnit="mm",nominal=0.006)
    "Hydraulic diameter";
  Modelica.SIunits.Velocity w "Fluid velocity";
  Modelica.SIunits.ReynoldsNumber Re(min=0);
  Modelica.SIunits.PrandtlNumber Pr(min=0);
  Modelica.SIunits.NusseltNumber Nu(min=0);

  Real lamTurb(min=0,max=1,nominal=0.5) "Laminar or turbulent flow";

  input Modelica.SIunits.Temperature T_f_w_in "Temperature of the wall";
  input Modelica.SIunits.Temperature T_f_w "Temperature of the wall";
  Medium.ThermodynamicState wallState "Thermodynamic state at the wall";
  Medium.DynamicViscosity eta_f_w "Viscosity of fluid at wall temperature";

  Modelica.SIunits.VolumeFlowRate V_dot "Volume flow";

equation
  // Get the required additional thermophysical properties
  T_f_w = min(Medium.saturationTemperature(Medium.pressure(filteredState)),T_f_w_in);
  wallState = Medium.setState_pT(Medium.pressure(filteredState),T_f_w);
  eta_f_w = min(10, Medium.dynamicViscosity(wallState));
  assert(eta_f_w > 0, "Invalid viscosity at wall, make sure transport properties are calculated.");

  cVel = w;
  cLen = d_h;

  // Geometric properties from Martin2010
  d_h   = 4 * a_hat / Phi "Eq. 4";
  X     = 2 * Modelica.Constants.pi*a_hat/Lambda "Eq. 5";
  Phi   = 1/6 * ( 1 + Modelica.Fluid.Utilities.regRoot(1+X^2) + 4 * Modelica.Fluid.Utilities.regRoot(1+X^2/2)) "Eq. 6";
  // Determine average velocity
  V_dot = m_dot / rho;
  w     = V_dot / 2 / a_hat / B_p "Eq. 7";
  // Account for the enhancement factor: U > alpha
  A_0   = B_p * L_p;
  A_p   = Phi * A_0 "Eq. 8";
  //Q_dot = q_dot * A_0;
  //alpha = Q_dot / A_p / delta_T                "Eq. 9";
  U     = Phi * alpha "Enhanced HTC";

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

//   A special correlation for single phase heat transfer in
// \glspl{phe} has been provided by \citet{Muley1999}.
// Looking at plate angles $\SI{30}{\degree} \leq \gls{phi} \leq \SI{60}{\degree}$,
// they define a polynomial-based correlation for \gls{nusselt}
// \begin{align}
// \gls{nusselt}
//       = & \left( \num{2.668e-1} - \num{6.967e-3}\phi + \num{7.244e-5}\phi^2 \right) \\
//   \cdot & \left( \num{2.078e+1} - \num{5.094e+1}\Phi + \num{4.116e+1}\Phi^2 - \num{1.015e+1}\Phi^3 \right) \\
//   \cdot & \Rey^{\left( 0.728+0.0543\sin\left( \gls{pi} \gls{phi}/\SI{45}{\degree} + 3.7 \right) \right)}
//      \ma \Pra^{1/3} \ma \left( \frac{\gls{mu}}{\glssub[mu]{sub:w}} \right)^{0.14}
//   \text{. } \label{eqn:hxMuleyTur}
// \end{align}
// \cref{eqn:hxMuleyTur} is valid for $\gls{reynolds} \geq 1000$
// and for enlargement factors~\gls{Phi} between \numlist{1;1.5}, which is expected to
// cover all possible plate heat exchanger configurations~\cite{Muley1999}.
// For lower \gls{reynolds} in the range from \numrange{30}{400}, \citet{Palm2006}
// recommend to use
// \begin{equation}
// \gls{nusselt} = 0.44\left(\frac{\phi}{\SI{30}{\degree}}\right)^{0.38}
//                \ma \gls{reynolds}^{1/2}
//                \ma \gls{prandtl}^{1/3}
//                \ma \left( \frac{\gls{mu}}{\glssub[mu]{sub:w}} \right)^{0.14}
//                \text{, } \label{eqn:hxMuleyLam}
// \end{equation}
// which also originates from \citet{Muley1999}. Both equations assume that
// \gls{phi} is given in degrees and not in radians. The final implementation
// used in this work employs the transition function from \cref{eqn:Richter2008}
// to combine the calculated \glspl{nusselt} for laminar and turbulent flow
// in the transition interval $\num{400}<\gls{reynolds}<\num{1000}$.

  annotation (Documentation(info="<html>
<dl><dt>article <a name=\"Muley1999\">(</a>Muley1999)</dt>
<dd>Muley, A. and Manglik, R. M.</dd>
<dd><i>Experimental Study of Turbulent Flow Heat Transfer and Pressure Drop in a Plate Heat Exchanger With Chevron Plates</i></dd>
<dd>Journal of Heat Transfer, <b>1999</b>, Vol. 121(1), pp. 110-117 </dd>
</dl></html>"));
end MuleyManglik;
