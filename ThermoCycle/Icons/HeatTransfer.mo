within ThermoCycle.Icons;
model HeatTransfer

annotation (
      Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),        graphics={Ellipse(
            extent={{-60,64},{60,-56}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Sphere,
            fillColor={232,0,0}), Text(
            extent={{-38,26},{40,-14}},
            lineColor={0,0,0},
            textString="%name")}),
    Diagram(graphics));
end HeatTransfer;
