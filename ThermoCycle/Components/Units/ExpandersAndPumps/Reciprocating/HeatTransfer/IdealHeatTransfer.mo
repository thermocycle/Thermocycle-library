within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.HeatTransfer;
model IdealHeatTransfer "Recip heat transfer without thermal resistance"
  extends
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
equation
  Ts = heatPorts.T;
  annotation(Documentation(info="<html>
<p>Ideal heat transfer without thermal resistance. </p>
<p><br/>This is taken from: Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer</p>
</html>"));
end IdealHeatTransfer;
