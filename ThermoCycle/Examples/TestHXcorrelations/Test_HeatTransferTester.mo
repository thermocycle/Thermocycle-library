within ThermoCycle.Examples.TestHXcorrelations;
model Test_HeatTransferTester "A test driver for the different implementations of 
  heat transfer models"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Length a_hat = 0.0012;
  parameter Modelica.SIunits.Angle phi = Modelica.SIunits.Conversions.from_deg(65);
  parameter Modelica.SIunits.Length Lambda = 0.0075;
  parameter Modelica.SIunits.Length B_p = 0.04;

  parameter Real X =   2 * Modelica.Constants.pi*a_hat/Lambda;
  parameter Real Phi = 1/6 * ( 1 + sqrt(1+X^2) + 4 * sqrt(1+X^2/2));
  parameter Modelica.SIunits.Length d_h = 4 * a_hat / Phi;
  parameter Modelica.SIunits.Length d_e = 2 * a_hat;
  parameter Modelica.SIunits.Area A_cro = 2 * a_hat * B_p;

  model InputSelector
    replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium" annotation (
        choicesAllMatching=true);

    // Settings for heat transfer
    Medium.ThermodynamicState state(phase(start=0));
    // Settings for correlation
    parameter Modelica.SIunits.MassFlowRate m_dot_nom=m_dot_start
      "Nomnial Mass flow rate" annotation (Dialog(tab="Heat transfer"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_l=1500
      "Nominal heat transfer coefficient liquid side"
      annotation (Dialog(tab="Heat transfer"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_tp=6000
      "Nominal heat transfer coefficient two phase side"
      annotation (Dialog(tab="Heat transfer"));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_v=1000
      "Nominal heat transfer coefficient vapor side"
      annotation (Dialog(tab="Heat transfer"));
    Medium.AbsolutePressure p;
    Medium.SpecificEnthalpy h;
    Medium.Temperature T_port;
    Medium.Temperature T_start;
    Medium.Temperature T_end;
    Medium.SpecificEnthalpy h_start;
    Medium.SpecificEnthalpy h_end;
    Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
    Real x "Vapor quality";
    Real y "Relative position";
    Modelica.SIunits.Time c=10;

    Medium.ThermodynamicState bubbleState(h(start=0));
    Medium.ThermodynamicState dewState(h(start=0));

    replaceable model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
      constrainedby
      ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
      "Heat transfer model" annotation (choicesAllMatching=true);

    HeatTransfer heatTransfer(
      redeclare final package Medium = Medium,
      final n=1,
      FluidState={state},
      Mdotnom=m_dot_nom,
      Unom_l=U_nom_l,
      Unom_tp=U_nom_tp,
      Unom_v=U_nom_v,
      M_dot=m_dot,
      x=x);

    parameter Medium.AbsolutePressure p_start=1e5 "Start pressure";
    parameter Medium.AbsolutePressure p_end=p_start "Final pressure";

    parameter Modelica.SIunits.MassFlowRate m_dot_start=1 "Start flow rate";
    parameter Modelica.SIunits.MassFlowRate m_dot_end=m_dot_start
      "Final flow rate";

    parameter Boolean use_T=true "use temp. or heat flux?";
    parameter Modelica.SIunits.HeatFlux q=1.5e4 "constant heat flux";
    parameter Boolean Delta_T_const=false "Constant dT?";
    parameter Modelica.SIunits.TemperatureDifference Delta_T=5
      "wall temperature difference";
    ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T;
    parameter Boolean twoPhase=false "is two-phase medium?";
    parameter Real Delta_x=0.05;

    Medium.SpecificEnthalpy Delta_h, h_evap;

  equation
  bubbleState = Medium.setBubbleState(Medium.setSat_p(Medium.pressure(state)));
  dewState = Medium.setDewState(Medium.setSat_p(Medium.pressure(state)));
  h_evap = Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState);
  x = (Medium.specificEnthalpy(state) - Medium.specificEnthalpy(bubbleState))/h_evap;
  h_start = Medium.specificEnthalpy(bubbleState) - Delta_x*h_evap;
  h_end = Medium.specificEnthalpy(dewState) + Delta_x*h_evap;
  // Set the sweep variable
  y = time/c;
  // Linear pressure and mass flow functions
  p = (1 - y)*p_start + y*p_end;
  m_dot = (1 - y)*m_dot_start + y*m_dot_end;
  if twoPhase then
    // Full enthalpy range
    Delta_h = h_end-h_start;
    h = h_start + y*Delta_h;
    // Apply the Delta_T at the phase boundary
    T_end = Medium.temperature_ph(p_end, h_end) + Delta_T;
    T_start = Medium.temperature(bubbleState) + Delta_T - (Delta_x*(T_end -
      Delta_T - Medium.temperature(bubbleState)))/(1 + Delta_x - 0);
    //T_start = Medium.temperature_ph(p_start, h_start) + Delta_T;
  else
    // Only outside the two-phase domain
    Delta_h = h_end-h_start-h_evap;
    if (h_start+y*Delta_h)<Medium.specificEnthalpy(bubbleState) then
      h = h_start + y*Delta_h;
    else
      h = h_start + y*Delta_h + h_evap;
    end if;
    // Use the normal Delta_T
    T_start = Medium.temperature_ph(p_start, h_start) + Delta_T;
    T_end = Medium.temperature_ph(p_end, h_end) + Delta_T;
  end if;

  if use_T then
    if Delta_T_const then
      T_port = Medium.temperature(state) + Delta_T;
     else
      T_port = (1-y) * T_start     + y * T_end;
    end if;
  else
    heatTransfer.q_dot[1]=q;
  end if;
  state = Medium.setState_phX(p=p, h=h);
  T_port = source_T.Temperature;
  connect(heatTransfer.thermalPortL[1], source_T.ThermalPortCell);

  end InputSelector;

  InputSelector tester(
    redeclare package Medium = ThermoCycle.Media.R134a_CP(substanceNames={"R134a|debug=0|calc_transport=1|enable_EXTTP=1|enable_TTSE=0"}),
    m_dot_start=0.025,
    twoPhase=true,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhase,
    p_start=675000)
    annotation (Placement(transformation(extent={{-42,42},{-22,62}})));

  annotation (experiment(StopTime=10), Documentation(info="<html>
<p>The inputs to the heat transfer models are calculated here. Note that pipe correlations should use d_e as characteristic length while plate heat exchanger models should use d_h. </p>
</html>"));
end Test_HeatTransferTester;
