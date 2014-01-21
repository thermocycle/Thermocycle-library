within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialSinglePhaseCorrelation
  "Base class for single phase heat transfer correlations"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation(Dialog(tab="Internal Interface",enable=false));

  input Medium.ThermodynamicState state "Thermodynamic state";
  input Modelica.SIunits.MassFlowRate m_dot "Inlet massflow";

  Modelica.SIunits.CoefficientOfHeatTransfer U;

end PartialSinglePhaseCorrelation;
