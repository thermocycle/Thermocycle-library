within ThermoCycle.Obsolete;
model HxRec_06122013
replaceable package MediumHot = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model";
replaceable package MediumCold = ThermoCycle.Media.R245fa_CP
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
  // Heat exchanger characteristics:
  parameter Integer N(min=1)=5 "Number of cells";
  parameter Modelica.SIunits.Area A=16.18 "Length of the tube";
  parameter Modelica.SIunits.Volume V= 0.03781
    "Heat exchanger internal volume, cold fluid side";
  Modelica.SIunits.Volume Vi=V/N;
  Modelica.SIunits.Area Ai=A/N;
  // Wall initial values:
  parameter Modelica.SIunits.Mass M_wall=69 "Wall mass";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall= 503
    "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Temperature Tstart_wall_left=344.15
    "Wall temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall_right=312.67
    "Wall temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall[N]=linspace(
        Tstart_wall_left,
        Tstart_wall_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* Same initial enthalpy values */
 parameter Modelica.SIunits.SpecificEnthalpy hstart_left=400000
    "Inlet working fluid enthalpy start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_right=250000
    "Outlet enthalpy start value" annotation (Dialog(tab="Initialization"));
  /* HOT FLUID initial values */
  parameter Modelica.SIunits.Pressure pstart_h = 1.54883e5
    "Hot fluid pressure start value" annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_h_left = 353.82
    "Hot fluid temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_h_right = 316.91
    "Hot fluid temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
 parameter Modelica.SIunits.Temperature Tstart_wf_h[N]=linspace(
        Tstart_wf_h_left,
        Tstart_wf_h_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_h[N]=linspace(
        hstart_left,
        hstart_right,
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  /* COLD FLUID initial values */
  parameter Modelica.SIunits.Pressure pstart_c = 23.57e5
    "Cold fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_c_left = 334.78
    "Cold fluid temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_c_right = 308.43
    "Cold fluid temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wf_c[N]=linspace(
        Tstart_wf_c_left,
        Tstart_wf_c_right,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy hstart_c[N]=linspace(
        hstart_left,
        hstart_right,
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate Mdotnom = 0.2588
    "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom = 100
    "Heat transfer coefficient for the hot and cold side";
//////
  /* NUMERICAL OPTIONS  */
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(group="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(group="Numerical options"));
  parameter Boolean average_Tcell=true
    "Set to yes to impose the cell enthalpy as the average of the surrounding nodes enthalpies"
    annotation (Dialog(group="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(group="Numerical options"));
  parameter Real max_drhodt=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=max_der, group="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, group="Numerical options"));
  parameter Boolean steadystate_h=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
  parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
/*VARIABLES */
   /*HOT FLUID */
  MediumHot.ThermodynamicState  fluidStateHot[N];
  MediumHot.AbsolutePressure p_h(start=pstart_h);
  Modelica.SIunits.MassFlowRate M_dot_su_h;
  MediumHot.SpecificEnthalpy h_h[N](start=hstart_h)
    "Fluid specific enthalpy at the nodes";
  MediumHot.Temperature T_h[N](start=Tstart_wf_h) "Fluid temperature";
  MediumHot.Density rho_h[N] "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh_h[N]
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp_h[N]
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode_h[N + 1] "Enthalpy state variables";
  Real dMdt_h[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot_wf_h[N] "Average heat flux";
  Modelica.SIunits.MassFlowRate Mdot_h[N + 1](each start=Mdotnom, each min=0);
  /* METAL WALL */
   Modelica.SIunits.Temperature T_wall[N](start=linspace(
          Tstart_wall_left,
          Tstart_wall_right,
          N)) "Cell temperatures";
  /* COLD FLUID */
  MediumCold.ThermodynamicState fluidStateCold[N];
  MediumCold.AbsolutePressure p_c(start=pstart_c);
  Modelica.SIunits.MassFlowRate M_dot_su_c;
  MediumCold.SpecificEnthalpy h_c[N](start=hstart_c)
    "Fluid specific enthalpy at the nodes";
  MediumCold.Temperature T_c[N](start=Tstart_wf_c) "Fluid temperature";
  MediumCold.Density rho_c[N] "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh_c[N]
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp_c[N]
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode_c[N + 1] "Enthalpy state variables";
  Real dMdt_c[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot_wf_c[N] "Average heat flux";
  Modelica.SIunits.MassFlowRate Mdot_c[N + 1](each start=Mdotnom, each min=0);
  Interfaces.Fluid.FlangeA inletHot(redeclare package Medium = MediumHot)
    annotation (Placement(transformation(extent={{-100,-58},{-80,-38}}),
        iconTransformation(extent={{-110,-44},{-90,-24}})));
  Interfaces.Fluid.FlangeB outletHot(redeclare package Medium = MediumHot)
    annotation (Placement(transformation(extent={{86,-58},{106,-38}}),
        iconTransformation(extent={{90,-44},{110,-24}})));
  Interfaces.Fluid.FlangeA inletCold( redeclare package Medium = MediumCold)
    annotation (Placement(transformation(extent={{90,48},{110,68}}),
        iconTransformation(extent={{90,48},{110,68}})));
  Interfaces.Fluid.FlangeB outletCold( redeclare package Medium = MediumCold)
    annotation (Placement(transformation(extent={{-110,48},{-90,68}}),
        iconTransformation(extent={{-110,48},{-90,68}})));
equation
  Mdot_h[1] = M_dot_su_h;
  Mdot_c[N + 1] = M_dot_su_c;
 for j in 1:N loop
    //loop for each cell
    /* Fluid Properties */
    /*HotFluid*/
    fluidStateHot[j] = MediumHot.setState_ph(p_h,h_h[j]);
    T_h[j] = MediumHot.temperature(fluidStateHot[j]);
    rho_h[j] = MediumHot.density(fluidStateHot[j]);
    /* Cold Fluid */
    fluidStateCold[j] =MediumCold.setState_ph(p_c,h_c[j]);
    T_c[j] = MediumCold.temperature(fluidStateCold[j]);
    rho_c[j] = MediumCold.density(fluidStateCold[j]);
    if max_der then
      drdp_h[j] = min(max_drhodt/10^5, MediumHot.density_derp_h(fluidStateHot[j]));
      drdh_h[j] = max(max_drhodt/(-4000), MediumHot.density_derh_p(fluidStateHot[j]));
      drdp_c[j] = min(max_drhodt/10^5, MediumCold.density_derp_h(fluidStateCold[j]));
      drdh_c[j] = max(max_drhodt/(-4000), MediumCold.density_derh_p(fluidStateCold[j]));
    else
      drdp_h[j] = MediumHot.density_derp_h(fluidStateHot[j]);
      drdh_h[j] = MediumHot.density_derh_p(fluidStateHot[j]);
      drdp_c[j] = MediumCold.density_derp_h(fluidStateCold[j]);
      drdh_c[j] = MediumCold.density_derh_p(fluidStateCold[j]);
    end if;
   /* ENERGY BALANCE */
   /*Hot fluid*/
    Vi*rho_h[j]*der(h_h[j]) + Mdot_h[j + 1]*(hnode_h[j + 1] - h_h[j]) -
      Mdot_h[j]*(hnode_h[j] - h_h[j]) - Vi*der(p_h) = Ai*qdot_wf_h[j]
      "Energy balance";
    // Equation 4.8, richter's thesis
   /*Metal wall */
    M_wall/(N)*der(T_wall[j])*c_wall = -Ai*(qdot_wf_h[j] + qdot_wf_c[j]);
    qdot_wf_h[j] = Unom*(T_wall[j] - T_h[j]);
    qdot_wf_c[j] = Unom*(T_wall[j] - T_c[j]);
   /* Cold fluid */
    Vi*rho_c[j]*der(h_c[j]) - Mdot_c[j + 1]*(hnode_c[j + 1] - h_c[j]) +
      Mdot_c[j]*(hnode_c[j] - h_c[j]) - Vi*der(p_c) = Ai*qdot_wf_c[j]
      "Energy balance";
    // Equation 4.8, richter's thesis
    /* MASS BALANCE */
    if filter_dMdt then
      der(dMdt_h[j]) = (Vi*(drdh_h[j]*der(h_h[j]) + drdp_h[j]*der(p_h)) -
        dMdt_h[j])/TT "Mass derivative for each volume";
      der(dMdt_c[j]) = (Vi*(drdh_c[j]*der(h_c[j]) + drdp_c[j]*der(p_c)) -
        dMdt_c[j])/TT "Mass derivative for each volume";
    else
      dMdt_h[j] = Vi*(drdh_h[j]*der(h_h[j]) + drdp_h[j]*der(p_h));
      dMdt_c[j] = Vi*(drdh_c[j]*der(h_c[j]) + drdp_c[j]*der(p_c));
    end if;
    // node quantities
    if Mdotconst then
      Mdot_h[j + 1] = Mdot_h[j];
      Mdot_c[j + 1] = Mdot_c[j];
    else
      dMdt_h[j] = -Mdot_h[j + 1] + Mdot_h[j];
      dMdt_c[j] = -Mdot_c[j + 1] + Mdot_c[j];
    end if;
    if average_Tcell then
      h_h[j] = (hnode_h[j] + hnode_h[j + 1])/2;
      h_c[j] = (hnode_c[j] + hnode_c[j + 1])/2;
    else
      hnode_h[j + 1] = h_h[j];
      //!! Needs to be modified in case of flow reversal
      hnode_c[j + 1] = h_c[j];
      //!! Needs to be modified in case of flow reversal
    end if;
  end for;
//* BOUNDARY CONDITIONS *//
  /*Enthalpies */
  inStream(inletCold.h_outflow) = hnode_c[N + 1];
  hnode_c[N + 1] = inletCold.h_outflow;
  outletCold.h_outflow = hnode_c[1];
  inStream(inletHot.h_outflow) = hnode_h[1];
  hnode_h[1] = inletHot.h_outflow;
  outletHot.h_outflow = hnode_h[N + 1];
  /*pressures */
  p_h = outletHot.p;
  inletHot.p = p_h;
  p_c = outletCold.p;
  inletCold.p = p_c;
  /*Mass flow */
  M_dot_su_h = inletHot.m_flow;
  M_dot_su_c = inletCold.m_flow;
  if Mdotconst then
    outletHot.m_flow = -M_dot_su_h + sum(dMdt_h);
    outletCold.m_flow = -M_dot_su_c + sum(dMdt_h);
  else
    outletHot.m_flow = -Mdot_h[N + 1];
    outletCold.m_flow = -Mdot_c[1];
  end if;
initial equation
  if steadystate_h then
    der(h_h) = zeros(N);
    der(h_c) = zeros(N);
  end if;
  if steadystate_T_wall then
    der(T_wall) = zeros(N);
  end if;
  if filter_dMdt then
    der(dMdt_h) = zeros(N);
    der(dMdt_c) = zeros(N);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-100,-44},{-80,-24},{-60,-44},{-40,-24},{-20,-44},{0,-24},
              {20,-44},{40,-24},{60,-44},{80,-24},{100,-44}},
          color={0,127,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(extent={{-100,-66},{100,-100}}, textString="%name"),
        Line(
          points={{-100,48},{-80,68},{-60,48},{-40,68},{-20,48},{0,68},{20,48},
              {40,68},{60,48},{80,68},{100,48}},
          color={0,127,0},
          smooth=Smooth.None,
          thickness=0.5),
        Rectangle(extent={{-100,48},{100,68}}, lineColor={0,0,255}),
        Rectangle(extent={{-100,-44},{100,-24}}, lineColor={255,0,0})}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end HxRec_06122013;
