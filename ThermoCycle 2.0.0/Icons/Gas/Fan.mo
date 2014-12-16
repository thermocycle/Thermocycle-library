within ThermoCycle.Icons.Gas;
partial model Fan
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Polygon(
                points={{-38,-24},{-58,-60},{62,-60},{42,-24},{-38,-24}},
                lineColor={95,95,95},
                lineThickness=1,
                fillColor={170,170,255},
                fillPattern=FillPattern.Solid),Ellipse(
                extent={{-60,80},{60,-40}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,170,255}),Polygon(
                points={{-30,52},{-30,-8},{48,20},{-30,52}},
                lineColor={0,0,0},
                pattern=LinePattern.None,
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={255,255,255}),Text(
                extent={{-100,-64},{100,-90}},
                lineColor={95,95,95},
                textString="%name")}));
end Fan;
