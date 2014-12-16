within ThermoCycle.Interfaces.Fluid;
connector FlangeB_limit "B-type flange connector for real fluid flows"
  extends Fluid.Flange;
  stream Modelica.SIunits.SpecificEnthalpy h_limit;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>Implementation of the enthalpy limiter model as proposed in: </p>
<p>Schulze et al., A limiter for Preventing Singularity in Simplified Finite Volume Methods</p>
<p><br/>S. Quoilin, July 2013</p>
</html>"));
end FlangeB_limit;
