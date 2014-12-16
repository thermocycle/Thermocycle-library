within ThermoCycle.Interfaces.Fluid;
connector FlangeA_limit
  "A-type flange connector real fluid flows with enthalpy limiter"
  extends Fluid.Flange;
  stream Modelica.SIunits.SpecificEnthalpy h_limit;
  annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>Implementation of the enthalpy limiter model as proposed in: </p>
<p>Schulze et al., A limiter for Preventing Singularity in Simplified Finite Volume Methods</p>
<p><br/>S. Quoilin, July 2013</p>
</html>"));
end FlangeA_limit;
