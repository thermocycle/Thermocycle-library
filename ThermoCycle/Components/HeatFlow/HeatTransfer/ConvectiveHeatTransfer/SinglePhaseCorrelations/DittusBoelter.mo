within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations;
model DittusBoelter
  "The Dittus-Boelter correlation for turbulent single phase flow"
  extends BaseClasses.PartialTPRePrCorrelation(final a=0.023,final b=0.8,final c=n);

  parameter Modelica.SIunits.Length d_hyd(min=0)
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
    "Hydraulic diameter";

  parameter Real n = 0.4 "0.4 for heating and 0.3 for cooling";

  Modelica.SIunits.VolumeFlowRate V_dot;

equation
  cLen  = d_hyd;
  V_dot = m_dot / rho;
  cVel  = V_dot / A_cro;

end DittusBoelter;
