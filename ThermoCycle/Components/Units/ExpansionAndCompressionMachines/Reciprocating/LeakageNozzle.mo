within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model LeakageNozzle
  "Model of a nozzle operating in subsonic or supersonic conditions."
replaceable package Medium = ThermoCycle.Media.DummyFluid;

Medium.ThermodynamicState outlet;
Medium.ThermodynamicState inlet;
Medium.ThermodynamicState throat;
Medium.ThermodynamicState throat_choked;
parameter Modelica.SIunits.Area A_leak = 5e-7 "Throat area";
parameter Boolean Use_gamma=false
    "Use a fictitious gamma (perfect gas model) to compute the critical pressure";

parameter Medium.AbsolutePressure P_su_start = 17E5
    "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
parameter Medium.Temperature T_su_start = 273.15+150
    "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
parameter Medium.AbsolutePressure P_ex_start = 2E5
    "Start value for the inlet pressure"                                                annotation(Dialog(tab="Initialization"));
parameter Real gamma_start = 1.05
    "Start value of the fictitious expansion factor, used to compute the start value of the critical pressure"
                                                                                                        annotation(Dialog(tab="Initialization"));
parameter Medium.AbsolutePressure P_thr_crit_start = P_su_start*(2/(gamma_start+1))^(gamma_start/(gamma_start-1))
    "Critical throat pressure start value"                                                           annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Velocity C_thr_start = Medium.velocityOfSound(Medium.setState_pT(P_thr_crit_start,T_su_start))
    "Throat velocity start value"   annotation (Dialog(tab="Initialization"));
//Medium.AbsolutePressure P_thr_crit(start = P_thr_crit_start);
Medium.AbsolutePressure p_thr(start=max(P_ex_start,P_thr_crit_start),stateSelect = StateSelect.prefer);
Medium.AbsolutePressure p_su(start=P_su_start);
Medium.AbsolutePressure p_ex(start=P_ex_start);
Medium.AbsolutePressure p_choked(start = P_thr_crit_start);
Medium.Density rho_choked;
Modelica.SIunits.VolumeFlowRate V_dot_leak;
Modelica.SIunits.Velocity C_choked(start = C_thr_start);
Modelica.SIunits.Velocity C_thr(start = C_thr_start);
Real gamma;

  Modelica.Fluid.Interfaces.FluidPort_a su(
                                          redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b ex(
                                          redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
// Inlet conditions
inlet = Medium.setState_ph(su.p,inStream(su.h_outflow));
p_su = su.p;

V_dot_leak = A_leak*C_thr;
// Première partie de la tuyère : isentropique
// Etat au col de la tuyère
throat = Medium.setState_ps(p_thr, inlet.s);
// Conservation de l'énergie
inlet.h = throat.h + 0.5*C_thr^2;

su.m_flow = V_dot_leak*throat.d;

// Selecting between subsonic and choked flows:
p_thr = noEvent(max(p_choked,p_ex));

// Outlet conditions:
outlet = Medium.setState_ph(p_ex,inlet.h);
p_ex = ex.p;

// Mass flows
su.m_flow + ex.m_flow = 0;

// The valve is isenthalpic in both directions:
su.h_outflow = 1E5;//inStream(ex.h_outflow);
ex.h_outflow = inStream(su.h_outflow);

if Use_gamma then
//Identification of a fictitious gamma value that allows modeling the isentropic expansion as a perfect gas using the equation:
//     inlet.p/inlet.d^gamma = throat.p/throat.d^gamma;
//gamma = homotopy(log(inlet.p/throat.p)/log(inlet.d/throat.d), gamma_start);
gamma = log(inlet.p/throat.p)/log(inlet.d/throat.d);
//Calculation of the critical pressure using the fictitious gamma value:
p_choked = inlet.p*(2/(gamma+1))^(gamma/(gamma-1));
//setting the unused variables to dummy values
throat_choked = Medium.setState_dT(20,273.15+100);
rho_choked = 0;
C_choked = 0;
else
rho_choked = su.m_flow/(A_leak * C_choked);
throat_choked = Medium.setState_ps(p_choked,inlet.s);
throat_choked.a = C_choked;
rho_choked = throat_choked.d;
gamma = 1;
end if;

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
