within ThermoCycle.Components.HeatFlow.Sources;
model Source_T_cell
  Interfaces.HeatTransfer.ThermalPortL ThermalPortCell
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}}),
        iconTransformation(extent={{-32,-42},{50,-20}})));
  Modelica.Blocks.Interfaces.RealInput Temperature annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-44,46}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={10,50})));
equation
ThermalPortCell.T = Temperature;
  annotation (Icon(graphics={Rectangle(
          extent={{-70,30},{90,-20}},
          lineColor={175,175,175},
          fillPattern=FillPattern.Forward,
          fillColor={135,135,135})}));
end Source_T_cell;
