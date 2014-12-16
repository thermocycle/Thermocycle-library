within ThermoCycle.Icons.Water;
partial model Valve
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{0,40},{0,0}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-80,40},{-80,-40},{0,0},{-80,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Polygon(
          points={{80,40},{0,0},{80,-40},{80,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-20,60},{20,40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics));
end Valve;
