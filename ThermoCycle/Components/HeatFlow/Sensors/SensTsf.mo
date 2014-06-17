within ThermoCycle.Components.HeatFlow.Sensors;
model SensTsf "Temperature sensor for  constant heat capacity fluid"
  extends ThermoCycle.Icons.Water.SensThrough;
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Interfaces.Fluid.Flange_Cdot inlet
    annotation (Placement(transformation(extent={{-80,-60},{-40,-20}})));
  Interfaces.Fluid.Flange_ex_Cdot outlet
    annotation (Placement(transformation(extent={{40,-60},{80,-20}})));
equation
  inlet.Mdot = outlet.Mdot;
  inlet.cp = outlet.cp;
  inlet.T = outlet.T;
  inlet.rho = outlet.rho;
  T = inlet.T;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-40,88},{42,28}},
          lineColor={0,0,0},
          textString="T")}),
    Documentation(info="<HTML>
    <p><big> Model <b>SensTsf</b> represents an ideal temperature sensor for a constant heat capacity fluid
</html>
"));
end SensTsf;
