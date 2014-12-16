within ThermoCycle.Icons.Water;
partial model Header
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Ellipse(
                extent={{-80,80},{80,-80}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),Ellipse(extent={{70,70},{-70,
          -70}}, lineColor={95,95,95}),Text(extent={{-100,-84},{100,-110}},
          textString="%name")}), Diagram(graphics));
end Header;
