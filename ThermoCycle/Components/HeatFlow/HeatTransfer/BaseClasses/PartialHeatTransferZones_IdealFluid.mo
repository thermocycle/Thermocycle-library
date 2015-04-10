within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialHeatTransferZones_IdealFluid
  "A partial heat transfer model with one ideal nominal HTC for all zones"

extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransfer_IdealFluid;

input Modelica.SIunits.MassFlowRate Mdotnom "Nomnial Mass flow rate";
input Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient liquid side";
input Modelica.SIunits.MassFlowRate M_dot "Inlet massflow";

input Modelica.SIunits.Temperature T_fluid "Temperature of the fluid";

annotation(Documentation(info="<html>

<p><big> The partial model <b>PartialHeatTransferZones_IdealFluid</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass.PartialHeatTransfer_IdealFluid\">PartialHeatTransfer_IdealFluid</a> 
 and defines some inputs, that are needed to compute the convective heat transfer coefficient for an ideal fluid flow:
   <ul><li> Mdotnom = Nominal mass flow rate
     <li> T_fluid = Temperature of the fluid
     <li> Unom = Nominal heat transfer coefficient
     <li> M_dot = Mass flow circulating in the pipe
     
     </ul>
</html>"));
end PartialHeatTransferZones_IdealFluid;
