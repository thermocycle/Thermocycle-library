within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model TestHeatTransfer
  extends Modelica.Icons.Example;

model InputSelector
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium "Medium"
    annotation(choicesAllMatching=true);

// Settings for heat transfer
Medium.ThermodynamicState state(phase(start=0));
// Settings for correlation
parameter Modelica.SIunits.MassFlowRate m_dot_nom = 1 "Nomnial Mass flow rate"
                           annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_l = 2000
      "Nominal heat transfer coefficient liquid side"
                                                  annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_tp = 3000
      "Nominal heat transfer coefficient two phase side"
                                                     annotation (Dialog(tab="Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom_v = 1500
      "Nominal heat transfer coefficient vapor side"
                                                 annotation (Dialog(tab="Heat transfer"));
Medium.AbsolutePressure p;
Medium.SpecificEnthalpy h;
Medium.SpecificEnthalpy h_start;
Medium.SpecificEnthalpy h_end;
Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";
Real x "Vapor quality";
Real y "Relative position";
Modelica.SIunits.Time c = 10;

Medium.ThermodynamicState bubbleState(h(start=0)), dewState(h(start=0));

replaceable model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
  constrainedby
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
      "Heat transfer model"
    annotation(choicesAllMatching=true);

    HeatTransfer heatTransfer(
  redeclare final package Medium = Medium,
  final n = 1,
  FluidState = {state},
  Mdotnom = m_dot_nom,
  Unom_l =  U_nom_l,
  Unom_tp = U_nom_tp,
  Unom_v =  U_nom_v,
  M_dot = m_dot,
  x = x);

    parameter Medium.AbsolutePressure p_start = 1e5 "Start pressure";
    parameter Medium.AbsolutePressure p_end = p_start "Final pressure";

    parameter Modelica.SIunits.MassFlowRate m_dot_start = 1 "Start flow rate";
    parameter Modelica.SIunits.MassFlowRate m_dot_end = m_dot_start
      "Final flow rate";

    parameter Boolean twoPhase = false "is two-phase medium?";
    parameter Medium.SpecificEnthalpy h_start_in = 0 "Start enthalpy"
      annotation(Dialog(enable = not twoPhase));

    parameter Medium.SpecificEnthalpy h_end_in = h_start_in "Final enthalpy"
      annotation(Dialog(enable = not twoPhase));

  //parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
  //  "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

// Settings for heat transfer
// replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
// input Medium.ThermodynamicState[n] FluidState
// Settings for correlation
// input Modelica.SIunits.MassFlowRate Mdotnom "Nomnial Mass flow rate";
// input Modelica.SIunits.CoefficientOfHeatTransfer Unom_l
//     "Nominal heat transfer coefficient liquid side";
// input Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp
//     "nominal heat transfer coefficient two phase side";
// input Modelica.SIunits.CoefficientOfHeatTransfer Unom_v
//     "nominal heat transfer coefficient vapor side";
// input Modelica.SIunits.MassFlowRate M_dot "Inlet massflow";
// input Modelica.SIunits.QualityFactor x "Vapor quality";

equation
  if twoPhase then
    bubbleState = Medium.setBubbleState(Medium.setSat_p(Medium.pressure(state)));
    dewState    = Medium.setDewState(   Medium.setSat_p(Medium.pressure(state)));
    x           = (Medium.specificEnthalpy(state) - Medium.specificEnthalpy(bubbleState))/(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
    h_start     = Medium.specificEnthalpy(bubbleState) - 0.25*(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
    h_end       = Medium.specificEnthalpy(dewState)    + 0.25*(Medium.specificEnthalpy(dewState) - Medium.specificEnthalpy(bubbleState));
  else
    bubbleState = state;
    dewState    = state;
    x           = 0;
    h_start     = h_start_in;
    h_end       = h_end_in;
  end if;
  y = time/c;
  p     = (1-y) * p_start     + y * p_end;
  m_dot = (1-y) * m_dot_start + y * m_dot_end;
  h     = (1-y) * h_start     + y * h_end;
  state = Medium.setState_phX(p=p,h=h);

end InputSelector;

  InputSelector tester(
    h_start_in=100e3,
    twoPhase=true,
    redeclare package Medium = ThermoCycle.Media.R134aCP,
    redeclare model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SmoothedInit
        (
        redeclare model TwoPhaseCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations.Constant,

        filterConstant=0.01,
        max_dUdt=0,
        redeclare model LiquidCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
            (d_hyd=0.1),
        t_start=0,
        t_init=0.5,
        redeclare model VapourCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations.DittusBoelter
            (d_hyd=0.1),
        smoothingRange=0.1),
    p_start=500000,
    m_dot_start=3)
    annotation (Placement(transformation(extent={{-42,42},{-22,62}})));

  annotation (experiment(StopTime=10));
end TestHeatTransfer;
