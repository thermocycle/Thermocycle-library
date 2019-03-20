within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model Pump_Mdot "Pump model - Prescribed mass flow rate"
  /***************************************** FLUID *****************************************/
  replaceable package Medium = ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

  extends ThermoCycle.Icons.Water.Pump;

  /***************************************** PARAMETERS *****************************************/
  parameter Modelica.SIunits.MassFlowRate Mdot_0 = 1
    "Mass flow if external signal not connected";
  parameter Real eta_is=1 "Overall Isentropic efficiency of the pump";
  parameter Boolean NeglectDELTAh=true
    "if true, neglects the enthalpy difference due to the compression";

  /***************************************** VARIABLES *****************************************/
  Modelica.SIunits.MassFlowRate Mdot "Mass flow rate";
  Modelica.SIunits.SpecificEnthalpy h "Fluid specific enthalpy";
  Modelica.SIunits.Pressure p "Inlet pressure";
  Modelica.SIunits.Density rho(start=1000) "Liquid density";
  Modelica.SIunits.Power Wdot "Power Consumption";
  Interfaces.Fluid.FlangeA inlet( redeclare package Medium = Medium)
                            annotation (Placement(transformation(extent={{-92,-14},
            {-52,24}}),        iconTransformation(extent={{-92,-14},{-52,24}})));
  Interfaces.Fluid.FlangeB outlet( redeclare package Medium = Medium)
                             annotation (Placement(transformation(extent={
            {36,54},{76,94}}), iconTransformation(extent={{36,54},{76,94}})));
  Modelica.Blocks.Interfaces.RealInput flow_in
                                            annotation (Placement(
        transformation(extent={{-96,30},{-56,70}}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-32,80})));

equation
  Mdot = flow_in;
  if cardinality(flow_in) == 0 then
    flow_in = Mdot_0;
  end if;

  h = noEvent(if Mdot <= 0 then inStream(outlet.h_outflow) else inStream(inlet.h_outflow));
  p = noEvent(if Mdot <= 0 then outlet.p else inlet.p);
  //h = if Mdot <= 0 then inStream(outlet.h_outflow) else inStream(inlet.h_outflow);
  //p = if Mdot <= 0 then outlet.p else inlet.p;
  rho = Medium.density_phX(p,h,Medium.X_default);

  Wdot = Mdot * (outlet.p - inlet.p)/rho / eta_is;

  // Enthalpy difference due to compression and heating up in the pump is neglected:
  if NeglectDELTAh then
    outlet.h_outflow = inStream(inlet.h_outflow);
    inlet.h_outflow = inStream(outlet.h_outflow);
  else
    outlet.h_outflow = inStream(inlet.h_outflow)+(outlet.p - inlet.p)/rho / eta_is;
    inlet.h_outflow = inStream(outlet.h_outflow)+(inlet.p - outlet.p)/rho / eta_is;
  end if;
  /* Mass flow */
  inlet.m_flow = Mdot;
  outlet.m_flow = -Mdot "Flow rate is negative when leaving a component!";
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                         graphics), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),Documentation(info="<html>
          <p>The Pump model represents the compression of a fluid in a turbo or volumetric machine. It is a constant efficiency model where pump speed is set as an input.</p>
<p>The assumptions for this model are:</p>
<p><ul>
<li>No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).</li>
<li>No thermal energy losses to the environment</li>
<li>Isentropic efficiency based on empirical performance curve</li>
<li>Mass flow rate based on empirical performance curve</li>
</ul></p>
</html>"));
end Pump_Mdot;
