within ThermoCycle.Interfaces.Fluid;
connector Flange_ex_Cdot "B-type flange connector for Cdot-type heat source"
  output Modelica.SIunits.MassFlowRate Mdot "Mass flow rate";
  output Modelica.SIunits.SpecificHeatCapacity cp "Specific Heat capacity";
  output Modelica.SIunits.Density rho "Density of the fluid";
  output Modelica.SIunits.Temperature T "Temperature of the fluid";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Ellipse(extent={{-100,100},{100,-100}},
            lineColor={255,0,0}), Ellipse(
          extent={{-42,44},{44,-40}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Flange_ex_Cdot;
