within ThermoCycle.Icons.Gas;
partial model Turbine
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Polygon(
                points={{-28,76},{-28,28},{-22,28},{-22,82},{-60,82},{-60,
            76},{-28,76}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid),Polygon(
                points={{26,56},{32,56},{32,76},{60,76},{60,82},{26,82},{
            26,56}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid),Rectangle(
                extent={{-60,8},{60,-8}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={160,160,164}),Polygon(
                points={{-28,28},{-28,-26},{32,-60},{32,60},{-28,28}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
end Turbine;
