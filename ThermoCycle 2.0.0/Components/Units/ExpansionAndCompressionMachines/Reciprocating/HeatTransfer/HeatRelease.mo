within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model HeatRelease "Heat release model for IC engines"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

    parameter Modelica.SIunits.HeatFlowRate peak = 5e3
    "Peak value of heat release.";

    parameter Modelica.SIunits.Angle on =  Modelica.SIunits.Conversions.from_deg(5)
    "Start of heat release.";
    parameter Modelica.SIunits.Angle off = Modelica.SIunits.Conversions.from_deg(15)
    "End of heat release.";
    parameter Modelica.SIunits.Angle swi = Modelica.SIunits.Conversions.from_deg(5)
    "Length for heat release development.";

  ValveTimer valveTimer(
    use_angle_in=true,
    input_in_rad=true,
    open=on,
    close=off,
    switch=swi)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  valveTimer.angle_in = crankshaftAngle;
  for i in 1:n loop
    // Calculate the heat transfer directly
    -q_w[i]*surfaceAreas[i] = valveTimer.y * peak;
  end for;
  annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Kornhauser1994\">(Kornhauser1994)</a></dt>
<dd>Kornhauser, A. &amp; Smith, J.</dd>
<dd><i>Application of a complex Nusselt number to heat transfer during compression and expansion</i></dd>
<dd>Transactions of the ASME. Journal of Heat Transfer, <b>1994</b>, Vol. 116(3), pp. 536-542</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736\">http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736</a></p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
end HeatRelease;
