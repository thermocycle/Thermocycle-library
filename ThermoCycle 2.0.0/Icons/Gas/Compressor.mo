within ThermoCycle.Icons.Gas;
partial model Compressor
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Polygon(
                points={{24,26},{30,26},{30,76},{60,76},{60,82},{24,82},{
            24,26}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid),Polygon(
                points={{-30,76},{-30,56},{-24,56},{-24,82},{-60,82},{-60,
            76},{-30,76}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid),Rectangle(
                extent={{-60,8},{60,-8}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={160,160,164}),Polygon(
                points={{-30,60},{-30,-60},{30,-26},{30,26},{-30,60}},
                lineColor={128,128,128},
                lineThickness=0.5,
                fillColor={159,159,223},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
end Compressor;
