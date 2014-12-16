within ThermoCycle.Interfaces.Fluid;
connector FlangeA "A-type flange connector for real fluid flows"
  extends Fluid.Flange;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end FlangeA;
