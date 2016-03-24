within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Reservoir;
model Source_T
  parameter Integer nCV=2 "Number of control Volumes";

  Modelica.Blocks.Interfaces.RealInput Temperature annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-44,46}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,40})));
  Interfaces.MbIn mbIn[nCV] annotation (Placement(
        transformation(extent={{-10,-40},{10,-20}}), iconTransformation(extent=
            {{-20,-40},{20,-20}})));
equation
for i in 1:nCV loop
  mbIn[i].T = Temperature;
end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}}),
                   graphics={Rectangle(
          extent={{-80,20},{80,-30}},
          lineColor={175,175,175},
          fillPattern=FillPattern.Forward,
          fillColor={135,135,135})}), Diagram(graphics));
end Source_T;
