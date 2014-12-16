within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model NusseltHeatTransfer "Recip heat transfer with constant Nusselt number"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
  parameter Modelica.SIunits.NusseltNumber Nu0 "constant Nusselt number";
  parameter Modelica.SIunits.Length Gamma0(min=0) "Characteristic length";
  Modelica.SIunits.ThermalConductivity[n] lambda;
equation
  for i in 1:n loop
    lambda[i]  = Medium.thermalConductivity(states[i]);
    assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
    h[i]       = Nu0 * lambda[i] / Gamma0;
    //Q_flows[i] = (h[i]+k)*surfaceAreas[i]*(heatPorts[i].T - Ts[i]);
  end for;

  annotation(Documentation(info="<html>
  <p>Simple heat transfer correlation with constant Nusselt number. </p>
</html>"));
end NusseltHeatTransfer;
