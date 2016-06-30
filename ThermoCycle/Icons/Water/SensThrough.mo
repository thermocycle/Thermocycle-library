within ThermoCycle.Icons.Water;
model SensThrough
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-40,-20},{40,-60}}, lineColor={0,0,0}),
        Line(points={{0,20},{0,-20}}, color={0,0,0}),
        Ellipse(extent={{-40,100},{40,20}}, lineColor={0,0,0}),
        Line(points={{40,60},{60,60}}),
        Text(extent={{-100,-70},{100,-94}},  textString="%name")}));
end SensThrough;
