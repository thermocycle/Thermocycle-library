within ThermoCycle.Interfaces.HeatTransfer;
model HeatPortConverter "Convert thermal port into heat port"
  parameter Integer N = 10;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ThermalPortL thermalPortL annotation (Placement(transformation(extent={{95,-5},
            {105,5}}), iconTransformation(extent={{90,-10},{110,10}})));
parameter Modelica.SIunits.Area A = 1 "Heat exchange area";
equation
  thermalPortL.T = heatPort.T;
  thermalPortL.phi = -heatPort.Q_flow/A;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{0,30},{100,10}},
          lineColor={0,0,255},
          textString="Thermal"),Text(
          extent={{-100,30},{0,10}},
          lineColor={0,0,255},
          textString="Heat")}));
end HeatPortConverter;
