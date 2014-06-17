within ThermoCycle.Components.FluidFlow.Sources;
model inputs2
  HeatFlow.Sources.SourceT2 sourceMdot
    annotation (Placement(transformation(extent={{-88,32},{40,102}})));
  SourceMdot2 sourceTemp
    annotation (Placement(transformation(extent={{-76,-24},{26,52}})));
  Modelica.Blocks.Interfaces.RealOutput y[4]
    annotation (Placement(transformation(extent={{80,-10},{100,12}}),
        iconTransformation(extent={{76,-12},{100,12}})));
  Modelica.Blocks.Sources.Constant const(k=2)
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
equation
  y[2] = sourceMdot.y;
  y[1] = sourceTemp.y;
  y[3] = const.y;
  y[4] = if time < 200 then
    10 else
    15 + 5*sin(1.5 * Modelica.Constants.pi + 2 * Modelica.Constants.pi * 0.005 * (time-200));
  annotation (                               Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-58,-34},{80,34}}, lineColor={0,0,255}),
          Text(
          extent={{-34,14},{54,-14}},
          lineColor={0,0,255},
          textString="DATA")}),
    Documentation(info="<html>
<p>This generic heat source profile corresponds to the measurements of vehicle exhaust gases, filtered with 5th-order Butterworth filter with a cuttoff frequency of 0.005.</p>
<p>Sylvain Quoilin, December 2012</p>
</html>"));
end inputs2;
