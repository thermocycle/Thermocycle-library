within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses;
partial model PartialCylinderHeatTransfer
  extends
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer;
    input Modelica.SIunits.Angle crankshaftAngle;
    input Modelica.SIunits.Area pistonCrossArea;
    input Modelica.SIunits.Length strokeLength;
    Modelica.SIunits.CoefficientOfHeatTransfer[n] h;
    Modelica.SIunits.HeatFlux[n] q_w "Heat flux from wall";
equation
for i in 1:n loop
    // There is a small mistake in equation 19 of the paper, DeltaT goes in the numerator.
    -q_w[i] = h[i] * (Ts[i] - heatPorts[i].T);
    Q_flows[i] = surfaceAreas[i]*q_w[i];
  end for;
  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Heat Transfer Models</font></h4></p>
<p>Base class for heat transfer correlations. The information available inside the subclasses are:</p>
<p>Integer <b>n</b>: The number of entries in the follwoing arrays. Gets defined as 1 in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>PartialMedium <b>Medium</b>: The fluid model used to obtain properties. Redeclared in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>ThermodynamicState <b>states[]:</b> States of working fluid in the cylinder. Also defined in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>Area <b>surfaceAreas[]</b>: Array with areas used for heat exchange. Note that there is probably only one element in this array. The actual area gets calculated from cylinder geometry and does NOT include the piston. Hence it expresses the area of the wall-to-fluid interface. Value from Modelica.Fluid.Machines.SweptVolume.</p>
<p>Angle <b>crankshaftAngle</b>: Angle information from the crankshaft. Can be supplied via an input connector, set to 0 otherwise. </p>
<p>Area <b>pistonCrossArea</b>: The surface area of the piston. Can be used to obtain the volume from surfaceAreas variable.</p>
<p>Length <b>strokeLength</b>: The stroke of the machine. Can be used to obtain mean piston speed and alike.</p>
</html>"));
end PartialCylinderHeatTransfer;
