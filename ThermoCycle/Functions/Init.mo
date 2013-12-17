within ThermoCycle.Functions;
model Init "Smooth transition between two values"
  parameter Modelica.SIunits.Time t_init=10 "Starting time of the transition";
  parameter Modelica.SIunits.Time length=3 "Duration of the transition";
  parameter Boolean noevent=false
    "Avoids the generation of events during the transition";
  Modelica.Blocks.Interfaces.RealInput u1 "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-58},{-100,-18}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u2 "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-58},{-100,-18}},
          rotation=0), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real input signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}},
          rotation=0), iconTransformation(extent={{88,-18},{128,22}})));
equation
  if noevent then
    y = smooth(1, noEvent(if time < t_init then u1 elseif time < t_init +
      length then u1 + (u2 - u1)*(0.5 - 0.5*cos((time - t_init)*Modelica.Constants.pi
      /length)) else u2));
  else
    y = u1 + (u2 - u1)*ThermoCycle.Functions.weightingfactor(
      t_init=t_init,
      length=length,
      t=time);
  end if;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
        Line(points={{-90,-70},{68,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
        Line(
          points={{-80,-40},{-28,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,0},{24,12},{32,24},{42,32},{56,38},{70,40},{68,40}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{20,0},{16,-12},{8,-24},{-2,-32},{-16,-38},{-30,-40},{-28,-40}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{70,40},{80,40},{84,40},{68,40}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,40},{68,40},{76,40}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Text(
          extent={{-28,-90},{46,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          textString="Time"),
        Text(
          extent={{-70,60},{90,92}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          textString="Initialisation")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p>Smooth transition between u1 and u2 (C1-continuous). Allows initiating the simulation with constant values, which avoids initialization issues.</p>
<p>S.Quoilin (University of Li&egrave;ge)</p>
<p>July 2013</p>
</html>"));
end Init;
