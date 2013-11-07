within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses;
partial model PartialConvectiveCorrelation

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass.PartialHeatTransfer;

input Modelica.SIunits.MassFlowRate Mdotnom "Nomnial Mass flow rate";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom_l
    "Nominal heat transfer coefficient liquid side";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp
    "nominal heat transfer coefficient two phase side";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom_v
    "nominal heat transfer coefficient vapor side";
input Modelica.SIunits.MassFlowRate M_dot "Inlet massflow";
//input Modelica.SIunits.Length diameter "Hydraulic diameter";
input Real x "Vapor quality";

end PartialConvectiveCorrelation;
