within ThermoCycle.Components.Units.Tanks;
model Tank
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Volume Vtot=0.002 "Volume of the tank";
  parameter Modelica.SIunits.Pressure p_gas = 0
    "Partial pressure of non-condensable gases";
  parameter Modelica.SIunits.Pressure pstart=5e5 "Initial pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart=3.82E4
    "Key parameter for the determination of the initial pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter Real level_start=0.6 "Initial level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_level=true
    "Set to yes to impose the initial tank level"
    annotation (Dialog(tab="Initialisation"));
  parameter Boolean impose_pressure=false
    "Set to yes to impose the initial tank pressure"
    annotation (Dialog(tab="Initialisation"));
  //Variables
  Medium.ThermodynamicState fluidState;
  Medium.SaturationProperties sat;
  Modelica.SIunits.Pressure p_tot "Total pressure of the system";
  Medium.Density rho "Inlet density";
  Modelica.SIunits.Volume Vl(start=Vtot*level_start)
    "Volume of the fluid in liquid phase [m3]";
  Modelica.SIunits.Volume Vv(start=Vtot*(1 - level_start))
    "Volume of the fluid in vapor phase [m3]";
  Modelica.SIunits.MassFlowRate M_dot_ex "Outlet mass flow [kg/s]";
  Modelica.SIunits.MassFlowRate M_dot_su "Inlet mass flow [kg/s]";
  Modelica.SIunits.SpecificEnthalpy h_ex "Outlet enthalpy [kJ/kg] ";
  Modelica.SIunits.SpecificEnthalpy h_su "Inlet enthalpy [kJ/kg] ";
  Modelica.SIunits.Pressure p(start=pstart);
  Modelica.SIunits.Mass M(start=Vtot*level_start*1000)
    "Total mass of the fluid stored [kg]";
  Modelica.SIunits.Density rhol "Density of the fluid in liquid phase [kg/m3]";
  Modelica.SIunits.Density rhov "Density of the fluid in vapor phase [kg/m3]";
  Modelica.SIunits.SpecificEnthalpy hl
    "Enthalpy of the fluid in liquid phase [kJ/kg]";
  Modelica.SIunits.SpecificEnthalpy hv
    "Enthalpy of the fluid in vapor phase [kJ/kg]";
  Modelica.SIunits.SpecificEnthalpy h(start=hstart);
  Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of average density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp
    "Derivative of average density by pressure";
  Modelica.Blocks.Interfaces.RealOutput level annotation (Placement(
        transformation(extent={{90,36},{128,74}}), iconTransformation(extent=
            {{72,26},{92,46}})));
  Interfaces.Fluid.FlangeA InFlow(  redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
equation
  p_tot = p + p_gas;
  Vtot = Vl + Vv;
  M = Vl*rhol + Vv*rhov;
  level = Vl/Vtot;
  h_ex = hl;
  sat = Medium.setSat_p(p);
  hv = Medium.dewEnthalpy(sat);
  hl = Medium.bubbleEnthalpy(sat);
  //hv = refrigerant.sat.hv;  // calculated as a function of pressure and vapour quality
  //hl = refrigerant.sat.hl;
  rhol=Medium.bubbleDensity(sat);
  rhov=Medium.dewDensity(sat);
  //rhov = refrigerant.sat.dv;
  //rhol = refrigerant.sat.dl;
  fluidState = Medium.setState_ph(p,h);
  rho = Medium.density(fluidState);
  rho = M/Vtot;
  //refrigerant.p = p;   // saturation pressure
  //refrigerant.d = M/Vtot;
  //refrigerant.h = h;        // calculated as a function of enthalpy and pressure (starting values requested!!)
  drdp = Medium.density_derp_h(fluidState);
  drdh = Medium.density_derh_p(fluidState);
//   drdp = refrigerant.drhodp;
//   drdh = refrigerant.drhodh;
  Vtot*rho*der(h) = semiLinear(
      M_dot_su,
      h_su - h,
      hv - h) - M_dot_ex*(h_ex - h) + Vtot*der(p_tot) "Energy balance";
  M_dot_su - M_dot_ex = Vtot*(drdh*der(h) + drdp*der(p_tot))
    "Mass derivative for each volume";
 /* BOUNDARY CONDITION */
  /* Enthalpies */
  h_su=  actualStream(InFlow.h_outflow);
  InFlow.h_outflow = hv;
  OutFlow.h_outflow = h_ex;
  /*Mass Flow Rate */
  M_dot_su = InFlow.m_flow;
  -M_dot_ex = OutFlow.m_flow;
  /*pressure */
  InFlow.p = p_tot;
  OutFlow.p = p_tot;
initial equation
  if impose_level then
    level = level_start;
  end if;
  if impose_pressure then
    p_tot = pstart;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-76,-16},{72,-88}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255}),
        Rectangle(
          extent={{-76,76},{72,-88}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-42,-24},{40,-24},{32,-24}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-24,-32},{24,-32},{16,-32}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-14,-40},{12,-40},{4,-40}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-4,-48},{4,-48},{-4,-48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(extent={{-100,52},{100,18}}, textString="%name")}));
end Tank;
