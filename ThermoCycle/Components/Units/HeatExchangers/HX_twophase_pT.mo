within ThermoCycle.Components.Units.HeatExchangers;
model HX_twophase_pT
  replaceable package Medium_iso =ThermoCycle.Media.Water  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid (two-phase)" annotation (choicesAllMatching=true);
  replaceable package Medium_sf =
      ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas                             constrainedby
    Modelica.Media.Interfaces.PartialMedium "Single-phase fluid" annotation (choicesAllMatching=true);

  /******************************* PARAMETERS *****************************/
  /*Metal Wall*/
  parameter Modelica.SIunits.Mass M_wall= 69 "Mass of the Wall";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 500
    "Specific heat capacity of the metal";

  /******************HEAT TRANSFER******************/
  parameter Modelica.SIunits.Area A_iso=0.03 annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.Area A_sf=0.03 annotation (Dialog(group="Heat transfer", tab="General", enable=(not Use_AU)));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_iso
    "Constant heat transfer coefficient, isothermal fluid Side" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sf
    "Constant heat transfer coefficient, secondary fluid Side" annotation (Dialog(group="Heat transfer", tab="General"));

  /******************    Initialization parameters    ******************/
  parameter Modelica.SIunits.Temperature T_sf_su_start=273.15+200
    "Start value for secondary fluid the inlet temperature" annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Temperature T_sf_ex_start=273.15+100
    "Start value for the secondary fluid outlet temperature" annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Temperature T_iso_start=273.15 + 50
    "Start value for the isothermal fluid temperature" annotation(Dialog(tab= "Initialization"));
  parameter Modelica.SIunits.Temperature T_w_start=273.15+60
    "Initial value of wall temperature"                                                  annotation (Dialog(tab="Initialization"));
  parameter Boolean steadystate_T_wall=false
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
  parameter Boolean T_wall_fixed=false
    "if true, imposes the initial wall temperature"                               annotation (Dialog(group="Initialization options", tab="Initialization"));

  /******************************* VARIABLES *****************************/
  Modelica.SIunits.ThermodynamicTemperature pinch_sf(displayUnit="K",min=1);
  Modelica.SIunits.ThermodynamicTemperature pinch_iso(displayUnit="K",min=1);

  Modelica.SIunits.Power Q_dot_iso;
  Modelica.SIunits.Power Q_dot_sf;

  Modelica.SIunits.ThermalConductance AU_iso;
  Modelica.SIunits.ThermalConductance AU_sf;

  Medium_iso.ThermodynamicState stateIn_iso;
  Medium_iso.ThermodynamicState stateOut_iso;
  Medium_iso.SaturationProperties satState_iso;
  Medium_sf.ThermodynamicState stateIn_sf;
  Medium_sf.ThermodynamicState stateOut_sf;

/******************************* COMPONENTS *****************************/
  ThermoCycle.Interfaces.Fluid.FlangeA inlet_iso(redeclare package Medium =
        Medium_iso)
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}}),
        iconTransformation(extent={{-120,-12},{-100,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outlet_iso(redeclare package Medium =
        Medium_iso)
    annotation (Placement(transformation(extent={{100,-12},{120,8}}),
        iconTransformation(extent={{100,-12},{120,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeA_pT inlet_sf(redeclare package Medium = Medium_sf)
    annotation (Placement(transformation(extent={{80,62},{100,82}}),
        iconTransformation(extent={{80,62},{100,82}})));
  ThermoCycle.Interfaces.Fluid.FlangeB_pT outlet_sf(redeclare package Medium = Medium_sf)
    annotation (Placement(transformation(extent={{-100,-84},{-80,-64}}),
        iconTransformation(extent={{-100,-84},{-80,-64}})));
 ThermoCycle.Components.Units.HeatExchangers.Semi_isothermal_HeatExchanger_pT
    semi_isothermal_HeatExchanger(redeclare package Medium = Medium_sf, AU=A_sf*
        U_sf)
    annotation (Placement(transformation(extent={{16,62},{-16,96}})));
  ThermoCycle.Interfaces.HeatTransfer.HeatPortConverter heatPortConverter(N=1, A=
        A_sf)
    annotation (Placement(transformation(
        extent={{-17,-11},{17,11}},
        rotation=0,
        origin={23,47})));
  ThermoCycle.Components.HeatFlow.Walls.MetalWallL metalWallL(
    Aext=A_sf,
    Aint=A_iso,
    M_wall=M_wall,
    c_wall=c_wall,
    steadystate_T_wall=steadystate_T_wall,
    Tstart_wall=T_w_start,
    Wall_int(phi(start=-(T_w_start - T_iso_start)*U_iso)))
    annotation (Placement(transformation(extent={{8,46},{68,-2}})));
  ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T_cell
    annotation (Placement(transformation(extent={{-26,-34},{24,-74}})));
  ThermoCycle.Components.HeatFlow.Walls.ThermalResistanceL thermalResistanceL(
    U=U_iso,
    A=A_iso,
    Qdot(start=(T_w_start - T_iso_start)*A_iso*U_iso))
    annotation (Placement(transformation(extent={{-14,10},{32,-28}})));
equation

  stateIn_iso = Medium_iso.setState_ph(inlet_iso.p,inStream(inlet_iso.h_outflow));
  stateIn_sf = Medium_sf.setState_pT(inlet_sf.p,inStream(inlet_sf.T_outflow));

  /* Set saturation state for the working fluid */
  satState_iso = Medium_iso.setSat_p(inlet_iso.p);
  source_T_cell.Temperature = satState_iso.Tsat;

  stateOut_iso = Medium_iso.setState_ph(outlet_iso.p,outlet_iso.h_outflow);
  stateOut_sf = Medium_sf.setState_pT(outlet_sf.p,outlet_sf.T_outflow);

  AU_iso = A_iso * U_iso;
  AU_sf = A_sf * U_sf;

  Q_dot_sf = semi_isothermal_HeatExchanger.Q_dot;
  Q_dot_iso = -thermalResistanceL.Qdot;
  pinch_sf = min(abs(semi_isothermal_HeatExchanger.T_su - metalWallL.T_wall),abs(semi_isothermal_HeatExchanger.T_ex - metalWallL.T_wall));
  pinch_iso = abs(metalWallL.T_wall - satState_iso.Tsat);

  /*BOUNDARY CONDITIONS*/
  /*Boundary Conditions Cold Fluid*/
  inlet_iso.h_outflow=inStream(outlet_iso.h_outflow);
  /* Energy balance for the working fluid */
  outlet_iso.h_outflow=stateIn_iso.h + Q_dot_iso/inlet_iso.m_flow;
  inlet_iso.m_flow = - outlet_iso.m_flow;
  inlet_iso.p = outlet_iso.p;

  connect(semi_isothermal_HeatExchanger.port_th, heatPortConverter.heatPort)
    annotation (Line(
      points={{0,63.02},{0,47},{6,47}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatPortConverter.thermalPortL, metalWallL.Wall_ext) annotation (Line(
      points={{40,47},{40,29.2},{37.4,29.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(source_T_cell.ThermalPortCell, thermalResistanceL.port1) annotation (
      Line(
      points={{1.25,-47.8},{1.25,-32},{9,-32},{9,-14.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalResistanceL.port2, metalWallL.Wall_int) annotation (Line(
      points={{9,-7.1},{9,4},{38,4},{38,14.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(semi_isothermal_HeatExchanger.supply, inlet_sf) annotation (Line(
      points={{16.32,79},{52.16,79},{52.16,72},{90,72}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(semi_isothermal_HeatExchanger.exhaust, outlet_sf) annotation (Line(
      points={{-15.68,79.34},{-54,79.34},{-54,-72},{-90,-72},{-90,-74}},
      color={0,127,0},
      smooth=Smooth.None));

initial equation
  if T_wall_fixed then
  metalWallL.T_wall=T_w_start;
  end if;

                           annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-100,42},{-100,24},{100,24},{100,40},{100,70},{80,70},{80,42},
              {80,42},{-100,42}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{100,-44},{100,-26},{-100,-26},{-100,-42},{-100,-72},{-80,-72},
              {-80,-44},{-80,-44},{100,-44}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,14},{100,-16}},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,24},{100,14}},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-16},{100,-26}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          lineThickness=0.5),
        Line(
          points={{-90,-1},{-48,-1},{-58,7},{-48,-1},{-58,-9},{-58,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-58,7},{-48,-1},{-58,-9},{-58,-7},{-58,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,38},{46,32},{54,26},{54,26},{54,38}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{46,32},{74,32},{90,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-46,38},{-54,32},{-46,26},{-46,26},{-46,38}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,32},{-26,32},{-10,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{10,-28},{2,-34},{10,-40},{10,-40},{10,-28}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{6,-34},{34,-34},{50,-34}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-90,-34},{-62,-34},{-52,-34}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-90,-34},{-90,-42},{-90,-42}},
          color={255,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{4,6},{-4,0},{4,-6},{4,-6},{4,6}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-90,-46},
          rotation=90),
        Line(
          points={{90,32},{90,48},{90,48}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-1},{20,-1},{10,7},{20,-1},{10,-9},{10,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{10,7},{20,-1},{10,-9},{10,-7},{10,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{42,-1},{84,-1},{74,7},{84,-1},{74,-9},{74,-9}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{74,7},{84,-1},{74,-9},{74,-7},{74,7}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,24},{-100,14},{-100,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-100,-16},{-100,-26},{-100,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,24},{100,14},{100,14}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,-16},{100,-26},{100,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{-100,-46},{100,-72}}, textString="%name")}),
    experiment(StopTime=30),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><big>The <b>HX_twophase_pT</b> model is a non-discretized counter-current heat exchanger model.</p>
<p><big> The main assumptions for this model are:
  <ul>
<li>The working fluid is  in two-phase state in thermodynamic equilibrium i.e. the steam and water are saturated at the evaporation pressure and temperature. </li>
<li> The secondary fluid (hot) is modeled based on the &epsilon;-NTU method for semi-isothermal heat exchangers.
<li> Static mass, energy and momentum balance are considered for both fluids
<li> No pressure drop
<li> Energy accumulation is considered in the metal wall
 <li>The wall temperature is assumed uniform throughout the heat exchanger</li>
</ul>

</html>"));
end HX_twophase_pT;
