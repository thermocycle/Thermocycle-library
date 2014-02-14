within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations;
model DittusBoelter
  "The Dittus-Boelter correlation for turbulent single phase flow"
  extends BaseClasses.PartialTPRePrCorrelation(final a=0.023,final b=0.8,final c=n);

  parameter Modelica.SIunits.Length d_hyd(min=0)
    "Hydraulic diameter (2*V/A_lateral)";
  parameter Modelica.SIunits.Area A_cro(min=0) = Modelica.Constants.pi * d_hyd^2 / 4
    "Cross sectional area";

  parameter Real n = 0.4 "0.4 for heating and 0.3 for cooling";

  Modelica.SIunits.VolumeFlowRate V_dot;

equation
  cLen  = d_hyd;
  V_dot = m_dot / rho;
  cVel  = V_dot / A_cro;
annotation(Documentation(info="<html>

<p><big> The model <b>DittusBoelter</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTPRePrCorrelation\">PartialTPRePrCorrelation</a> and allows the user to define
 the value of the hydraulic diameter for the calculation of the heat transfer coefficient based on the DittusBoelter correlation.
 <p></p>
</html>"));
end DittusBoelter;
