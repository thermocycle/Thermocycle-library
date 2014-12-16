within ;
package ThermoComponents
  model LeakageNozzle
    "Model of a nozzle operating in subsonic or supersonic conditions."
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialMedium
  annotation(choicesAllMatching=true);

  // Four states are needed to calculate the nozzle
  Medium.ThermodynamicState inlet;
  Medium.ThermodynamicState throat;
  Medium.ThermodynamicState choked;
  Medium.ThermodynamicState outlet;

  parameter Modelica.SIunits.Area A_nozzle = 5e-7 "Equivalent throat area";

  parameter Boolean Use_gamma=false
      "Use a fictitious gamma (perfect gas model) to compute the critical pressure";

  parameter Medium.AbsolutePressure Delta_p_smooth = 1e4
      "Smoothing range for sonic flow conditions";

  parameter Medium.AbsolutePressure p_inlet_start = 17E5
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.Temperature T_inlet_start = 273.15+150
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_outlet_start = 2E5
      "Start value for the inlet pressure"                                                annotation(Dialog(tab="Initialization"));
  parameter Real gamma_start = 1.05
      "Start value of the fictitious expansion factor, used to compute the start value of the critical pressure"
                                                                                                          annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_throat_crit_start = p_inlet_start*(2/(gamma_start+1))^(gamma_start/(gamma_start-1))
      "Critical throat pressure start value"                                                           annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Velocity c_throat_start = Medium.velocityOfSound(Medium.setState_pT(p_throat_crit_start,T_inlet_start))
      "Throat velocity start value"   annotation (Dialog(tab="Initialization"));
  //Medium.AbsolutePressure p_thr_crit(start = p_thr_crit_start);
  Medium.AbsolutePressure p_throat(start=max(p_outlet_start,p_throat_crit_start),stateSelect = StateSelect.prefer);
  Medium.AbsolutePressure p_inlet(start=p_inlet_start);
  Medium.AbsolutePressure p_outlet(start=p_outlet_start);
  Medium.AbsolutePressure Delta_p_full;
  Medium.AbsolutePressure Delta_p_crit;
  Medium.SpecificEnthalpy h_inlet;
  Medium.SpecificEntropy  s_inlet;
  Medium.SpecificEnthalpy h_outlet;
  Medium.AbsolutePressure p_choked(start = p_throat_crit_start);
  Medium.Density rho_choked;
  Modelica.SIunits.VolumeFlowRate V_dot_nozzle;
  Modelica.SIunits.MassFlowRate m_dot_inlet;
  Modelica.SIunits.MassFlowRate m_dot_outlet;
  Modelica.SIunits.MassFlowRate m_dot_throat;
  Modelica.SIunits.Velocity c_choked(start = c_throat_start);
  Modelica.SIunits.Velocity c_throat(start = c_throat_start);
  Real gamma, tFactor;

    Modelica.Fluid.Interfaces.FluidPort_a upstream(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b downstream(redeclare package Medium
        = Medium)
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  equation
  // No mass storage in nozzle
  m_dot_inlet  = upstream.m_flow;
  m_dot_outlet = downstream.m_flow;
  m_dot_inlet + m_dot_outlet = 0;

  p_inlet  = upstream.p;
  h_inlet  = inStream(upstream.h_outflow);
  p_outlet = downstream.p;
  h_outlet = inStream(downstream.h_outflow);

  s_inlet = Medium.specificEntropy(inlet);

  upstream.h_outflow   = inStream(downstream.h_outflow);
  downstream.h_outflow = inStream(upstream.h_outflow);

  // Define different states
  inlet  = Medium.setState_ph(p_inlet,  h_inlet);
  throat = Medium.setState_ps(p_throat, s_inlet) "Isentropic flow";
  choked = Medium.setState_ps(p_choked, s_inlet) "Isentropic flow";
  outlet = Medium.setState_ph(p_outlet, h_inlet) "Isenthalpic flow";

  // Connecting inlet and throat, energy balance
  Medium.specificEnthalpy(inlet) = Medium.specificEnthalpy(throat) + 0.5*c_throat^2;
  m_dot_throat = m_dot_inlet;
  m_dot_throat = V_dot_nozzle * Medium.density(throat);
  V_dot_nozzle = A_nozzle * c_throat;

  // Smoothing our way towards critical conditions
  Delta_p_full = p_inlet - p_outlet;
  Delta_p_crit = p_inlet - p_choked;

  tFactor  = ThermoCycle.Functions.transition_factor(start=Delta_p_crit-Delta_p_smooth,stop=Delta_p_crit,position=Delta_p_full);
  p_throat = p_outlet;  //tFactor*p_choked + (1 - tFactor)*p_outlet;

  //h_inlet = Medium.specificEnthalpy(choked) + 0.5*c_choked^2;

  rho_choked = m_dot_throat / (A_nozzle * c_choked);
  c_choked   = Medium.velocityOfSound(choked);
  rho_choked = Medium.density(choked);
  gamma = 1;

  // if Use_gamma then
  //Identification of a fictitious gamma value that allows modeling the isentropic expansion as a perfect gas using the equation:
  //     inlet.p/inlet.d^gamma = throat.p/throat.d^gamma;
  //gamma = homotopy(log(inlet.p/throat.p)/log(inlet.d/throat.d), gamma_start);
  // gamma = log(inlet.p/throat.p)/log(inlet.d/throat.d);
  //Calculation of the critical pressure using the fictitious gamma value:
  // p_choked = inlet.p*(2/(gamma+1))^(gamma/(gamma-1));
  //setting the unused variables to dummy values
  // throat_choked = Medium.setState_dT(20,273.15+100);
  // rho_choked = 0;
  // C_choked = 0;
  // else
  // rho_choked = upstream.m_flow/(A_leak * C_choked);
  // throat_choked = Medium.setState_ps(p_choked,inlet.s);
  // throat_choked.a = C_choked;
  // rho_choked = throat_choked.d;
  // gamma = 1;
  // end if;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Line(
            points={{-100,30},{-48,30},{0,8},{70,6},{92,6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-90,0},{-24,0},{32,0},{70,0},{90,0}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,48},{-36,48},{22,14},{78,10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5),
          Line(
            points={{-100,-30},{-48,-30},{0,-8},{70,-6},{92,-6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,-48},{-36,-48},{22,-14},{78,-10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5),
          Ellipse(extent={{74,10},{80,-10}}, lineColor={0,0,0}),
          Ellipse(extent={{-85,48},{-75,-48}}, lineColor={0,0,0})}));
  end LeakageNozzle;

  model Nozzle "An isentropic nozzle accounting for choked flow."
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
      Modelica.Media.Interfaces.PartialMedium
  annotation(choicesAllMatching=true);

  // Four states are needed to calculate the nozzle
  Medium.ThermodynamicState inlet;
  Medium.ThermodynamicState throat;
  Medium.ThermodynamicState choked;
  Medium.ThermodynamicState outlet;

  parameter Modelica.SIunits.Area A_nozzle = 5e-7 "Equivalent throat area";

  parameter Boolean Use_gamma=false
      "Use a fictitious gamma (perfect gas model) to compute the critical pressure";

  parameter Medium.AbsolutePressure Delta_p_smooth = 1e4
      "Smoothing range for sonic flow conditions";

  parameter Medium.AbsolutePressure p_inlet_start = 17E5
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.Temperature T_inlet_start = 273.15+150
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_outlet_start = 2E5
      "Start value for the inlet pressure"                                                annotation(Dialog(tab="Initialization"));
  parameter Real gamma_start = 1.05
      "Start value of the fictitious expansion factor, used to compute the start value of the critical pressure"
                                                                                                          annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_throat_crit_start = p_inlet_start*(2/(gamma_start+1))^(gamma_start/(gamma_start-1))
      "Critical throat pressure start value"                                                           annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Velocity c_throat_start = Medium.velocityOfSound(Medium.setState_pT(p_throat_crit_start,T_inlet_start))
      "Throat velocity start value"   annotation (Dialog(tab="Initialization"));
  //Medium.AbsolutePressure p_thr_crit(start = p_thr_crit_start);
  Medium.AbsolutePressure p_throat(start=max(p_outlet_start,p_throat_crit_start),stateSelect = StateSelect.prefer);
  Medium.AbsolutePressure p_inlet(start=p_inlet_start);
  Medium.AbsolutePressure p_outlet(start=p_outlet_start);
  Medium.AbsolutePressure Delta_p_full;
  Medium.AbsolutePressure Delta_p_crit;
  Medium.SpecificEnthalpy h_inlet;
  Medium.SpecificEntropy  s_inlet;
  Medium.SpecificEnthalpy h_choked(start=Medium.specificEnthalpy(Medium.setState_pT(p_throat_crit_start,T_inlet_start)));
  Medium.SpecificEntropy  s_choked;
  Medium.AbsolutePressure p_choked(start=p_throat_crit_start);
  Medium.Density rho_choked;
  Medium.SpecificEnthalpy h_throat(start=Medium.specificEnthalpy(Medium.setState_pT(p_throat_crit_start,T_inlet_start)));
  Medium.SpecificEntropy  s_throat;
  Medium.Density rho_throat;
  Modelica.SIunits.MassFlowRate m_dot_inlet;
  Modelica.SIunits.Velocity c_choked(start = c_throat_start);
  Modelica.SIunits.Velocity c_throat(start = c_throat_start);
  Real gamma, tFactor;

    Modelica.Fluid.Interfaces.FluidPort_a upstream(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));
    Modelica.Fluid.Interfaces.FluidPort_b downstream(redeclare package Medium
        = Medium)
      annotation (Placement(transformation(extent={{90,-10},{110,10}}),
          iconTransformation(extent={{90,-10},{110,10}})));

  equation
    // No mass storage in nozzle, no energy loss
    upstream.m_flow + downstream.m_flow = 0;

    upstream.h_outflow   = inStream(downstream.h_outflow);
    downstream.h_outflow = inStream(upstream.h_outflow);

    upstream.Xi_outflow   = inStream(downstream.Xi_outflow);
    downstream.Xi_outflow = inStream(upstream.Xi_outflow);

    upstream.C_outflow   = inStream(downstream.C_outflow);
    downstream.C_outflow = inStream(upstream.C_outflow);

  if noEvent(upstream.p>=downstream.p) then
    inlet       = Medium.setState_phX(upstream.p, inStream(upstream.h_outflow), inStream(upstream.Xi_outflow));
    m_dot_inlet = upstream.m_flow;
    outlet      = Medium.setState_phX(downstream.p, inStream(downstream.h_outflow), inStream(downstream.Xi_outflow));
  else // flow reversal
    inlet       = Medium.setState_phX(downstream.p, inStream(downstream.h_outflow), inStream(downstream.Xi_outflow));
    m_dot_inlet = downstream.m_flow;
    outlet      = Medium.setState_phX(upstream.p, inStream(upstream.h_outflow), inStream(upstream.Xi_outflow));
  end if;

  p_inlet  = Medium.pressure(inlet);
  s_inlet  = Medium.specificEntropy(inlet);
  h_inlet  = Medium.specificEnthalpy(inlet);

  // get critical conditions for isentropic flow
  if p_choked<p_outlet then
    choked      = Medium.setState_phX(p_outlet, h_choked);
  else
    choked      = Medium.setState_phX(p_choked, h_choked);
  end if;

  s_choked    = s_inlet;
  s_choked    = Medium.specificEntropy(choked);
  c_choked    = Medium.velocityOfSound(choked);
  rho_choked  = Medium.density(choked);
  m_dot_inlet = rho_choked * A_nozzle * c_choked;

  // define throat state, isenthalpic flow
  throat      = Medium.setState_phX(p_throat, h_throat) "Isentropic flow";
  s_throat    = s_inlet;
  s_throat    = Medium.specificEntropy(throat);
  h_throat    = h_inlet - 0.5*c_throat^2;
  rho_throat  = Medium.density(throat);
  m_dot_inlet = rho_throat * A_nozzle * c_throat;

  // the last one is the outlet state
  p_outlet = Medium.pressure(outlet);

  // Smoothing our way towards critical conditions
  Delta_p_full = p_inlet - p_outlet;
  Delta_p_crit = p_inlet - p_choked;

  tFactor  = ThermoCycle.Functions.transition_factor(start=Delta_p_crit-Delta_p_smooth,stop=Delta_p_crit,position=Delta_p_full);
  p_throat = p_outlet; //tFactor*p_choked + (1 - tFactor)*p_outlet;

  // dummy value
  gamma = 1;

  // if Use_gamma then
  //Identification of a fictitious gamma value that allows modeling the isentropic expansion as a perfect gas using the equation:
  //     inlet.p/inlet.d^gamma = throat.p/throat.d^gamma;
  //gamma = homotopy(log(inlet.p/throat.p)/log(inlet.d/throat.d), gamma_start);
  // gamma = log(inlet.p/throat.p)/log(inlet.d/throat.d);
  //Calculation of the critical pressure using the fictitious gamma value:
  // p_choked = inlet.p*(2/(gamma+1))^(gamma/(gamma-1));
  //setting the unused variables to dummy values
  // throat_choked = Medium.setState_dT(20,273.15+100);
  // rho_choked = 0;
  // C_choked = 0;
  // else
  // rho_choked = upstream.m_flow/(A_leak * C_choked);
  // throat_choked = Medium.setState_ps(p_choked,inlet.s);
  // throat_choked.a = C_choked;
  // rho_choked = throat_choked.d;
  // gamma = 1;
  // end if;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Line(
            points={{-80,30},{-48,30},{0,8},{70,6},{78,6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,0},{-24,0},{32,0},{70,0},{78,0}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,48},{-36,48},{22,14},{78,10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5),
          Line(
            points={{-80,-30},{-48,-30},{0,-8},{70,-6},{78,-6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,-48},{-36,-48},{22,-14},{78,-10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5),
          Ellipse(extent={{75,10},{81,-10}}, lineColor={0,0,0}),
          Ellipse(extent={{-85,48},{-75,-48}}, lineColor={0,0,0})}));
  end Nozzle;
  annotation (uses(Modelica(version="3.2")));
end ThermoComponents;
