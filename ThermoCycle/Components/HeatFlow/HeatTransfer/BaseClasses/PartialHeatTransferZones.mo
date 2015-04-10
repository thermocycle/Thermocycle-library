within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialHeatTransferZones
  "A partial heat transfer model with different HTC for liquid, two-phase and vapour"

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransfer;

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
annotation(Documentation(info="<html>

<p><big> The partial model <b>PartialHeatTransferZones</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass.PartialHeatTransfer\">PartialHeatTransfer</a> 
 and defines some inputs, that are needed to compute the convective heat transfer coefficient for a fluid flow:
   <ul><li> Mdotnom = Nominal mass flow rate
     <li> Unom_l = Nominal heat transfer coefficient liquid side
     <li> Unom_tp = Nominal heat transfer coefficient two phase side
     <li> Unom_v = Nominal heat transfer coefficient vapor side
     <li> M_dot = Mass flow circulating in the pipe
     <li> x = vapor quality of the fluid
     </ul>
</html>"));
end PartialHeatTransferZones;
