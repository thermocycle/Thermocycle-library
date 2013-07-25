within ThermoCycle.Components.FluidFlow.Sources;
model inputs
  HeatFlow.Sources.SourceT1 sourceMdot
    annotation (Placement(transformation(extent={{-102,20},{36,96}})));
  SourceMdot1 sourceTemp
    annotation (Placement(transformation(extent={{-102,-46},{36,40}})));
  Modelica.Blocks.Interfaces.RealOutput y[4]
    annotation (Placement(transformation(extent={{80,-10},{100,12}}),
        iconTransformation(extent={{76,-12},{100,12}})));
  Modelica.Blocks.Sources.Constant const(k=2)
    annotation (Placement(transformation(extent={{-82,-72},{-62,-52}})));
equation
  y[2] = sourceMdot.y;
  y[1] = sourceTemp.y;
  y[3] = const.y;
  y[4] = smooth(1,if time < 200 then
    10 else
    15 + 5*sin(1.5 * Modelica.Constants.pi + 2 * Modelica.Constants.pi * 0.005 * (time-200)));
  annotation (                               Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-58,-34},{80,34}}, lineColor={0,0,255}),
          Text(
          extent={{-34,14},{54,-14}},
          lineColor={0,0,255},
          textString="DATA")}),
    Documentation(info="<html>
<p>This generic heat source profile corresponds to the measurements of vehicle exhaust gases, filtered with 5th-order Butterworth filter with a cuttoff frequency of 0.001.</p>
<p>Sylvain Quoilin, December 2012</p>
</html>"),
    experiment(StopTime=1669),
    __Dymola_experimentSetupOutput);
end inputs;
