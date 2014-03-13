within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
model VolumeForces "Converts pressure into forces on both ends of a cylinder"
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliant;
  parameter SI.Length bore;
  SI.AbsolutePressure p(min=10);
  constant Real pi=Modelica.Constants.pi;
  Modelica.Blocks.Interfaces.RealInput pressure annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,70})));
equation
  //s_rel contains the distance between the two flanges...
  p = pressure;
  f = -pi * bore^2/4 * p;
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-90,50},{90,-50}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-13,4},{-16,4},{-65,4},{-65,15},{-90,0},{-65,-15},{-65,-4},
              {-13,-4},{-13,4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-135,44},{-99,19}},
          lineColor={128,128,128},
          textString="a"),
        Text(
          extent={{97,40},{133,15}},
          lineColor={128,128,128},
          textString="b"),
        Polygon(
          points={{12,4},{70,4},{65,4},{65,15},{90,0},{65,-15},{65,-4},{12,-4},
              {12,4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-50},{150,-100}},
          textString="%name",
          lineColor={0,0,255})}),                         Diagram(
        coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-90,50},{90,-50}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,5},{70,5},{65,5},{65,16},{90,1},{65,-14},{65,-3},{12,-3},
              {12,5}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-13,5},{-16,5},{-65,5},{-65,16},{-90,1},{-65,-14},{-65,-3},
              {-13,-3},{-13,5}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
The gas force in a cylinder is computed as function of the relative
distance of the two flanges. It is required that s_rel = flange_b.s - flange_a.s
is in the range
</p>
<pre>
    0 &le; s_rel &le; L
</pre>
<p>
where the parameter L is the length
of the cylinder. If this assumption is not fulfilled, an error occurs.
</p>
</html>"));
end VolumeForces;
