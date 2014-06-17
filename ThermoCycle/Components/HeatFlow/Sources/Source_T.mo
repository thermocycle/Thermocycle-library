within ThermoCycle.Components.HeatFlow.Sources;
model Source_T
parameter Integer N=2 "Number of nodes";
  Interfaces.HeatTransfer.ThermalPort thermalPort( N=N)
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}}),
        iconTransformation(extent={{-42,-52},{40,-30}})));
  Modelica.Blocks.Interfaces.RealInput Temperature annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-44,46}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,40})));
equation
for i in 1:N loop
  thermalPort.T[i] = Temperature;
end for;
  annotation (Icon(graphics={Rectangle(
          extent={{-80,20},{80,-30}},
          lineColor={175,175,175},
          fillPattern=FillPattern.Forward,
          fillColor={135,135,135})}), Diagram(graphics));
end Source_T;
