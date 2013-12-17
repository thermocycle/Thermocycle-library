within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialConvectiveCorrelation_IdealFluid

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass.PartialHeatTransfer_IdealFluid;

input Modelica.SIunits.MassFlowRate Mdotnom "Nomnial Mass flow rate";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient liquid side";
input Modelica.SIunits.MassFlowRate M_dot "Inlet massflow";

input Modelica.SIunits.Temperature T_fluid "Temperature of the fluid";

end PartialConvectiveCorrelation_IdealFluid;
