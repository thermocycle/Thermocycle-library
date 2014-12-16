within ThermoCycle.Components.HeatFlow.Sources;
model HeatSource "Source of fixed HeatFlux [W/m2] or HeatFlow[W]"
parameter Integer N(min=1)=1 "Number of nodes";
parameter Boolean HeatFlow= false
    "If True then Heat through thermal port = Phi/A else = Phi";
parameter Modelica.SIunits.Area A= 1 "Heat flux through the thermal port"
                                                                         annotation (Dialog(enable=HeatFlow));

  ThermoCycle.Interfaces.HeatTransfer.ThermalPort thermalPort(N=N)
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}}),
        iconTransformation(extent={{-42,-52},{40,-30}})));
  Modelica.Blocks.Interfaces.RealInput Phi annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-44,46}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,40})));

Modelica.SIunits.HeatFlux PhiCell;

equation
if HeatFlow then

PhiCell = -Phi/A;

else
PhiCell = -Phi;

end if;

for i in 1:N loop
  thermalPort.phi[i] = PhiCell;
end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Rectangle(
          extent={{-80,20},{80,-30}},
          lineColor={175,175,175},
          fillPattern=FillPattern.Forward,
          fillColor={135,135,135}), Text(
          extent={{-58,96},{76,60}},
          lineColor={0,0,255},
          textString="Q [W]")}),      Diagram(graphics));
end HeatSource;
