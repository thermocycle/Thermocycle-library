within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialConvectiveSmoothed "Smoothed heat transfer coefficients"

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;

parameter Real smoothingRange(min=0,max=1) = 0.2
    "Vapour quality smoothing range";
parameter Real    massFlowExp(min=0,max=1) = 0.8
    "Mass flow correction term, disable with 0.0";
  parameter Integer forcePhase=0 "Ignore all other phases" annotation (choices(
      choice=0 "Disabled",
      choice=1 "Liquid",
      choice=2 "Two-phase",
      choice=3 "Gaseous"));

// parameter Modelica.SIunits.MassFlowRate m_dot_nom "Nomnial Mass flow rate" annotation(Dialog(group="Nominal Operation"));
// parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_l
//     "Nominal heat transfer coefficient liquid side" annotation(Dialog(group="Nominal Operation"));
// parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_tp
//     "nominal heat transfer coefficient two phase side" annotation(Dialog(group="Nominal Operation"));
// parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_v
//     "nominal heat transfer coefficient vapor side" annotation(Dialog(group="Nominal Operation"));
//input Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
//input Real x "Vapor quality";

  Modelica.SIunits.CoefficientOfHeatTransfer[n] U;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_nom_LTP;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_nom_TPV;
  Modelica.SIunits.CoefficientOfHeatTransfer    U_nom;

  Real LTP(min=0,max=1);
  Real TPV(min=0,max=1);
  Real LV(min=0, max=1);
  Real massFlowFactor(min=0);
  Real x_L;
  Real x_LTP;
  Real x_TPV;
  Real x_V "Vapor quality";

  Real divisor = 10;

equation
  x_L   = 0-smoothingRange/divisor;
  x_LTP = 0+smoothingRange/divisor;
  x_TPV = 1-smoothingRange/divisor;
  x_V   = 1+smoothingRange/divisor;
  if forcePhase == 0 then
    LTP = ThermoCycle.Functions.transition_factor_alt(switch=0, trans=smoothingRange, position=x);
    TPV = ThermoCycle.Functions.transition_factor_alt(switch=1, trans=smoothingRange, position=x);
    // Not really needed, but might be more robust
    LV  = ThermoCycle.Functions.transition_factor(start=0,    stop=1,     position=x);
  elseif forcePhase == 1 then // liquid only
    LTP = 0;
    TPV = 1;
    LV  = 0;
  elseif forcePhase == 2 then // two-phase only
    LTP = 1;
    TPV = 0;
    LV  = ThermoCycle.Functions.transition_factor(start=0,    stop=1,     position=x);
  elseif forcePhase == 3 then // gas only
    LTP = 0;
    TPV = 1;
    LV  = 1;
  else
    assert(1==0,"Error in phase determination");
  end if;

  U_nom_LTP = (1-LTP)* Unom_l    + LTP*Unom_tp;
  U_nom_TPV = (1-TPV)* Unom_tp   + TPV*Unom_v;
  U_nom     = (1-LV) * U_nom_LTP + LV* U_nom_TPV;
  // Do the mass flow correction
  massFlowFactor = noEvent(abs(M_dot/Mdotnom)^massFlowExp);

annotation(Documentation(info="<html>

<p><big> The partial model <b>PartialConvectiveSmoothed</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation\">PartialConvectiveCorrelation</a> 
 and smooth the value of the heat transfer coefficient between the liquid, two-phase
 and vapor nominal heat transfer coefficient values using the  <a href=\"modelica://ThermoCycle.Functions.transition_factor\">transition factor</a> based on the vapor quality value of the fluid flow.</p>
   <p></p>
</html>"));
end PartialConvectiveSmoothed;
