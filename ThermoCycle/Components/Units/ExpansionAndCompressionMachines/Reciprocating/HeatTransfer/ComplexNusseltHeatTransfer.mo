within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model ComplexNusseltHeatTransfer
  "Recip heat transfer with constant complex Nusselt number"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
  input Modelica.SIunits.NusseltNumber Nu_r "Nusselt number, real part";
  input Modelica.SIunits.NusseltNumber Nu_i "Nusselt number, imaginary part";
  input Modelica.SIunits.Length Gamma0(min=0) "Characteristic length";
  Modelica.SIunits.NusseltNumber[n] Nu0 "Nusselt number, combined";
  Modelica.SIunits.ThermalConductivity[n] lambda;
equation
  for i in 1:n loop
    lambda[i]  = Medium.thermalConductivity(states[i]);
    assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
    Nu0[i]     = Nu_r + Nu_i/omega_c * der(Ts[i]) / (Ts[i] - heatPorts[i].T);
    h[i]       = Nu0[i] * lambda[i] / Gamma0;
    //Q_flows[i] = (h[i]+k)*surfaceAreas[i]*(heatPorts[i].T - Ts[i]);
  end for;

  annotation(Documentation(info="<html>
  <p>Simple heat transfer correlation with constant Nusselt number. </p>
</html>"));
end ComplexNusseltHeatTransfer;
