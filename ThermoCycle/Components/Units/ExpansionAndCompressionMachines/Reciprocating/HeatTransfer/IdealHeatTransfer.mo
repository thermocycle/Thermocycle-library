within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model IdealHeatTransfer "Recip heat transfer without thermal resistance"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
equation
  Ts = heatPorts.T;
  //for i in 1:n loop
  //  h[i] = 1;
  //end for;
  annotation(Documentation(info="<html>
<p>Ideal heat transfer without thermal resistance. </p>
<p><br/>This is taken from: Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer</p>
</html>"));
end IdealHeatTransfer;
