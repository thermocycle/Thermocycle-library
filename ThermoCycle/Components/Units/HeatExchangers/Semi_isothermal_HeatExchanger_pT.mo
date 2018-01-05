within ThermoCycle.Components.Units.HeatExchangers;
model Semi_isothermal_HeatExchanger_pT
  "Steady-state model of a semi-isothermal heat exchanger using epsilon-NTU"
  import ThermoCycle;
replaceable package Medium = ThermoCycle.Media.DummyFluid;
Medium.Temperature T_su(start=T_su_start);
Medium.Temperature T_ex(start=T_ex_start);
parameter Medium.Temperature T_su_start=273.15+200
    "Start value for the inlet temperature" annotation(Dialog(tab = "Initialization"));
parameter Medium.Temperature T_ex_start=273.15+100
    "Start value for the outlet temperature" annotation(Dialog(tab = "Initialization"));
Medium.ThermodynamicState meanState;
parameter Modelica.SIunits.ThermalConductance AU = 35 "Thermal conductance";
Modelica.SIunits.Power Q_dot;
Medium.Temperature T_iso; //Température de la plaque isotherme
Real C_dot;
Real NTU;
Real epsilon;
  ThermoCycle.Interfaces.Fluid.FlangeA_pT supply(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB_pT exhaust(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,-8},{108,12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_th
    annotation (Placement(transformation(extent={{-10,-104},{10,-84}})));

equation
//Etat en entrée de l'échangeur semi-isothermes
meanState= Medium.setState_pT(supply.p,(T_su + T_ex)/2);
supply.p = exhaust.p;
C_dot = supply.m_flow*Medium.specificHeatCapacityCp(meanState);
NTU = AU/C_dot;
epsilon = 1-exp(-NTU); //Efficacité de l'échangeur
if supply.m_flow > 0 then
  T_su = inStream(supply.T_outflow);
  Q_dot = epsilon*C_dot*(T_su - T_iso);
else
  T_ex = inStream(exhaust.T_outflow);
  Q_dot = -epsilon*C_dot*(T_ex - T_iso);
end if;

T_ex = T_su - Q_dot/C_dot;

  supply.T_outflow = T_su;
  exhaust.T_outflow = T_ex;

//Conservation du débit
supply.m_flow + exhaust.m_flow = 0;

//Informations au port thermique
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
end Semi_isothermal_HeatExchanger_pT;
