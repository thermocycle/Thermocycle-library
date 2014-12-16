within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model ConstantHeatTransfer
  "Recip heat transfer with constant heat transfer coefficient"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0
    "constant heat transfer coefficient";
equation
  Q_flows = {(alpha0+k)*surfaceAreas[i]*(heatPorts[i].T - Ts[i]) for i in 1:n};
  annotation(Documentation(info="<html>
<p>Simple heat transfer correlation with constant heat transfer coefficient. </p>
<p>Taken from: Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.ConstantHeatTransfer</p>
</html>"));
end ConstantHeatTransfer;
