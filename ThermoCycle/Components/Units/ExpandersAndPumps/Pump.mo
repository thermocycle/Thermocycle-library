within ThermoCycle.Components.Units.ExpandersAndPumps;
model Pump "Pump model useful for ORCNext"
  replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  /* Define type of pump */
  import ThermoCycle.Functions.Enumerations.PumpTypes;
  import ThermoCycle.Functions.Enumerations.PumpInputs;
  parameter PumpTypes PumpType=PumpTypes.UD;
  parameter PumpInputs PumpInput=PumpInputs.freq
    "Choose between f_pp or X_pp as input";
  extends ThermoCycle.Icons.Water.Pump;
  parameter Real f_pp0=30 "Pump frequency if not connected" annotation (Dialog(enable= (PumpInputs == "Frequency")));
  parameter Real X_pp0=0.7 "Pump Flow fraction if not connected"
                                                                annotation (Dialog(enable= (PumpInputs == "Flow Fraction")));
  Real f_pp "Pump Frequency";
  Real X_pp "Pump Flow fraction";
  parameter Modelica.SIunits.SpecificEnthalpy hstart=2.22e5
    "Fluid specific enthalpy" annotation (Dialog(tab="Initialization"));
  parameter Real eta_em=1 "Electro-mechanical efficiency of the pump";
  parameter Real eta_is=1 "Internal Isentropic efficiency of the pump" annotation (Dialog(enable= (PumpType == "User Defined")));
  parameter Real epsilon_v=1 "Volumetric effectiveness of the pump" annotation (Dialog(enable= (PumpType == "User Defined")));
  parameter Modelica.SIunits.VolumeFlowRate V_dot_max=2e-4
    "Maximum pump flow rate" annotation (Dialog(enable= not (PumpType == "ORCnext")));
  parameter Modelica.SIunits.MassFlowRate M_dot_start=0.25
    "Start value for the Mass flow rate"                                                        annotation (Dialog(tab="Initialization"));
  Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start) "Mass flow rate";
  /*Fluid Variables */
  Medium.ThermodynamicState fluidState;
  Modelica.SIunits.SpecificEnthalpy h_su(start=hstart)
    "Fluid specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_ex(start=hstart)
    "Fluid specific enthalpy";
  Modelica.SIunits.Pressure p_su "Supply pressure";
  Modelica.SIunits.Pressure p_ex "Exhaust pressure";
  Modelica.SIunits.Density rho_su "Liquid density";
  Modelica.SIunits.Power W_dot "Power Consumption (single pump)";
  Real eta "Pump overall effectiveness";
  Real eta_in "Pump internal effectiveness";
  Modelica.SIunits.VolumeFlowRate V_dot "Pump flow rate";
public
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
                            annotation (Placement(transformation(extent={{-92,-14},
            {-52,24}}),        iconTransformation(extent={{-92,-14},{-52,24}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
                             annotation (Placement(transformation(extent={
            {36,54},{76,94}}), iconTransformation(extent={{36,54},{76,94}})));
  Modelica.Blocks.Interfaces.RealInput flow_in
                                            annotation (Placement(
        transformation(extent={{-100,50},{-60,90}}),iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={-42,76})));
equation
   if cardinality(flow_in) == 0 then
     if PumpInput == PumpInputs.freq then
       f_pp = f_pp0;
     else
       X_pp = X_pp0;
     end if;
    //flow_in = 0;
   else
     if PumpInput == PumpInputs.freq then
       f_pp = flow_in;
     else
       X_pp = flow_in;
     end if;
   end if;
   X_pp = f_pp/50;   // imposed to avoid calculation issues for some combinations of inputs
  /*Fluid properties*/
  fluidState = Medium.setState_ph(p_su,h_su);
  rho_su = Medium.density(fluidState);
  h_ex = h_su + (p_ex - p_su)/(eta*rho_su);
  W_dot = M_dot*(h_ex - h_su);
  eta = eta_in*eta_em;
  if (PumpType == PumpTypes.ORCNext) then
    eta_in = ThermoCycle.Functions.ORCNext.correlation_pumpORCNext(f_pp=
      f_pp, r_p=p_ex/p_su);
    M_dot = ThermoCycle.Functions.ORCNext.correlation_MdotORCNext(f_pp=f_pp);
  V_dot = 1;
  elseif (PumpType == PumpTypes.SQThesis) then
    eta_in = 0.931 - 0.108*log10(X_pp) - 0.204*log10(X_pp)^2 - 0.05954*log10(
    X_pp)^3;
    M_dot = V_dot*rho_su;
    V_dot = V_dot_max*min(X_pp, 1);
  else
    eta_in = eta_is;
    M_dot = V_dot*rho_su;
    V_dot = epsilon_v * V_dot_max;
  end if;
  /*BOUNDARY CONDITIONS */
  /* Enthalpies */
  h_su = inStream(InFlow.h_outflow);  //flangeA hBA
  OutFlow.h_outflow = h_ex;
  //Equation to close the balance. It is actually never used.
  InFlow.h_outflow = OutFlow.h_outflow;
  /* Mass flow */
  InFlow.m_flow = M_dot;
  OutFlow.m_flow = -M_dot "Flow rate is negative when leaving a component!";
  /*pressures*/
  p_su = InFlow.p;
  p_ex = OutFlow.p;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics));
end Pump;
