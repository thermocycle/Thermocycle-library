within ThermoCycle.Icons.Water;
partial model SourceW
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-80,40},{80,-40}}, lineColor={0,0,0}),
        Polygon(
          points={{-12,-20},{66,0},{-12,20},{34,0},{-12,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{-100,-52},{100,-80}}, textString="%name")}));
end SourceW;
