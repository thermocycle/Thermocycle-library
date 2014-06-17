within ThermoCycle.Icons.Water;
partial model SteamTurbineUnit
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
                points={{14,20},{14,42},{38,42},{38,20}},
                color={0,0,0},
                thickness=0.5),Rectangle(
                extent={{-100,8},{100,-8}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={160,160,164}),Polygon(
                points={{-14,48},{-14,-48},{14,-20},{14,20},{-14,48}},
                lineColor={0,0,0},
                lineThickness=0.5,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),Polygon(
                points={{38,20},{38,-20},{66,-46},{66,48},{38,20}},
                lineColor={0,0,0},
                lineThickness=0.5,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),Polygon(
                points={{-66,20},{-66,-20},{-40,-44},{-40,48},{-66,20}},
                lineColor={0,0,0},
                lineThickness=0.5,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),Line(
                points={{-100,70},{-100,70},{-66,70},{-66,20}},
                color={0,0,0},
                thickness=0.5),Line(
                points={{-40,46},{-40,70},{26,70},{26,42}},
                color={0,0,0},
                thickness=0.5),Line(
                points={{-14,-46},{-14,-70},{66,-70},{66,-46}},
                color={0,0,0},
                thickness=0.5),Line(
                points={{66,-70},{100,-70}},
                color={0,0,255},
                thickness=0.5)}), Diagram(graphics));
end SteamTurbineUnit;
