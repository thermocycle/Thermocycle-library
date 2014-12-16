within ThermoCycle.Interfaces.Fluid;
connector FlangeB_pT
  "B-type flange connector for single phase fluid flows (p and T as state variables)"
  extends ThermoCycle.Interfaces.Fluid.Flange_pT;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end FlangeB_pT;
