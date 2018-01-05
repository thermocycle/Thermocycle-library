within ThermoCycle.Components.Units.HeatExchangers;
model Semi_isothermal_HeatExchanger
  "Steady-state model of a semi-isothermal heat exchanger using epsilon-NTU"
  import ThermoCycle;
replaceable package Medium = ThermoCycle.Media.DummyFluid;

Medium.ThermodynamicState inlet;
Medium.ThermodynamicState outlet;
parameter Modelica.SIunits.ThermalConductance AU = 35 "Thermal conductance";
Modelica.SIunits.Power Q_dot;
Medium.Temperature T_iso; //Température de la plaque isotherme
Real C_dot_min;
Real NTU;
Real epsilon;
  ThermoCycle.Interfaces.Fluid.FlangeA supply(
    redeclare package Medium =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22)
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB exhaust(
    redeclare package Medium =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
                                          h_outflow(stateSelect = StateSelect.prefer))
    annotation (Placement(transformation(extent={{88,-8},{108,12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_th
    annotation (Placement(transformation(extent={{-10,-104},{10,-84}})));

equation
/* Thermodynamic state at the inlet of the heat exchanger */
inlet = Medium.setState_ph(supply.p,inStream(supply.h_outflow));
/* Thermodynamic state at the outlet of the heat exchanger */
outlet = Medium.setState_ph(exhaust.p,exhaust.h_outflow);

C_dot_min = supply.m_flow*(inlet.cp + outlet.cp)/2;
NTU = AU/C_dot_min;
epsilon = 1-exp(-NTU); //Heat exchanger efficiency

if supply.m_flow > 0 then Q_dot = epsilon*C_dot_min*(inlet.T - T_iso);
else Q_dot = epsilon*C_dot_min*(outlet.T - T_iso);
end if;

supply.h_outflow = outlet.h - Q_dot/exhaust.m_flow;
exhaust.h_outflow = inlet.h - Q_dot/supply.m_flow;

//Mass balance
supply.m_flow + exhaust.m_flow = 0;

/* BOUNDARY CONDITIOS */
supply.p = exhaust.p;
port_th.T = T_iso;
port_th.Q_flow = -Q_dot;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-82,90},{78,-70}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-15,80},{15,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          origin={-1,-76},
          rotation=90),
        Line(points={{-68,0},{32,3.73579e-015}},
                                          color={191,0,0},
          origin={-26,6},
          rotation=90),
        Line(points={{0,80},{0,-80}},     color={0,127,255},
          origin={2,-36},
          rotation=-90),
        Line(points={{82,-36},{60,-24}},   color={0,127,255}),
        Line(points={{62,-48},{82,-36}},   color={0,127,255}),
        Line(points={{-36,20},{-26,38}}, color={191,0,0}),
        Line(points={{-26,38},{-16,20}}, color={191,0,0}),
        Line(points={{0,80},{0,-80}},     color={0,127,255},
          origin={0,4},
          rotation=-90),
        Line(points={{60,-8},{80,4}},      color={0,127,255}),
        Line(points={{80,4},{58,16}},      color={0,127,255}),
        Line(points={{0,80},{0,-80}},     color={0,127,255},
          origin={0,46},
          rotation=-90),
        Line(points={{60,34},{80,46}},     color={0,127,255}),
        Line(points={{80,46},{58,58}},     color={0,127,255}),
        Line(points={{-68,0},{32,3.73579e-015}},
                                          color={191,0,0},
          origin={20,6},
          rotation=90),
        Line(points={{10,20},{20,38}},   color={191,0,0}),
        Line(points={{20,38},{30,20}},   color={191,0,0})}),
    Documentation(info="<html>
<p>Steady-state model of a semi-isothermal heat exchanger using the well-know epsilon-NTU method.</p>
</html>"));
end Semi_isothermal_HeatExchanger;
