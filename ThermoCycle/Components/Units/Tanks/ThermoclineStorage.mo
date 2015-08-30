within ThermoCycle.Components.Units.Tanks;
model ThermoclineStorage
  "Thermocline model - Imposed pressure, Volume variable"

  replaceable package Medium = Media.WaterTPSI_FP                   constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

/********************** PORTS **********************/
ThermoCycle.Interfaces.Fluid.FlangeA portHotSF(redeclare package Medium = Medium)
   annotation (Placement(transformation(extent={{-94,68},{-74,88}}),
        iconTransformation(extent={{-86,50},{-64,72}})));
 ThermoCycle.Interfaces.Fluid.FlangeA portColdPW(redeclare package Medium = Medium)
   annotation (Placement(transformation(extent={{68,-72},{88,-52}}),
        iconTransformation(extent={{66,-75},{88,-52}})));
 ThermoCycle.Interfaces.Fluid.FlangeB  portHotPW(redeclare package Medium = Medium)
   annotation (Placement(transformation(extent={{70,70},{90,90}}),
        iconTransformation(extent={{62,48},{86,72}})));
 ThermoCycle.Interfaces.Fluid.FlangeB portColdSF(redeclare package Medium = Medium)
   annotation (Placement(transformation(extent={{-88,-86},{-68,-66}}),
        iconTransformation(extent={{-86,-76},{-62,-52}})));

  Modelica.Blocks.Interfaces.RealInput T_env
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-88,-8},{-68,12}})));

/**********************FILLER MATERIAL **********************/
replaceable parameter FillerMaterial.MaterialBase
                                              FillerMaterial
constrainedby ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase
    "Select solid material in the tank"                                                                                          annotation (choicesAllMatching=true);

/********************** PARAMETERS **********************/
  constant Real pi= Modelica.Constants.pi;
  parameter Integer N(min=4) "Number of nodes";
  parameter Modelica.SIunits.Volume V_tank "Tank volume";
  parameter Real H_D "Height to diameter ratio of the tank";
  parameter Modelica.SIunits.Position d_met "Tank thickness";
  parameter Real epsilon_p "Filler porosity" annotation(Dialog(group="Filler Characteristics", tab="General"));
  parameter Modelica.SIunits.Volume Vlstart "Liquid volume start value";
  parameter Modelica.SIunits.Pressure p "Pressure of the fluid in the tank";

    /* Heat transfer parameters */

  parameter Modelica.SIunits.ThermalConductivity k_liq
    "Fluid thermal conductivity" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.ThermalConductivity k_wall
    "Wall thermal conductivity" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_env_bottom
    "Overall heat transfer coefficient referred to the bottom of the tank" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_env_wall
    "Overall heat transfer coefficient referred to tank wall" annotation (Dialog(group="Heat transfer", tab="General"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_env_top
    "Overall heat transfer coefficient referred to the top of the tank" annotation (Dialog(group="Heat transfer", tab="General"));

  /* Fluid Variables initial condition */
  parameter Modelica.SIunits.Pressure pstart
    "Start value of pressure of the fluid in the tank" annotation(Dialog(tab = "Initialisation"));
  parameter Modelica.SIunits.MassFlowRate m_dot_su "Nominal supply mass flow" annotation(Dialog(tab = "Initialisation"));
  parameter Modelica.SIunits.MassFlowRate m_dot_ex "Nominal exhaust mass flow" annotation(Dialog(tab = "Initialisation"));
  parameter Medium.Temperature Tstart_su = 288
    "Temperature of volume 1 - bottom volume"
                                             annotation(Dialog(tab = "Initialisation"));
  parameter Medium.Temperature Tstart_ex = 288
    "Temperature of volume N - Top volume"
                                          annotation(Dialog(tab = "Initialisation"));
  final parameter Medium.Temperature Tstart[N-1]=linspace(Tstart_su,Tstart_ex,N-1)
    "Initial temperature profile"  annotation(Dialog(tab = "Initialisation"));
  final parameter Modelica.SIunits.SpecificEnthalpy hstart[N - 1]=Medium.specificEnthalpy_pTX(pstart*ones(N-1),Tstart,fill(0,0))
    "Start value of enthalpy vector (initialized by default)";

  final parameter Modelica.SIunits.MassFlowRate m_dot_nom[N]=linspace(m_dot_su,m_dot_ex,N)
    "Mass flow rate start value";

  /********************** VARIABLES **********************/

/*FLUID STATE VARIABLES */
  Medium.ThermodynamicState fluidState[N - 1]
    "Thermodynamic state of the fluid at the nodes";
  //Modelica.SIunits.Pressure p( start= pstart) "Pressure of the fluid in the tank";
    Medium.SpecificEnthalpy htilde[N - 1](start=hstart)
    "Enthalpy at the center of the volume";

  /* HEAT TRANSFER FLUID VARIABLES */
  Medium.Density rho_liq[N - 1] "Fluid nodal density";
  Medium.SpecificHeatCapacity cp_liq[N-1];
  Medium.Temperature T[N - 1] "Volume temperature";
  Modelica.SIunits.DerDensityByEnthalpy drdh[N - 1]
    "Derivative of density by enthalpy";
  Modelica.SIunits.Volume V_liq[N - 1] "Volume of the liquid in a single cell";
  Modelica.SIunits.Mass M_liq[N - 1] "Mass of the liquid in a single cell";
  Modelica.SIunits.MassFlowRate m_dot[N](start=m_dot_nom)
    "Mass flow at the nodes";
  Real dM_dt[N - 1] "Mass deriverative";
  Real dE_dt[N - 1] "Energy deriverative";

    /* ENTHALPIES */
  Modelica.SIunits.SpecificEnthalpy h_low[N - 3]
    "enthalpy at the node below the volume";
  Modelica.SIunits.SpecificEnthalpy h_high[N - 3]
    "enthalpy at the node above the volume";
 Modelica.SIunits.SpecificEnthalpy h_top
    "incoming/outgoing enthalpy at the top volume";
 Modelica.SIunits.SpecificEnthalpy h_down
    "incoming/outgoing enthalpy at the bottom voluem";

  /*Thermocline storage variables */
  Modelica.SIunits.Volume V[N - 1] "Volume of a single cell";
  Modelica.SIunits.Mass Mtot "Total tank mass";
  Modelica.SIunits.Length H_vol[N-1]
    "Height of the middle part of the cell from the bottom";
  Modelica.SIunits.Length r_int "Internal radius";
  Modelica.SIunits.Length H[N-2]
    "Distance between the center cell of the fluid volume i and i+1";
  Modelica.SIunits.Area A_tank "Area of the tank base";
  Modelica.SIunits.Volume Vl(start=Vlstart, stateSelect=StateSelect.prefer);
 /* Solid filler variables */
  Modelica.SIunits.Volume V_sol[N - 1] "Volume of the solid in a single cell";
  Modelica.SIunits.Mass M[N - 1] "Mass of a single cell";
  Modelica.SIunits.Mass M_sol[N - 1] "Mass of the solid in a single cell";

  /* VALUES OF ENTHALPIES AND MASS FLOW AT THE 4 PORTS*/
  Modelica.SIunits.SpecificEnthalpy h_cold_PW
    "enthalpy of the cold stream from Power plant";
  Modelica.SIunits.SpecificEnthalpy h_cold_SF
    "enthalpy of the cold stream to Solar Field";
  Modelica.SIunits.SpecificEnthalpy h_hot_PW
    "enthalpy of the hot stream to the Power Plant";
  Modelica.SIunits.SpecificEnthalpy h_hot_SF
    "enthalpy of the hot stream from the Solar Field";
  Modelica.SIunits.MassFlowRate m_dot_cold_PW
    "Mass flow rate of the cold stream from the power plant";
  Modelica.SIunits.MassFlowRate m_dot_cold_SF
    "Mass flow rate of the cold stream to the solar field";
  Modelica.SIunits.MassFlowRate m_dot_hot_PW
    "Mass flow rate of the hot stream to the power plant";
  Modelica.SIunits.MassFlowRate m_dot_hot_SF
    "Mass flow rate of the hot stream from the solar field";

  /* HEAT TRANSFER COEFFICIENT VARIABLES*/
  Modelica.SIunits.ThermalConductance G_eff[N-2]
    "Effective thermal conductance and heat conduction through the tank wall";
  Modelica.SIunits.ThermalConductance G_env_wall[N-1]
    "Thermal conductance for the heat losses to the environment through the tank wall";
  Modelica.SIunits.ThermalConductance G_env_top
    "Thermal conductance for the heat losses to the environment through the tank roof";
  Modelica.SIunits.ThermalConductance G_env_bottom
    "Thermal conductance for the heat losses to the environment through the tank base";
  Modelica.SIunits.ThermalConductivity K_wall
    "Modified thermal conductivity for the conduction through the tank wall";

equation
  r_int = ((V_tank/(H_D)*4/pi)^(1/3))/2;
  A_tank = pi*r_int^2;
  K_wall = k_wall/(r_int^2)*((r_int+d_met)^2-r_int^2);

  H_vol[1] = V[1]/(A_tank)*0.5;
  for i in 2:N-1 loop
   H_vol[i] = H_vol[i-1] + V[i-1]/(A_tank)*0.5 + V[i]/(A_tank)*0.5;
  end for;

  for i in 1:N-1 loop
   V[i] = 1/(N-1)*Vl;
   V_liq[i] = epsilon_p*V[i];
   V_sol[i] = (1-epsilon_p)*V[i];
   M_liq[i] = V_liq[i]*rho_liq[i];
   M_sol[i] = V_sol[i]*FillerMaterial.rho_sol;
   M[i] = M_liq[i] + M_sol[i];
  end for;

  /* THERMAL CONDUCTANCES */

  for i in 1:N-2 loop
   H[i] = (V[i]+V[i+1])/A_tank/2;
   G_eff[i] = (epsilon_p*k_liq+(1-epsilon_p)*FillerMaterial.k_sol + K_wall)*A_tank/H[i];
   G_env_wall[i] = 2*pi*r_int*V[i]/A_tank*U_env_wall;
  end for;
  G_env_wall[N-1] = 2*pi*r_int*V[N-1]/A_tank*U_env_wall;
  G_env_top = A_tank*U_env_top;
  G_env_bottom = A_tank*U_env_bottom;

  /* MASS AND ENERGY BALANCE FOR THE VOLUMES IN THE MIDDLE*/
  for i in 2:N-2 loop
    /* Mass balance */
    dM_dt[i] = m_dot[i] - m_dot[i + 1];
    dM_dt[i] = rho_liq[i]*der(V_liq[i]) + V_liq[i]*(drdh[i]*der(htilde[i])) + FillerMaterial.rho_sol*der(V_sol[i]);
    /* Energy balance */
    dE_dt[i] = m_dot[i]*h_low[i-1] - m_dot[i+1]*h_high[i-1] + G_eff[i]*(T[i+1] - T[i]) - G_eff[i-1]*(T[i] - T[i-1]) - G_env_wall[i]*(T[i] - T_env);
    dE_dt[i] = M_liq[i]*der(htilde[i]) + htilde[i]*dM_dt[i] + M_sol[i]*FillerMaterial.cp_sol*der(htilde[i])/cp_liq[i] -p*der(V_liq[i]);
  end for;

  for i in 1:N-3 loop
    h_low[i] = if m_dot[i + 1] > 0 then htilde[i] else htilde[i + 1];
    h_high[i] = if m_dot[i + 2] > 0 then htilde[i + 1] else htilde[i + 2];
  end for;

  Mtot = sum(M);

  /* Bottom volume [1] */
  dM_dt[1] = m_dot_cold_PW + m_dot_cold_SF - m_dot[2];
  dM_dt[1] = rho_liq[1]*der(V_liq[1]) + V_liq[1]*drdh[1]*der(htilde[1]) + FillerMaterial.rho_sol*der(V_sol[1]);
  dE_dt[1] = m_dot_cold_PW * h_cold_PW + m_dot_cold_SF * h_cold_SF - m_dot[2] * h_down + G_eff[1]*(T[2]-T[1]) - G_env_wall[1]*(T[1] - T_env) - G_env_bottom*(T[1] - T_env);
  dE_dt[1] = M_liq[1] *der(htilde[1]) + M_sol[1]*FillerMaterial.cp_sol*der(htilde[1])/cp_liq[1] + htilde[1] * dM_dt[1]-p*der(V_liq[1]);
  h_down = if m_dot[2] > 0 then htilde[1] else htilde[2];

  /*Top volume [N-1] */
  dM_dt[N - 1] = m_dot[N - 1] + (m_dot_hot_SF + m_dot_hot_PW);
  dM_dt[N - 1] = rho_liq[N - 1]*der(V_liq[N - 1]) + V_liq[N - 1]*drdh[N - 1]*der(htilde[N-1]) + FillerMaterial.rho_sol*der(V_sol[N-1]);
  dE_dt[N-1] = m_dot[N-1] * h_top + (m_dot_hot_SF *h_hot_SF + m_dot_hot_PW * h_hot_PW) - G_eff[N-2]*(T[N-1] -T[N-2]) - G_env_wall[N-1]*(T[N-1] - T_env) - G_env_top*(T[N-1] - T_env);
  dE_dt[N-1] = M[N-1] *der(htilde[N-1])+ M_sol[N-1]*FillerMaterial.cp_sol*der(htilde[N-1])/cp_liq[N-1] + htilde[N-1]*dM_dt[N-1]  -p*der(V_liq[N-1]);
  h_top = if m_dot[N-1]>0 then htilde[N-2] else htilde[N-1];

  // Fluid property calculations
  for i in 1:N-1 loop
    fluidState[i] = Medium.setState_ph(p, htilde[i]);
    T[i] = Medium.temperature(fluidState[i]);
    cp_liq[i] = Medium.specificHeatCapacityCp(fluidState[i]);
    rho_liq[i] = Medium.density(fluidState[i]);
    drdh[i] = Medium.density_derh_p(fluidState[i]);
  end for;
  m_dot[1] = m_dot_cold_PW + m_dot_cold_SF;
  m_dot[N] = (m_dot_hot_PW + m_dot_hot_SF);

  /*BOUNDARY CONDITION */
  /* Enthalpies */
  portColdSF.h_outflow = htilde[1];
  portColdPW.h_outflow = htilde[1];
  portHotSF.h_outflow = htilde[N-1];
  portHotPW.h_outflow = htilde[N-1];
  h_cold_SF = portColdSF.h_outflow;
  h_cold_PW = inStream(portColdPW.h_outflow);
  h_hot_PW = portHotPW.h_outflow;
  h_hot_SF = inStream(portHotSF.h_outflow);

  /*Mass Flow Rate */
  m_dot_cold_PW = portColdPW.m_flow;
  m_dot_cold_SF = portColdSF.m_flow;
  m_dot_hot_PW = portHotPW.m_flow;
  m_dot_hot_SF =  portHotSF.m_flow;

  /* pressure */
  portColdPW.p = p;
  portColdSF.p = p;
  portHotPW.p = p;
  portHotSF.p = p;

 annotation (Diagram(coordinateSystem(extent={{-80,-100},{80,100}},
          preserveAspectRatio=false),
                     graphics), Icon(coordinateSystem(extent={{-80,-100},{80,
            100}}, preserveAspectRatio=false),
                                     graphics={
        Text(
          extent={{-72,118},{70,104}},
          lineColor={0,0,255},
          textString="%name"), Bitmap(extent={{-94,102},{96,-102}}, fileName="modelica://ThermoCycle/Resources/Images/Storage_avatar.bmp")}),Documentation(info="<html>
<p>Model <b>ThermoclineTank</b> describes a one-dimensional displacement storage-thermocline tank with an effective storage medium formed by either a liquid or both a liquid and a solid filler material.
 The sensible part of enthalpy determines the storage capacity.</p>
<p><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. </p>
<p>The assumptions for this model are: </p>
<p><ul>
<li> Discretized one-dimensional model in the axial direction </li>
<li> For each volume the storage medium (liquid or liquid plus solid filler material) is considered a single effective storage at a certain temperature T: ideal heat transfer between liquid and solid filler - Uniform radial distribution </li>
<li> Pressure is considered constant and so it is defined as a parameter</li>
<li> Thermal losses to the environment from the bottom, the top and the lateral surface area of the tank are considered</li>
<li> Constant heat capacity for the solid filler material </li>
<li> Constant thermal conductivity for the solid filler material </li>
<li> Constant thermal conductivity for the liquid fluid</li>
<li> Fluid diffusion and vertical conduction through the solid filler material and the tank metal wall is taken into account</li>
<li> Changes of fluid thermal diffusivity during turbolent mixing due to inlet/outlet streams is neglected</li>
</ul></p>
<p>The model is characterized by four flow connector. Two for the inlet and the outlet of the fluid at the top of the tank and two for the inlet and the outlet of the fluid at the bottom of the tank</p>
<p> </p>
<p><b>Modelling options</b> </p>
<p>In the <b>General</b> tab the following options are available: </p>
<p><ul>
<li>Medium: the user has the possibility to easly switch the liquid Medium. </li>
<li>Filler material:the user has the possibility to select among a list of different solid filler material</li>
</ul></p>
</html>"));
end ThermoclineStorage;
