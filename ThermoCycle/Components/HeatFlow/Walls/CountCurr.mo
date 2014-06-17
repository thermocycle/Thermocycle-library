within ThermoCycle.Components.HeatFlow.Walls;
model CountCurr
parameter Integer N=2 "Number of cells";
  parameter Boolean counterCurrent = true
    "Swap temperature and flux vector order";
  Interfaces.HeatTransfer.ThermalPort side1(final N=N)
    annotation (Placement(transformation(extent={{-40,20},{40,40}}),
        iconTransformation(extent={{-40,20},{40,40}})));
  Interfaces.HeatTransfer.ThermalPort side2(final N=N)
    annotation (Placement(transformation(extent={{-40,-40},{40,-20}}),
        iconTransformation(extent={{-40,-40},{40,-20}})));
equation
  // Swap temperature and flux vector order
  if counterCurrent then
    side1.phi = - side2.phi[N:-1:1];
    side1.T = side2.T[N:-1:1];
  else
    side1.phi = - side2.phi;
    side1.T = side2.T;
  end if;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-60,20},{60,-20}},
          fillColor={213,255,170},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.None),
        Text(
          extent={{42,36},{74,24}},
          lineColor={0,0,0},
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          textString="Side1"),
        Text(
          extent={{40,-24},{72,-36}},
          lineColor={0,0,0},
          fillColor={213,255,170},
          fillPattern=FillPattern.Solid,
          textString="Side2"),
        Polygon(
          points={{36,16},{54,12},{36,4},{48,12},{36,16}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Forward),
        Polygon(
          points={{-38,-4},{-56,-8},{-38,-16},{-50,-8},{-38,-4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Forward)}), Diagram(graphics),
    Documentation(info="<HTML>
<p><big> Model <b>CountCurr</b> is a mathematical model to twist the temperature and flux vector order. It is used to create a counter current heat exchanger.
</html>"));
end CountCurr;
