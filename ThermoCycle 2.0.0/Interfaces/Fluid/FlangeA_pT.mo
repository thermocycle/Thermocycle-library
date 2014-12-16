within ThermoCycle.Interfaces.Fluid;
connector FlangeA_pT
  "A-type flange connector for single-phase fluid flows (with p and T as state variables)"
  extends ThermoCycle.Interfaces.Fluid.Flange_pT;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,127,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}));
end FlangeA_pT;
