within ThermoCycle.Icons.Water;
partial model PumpMech
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                extent={{54,28},{80,12}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={160,160,164}),Polygon(
                points={{-40,-24},{-60,-60},{60,-60},{40,-24},{-40,-24}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,191},
                fillPattern=FillPattern.Solid),Ellipse(
                extent={{-60,80},{60,-40}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere),Polygon(
                points={{-30,52},{-30,-8},{48,20},{-30,52}},
                lineColor={0,0,0},
                pattern=LinePattern.None,
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={255,255,255}),Text(extent={{-100,-64},{100,-90}},
          textString="%name")}));
end PumpMech;
