within ThermoCycle.Interfaces.Fluid;
model InitJunction
  "Imposes constant values upstream (p) and/or downstream (Mdot and h) at the beginning of the simulation to reduce initialization issues"

replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

  ThermoCycle.Interfaces.Fluid.FlangeA inlet(redeclare package Medium =Medium)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outlet(redeclare package Medium =Medium)
   annotation (Placement(transformation(extent={{28,-10},{48,10}})));

  parameter Boolean const_downstream=false
    "Set to true to impose the boundary conditions during initialization (thus discarding the real ones)"
                                                                                                        annotation (Dialog(tab="Downstream"));
  parameter Boolean Use_pT=true
    "Use p and T to defined the initial inlet enthalpy"  annotation (Dialog(enable=const_downstream,tab="Downstream"));
  parameter Modelica.SIunits.MassFlowRate Mdot_ex_init = 0.2
    "Initial inlet mass flow"  annotation (Dialog(enable=const_downstream,tab="Downstream"));
  parameter Modelica.SIunits.SpecificEnthalpy h_ex_init=2E5
    "Initial inlet enthalpy"                                                         annotation (Dialog(enable=const_downstream and not Use_pT,tab="Downstream"));
  parameter Modelica.SIunits.Temperature T_ex_init=273.15+25
    "Initial inlet temperature"                                                        annotation (Dialog(enable= const_downstream and Use_pT,tab="Downstream"));
  parameter Modelica.SIunits.Pressure p_ex_init = 1E5
    "Initial inlet pressure (used to calculate the downstream enthalpy"                                                    annotation (Dialog(enable=const_downstream and Use_pT,tab="Downstream"));

  parameter Boolean const_upstream=false
    "Set to true to impose the boundary conditions during initialization (thus discarding the real ones)"
                                                                                                        annotation (Dialog(tab="Upstream"));
  parameter Modelica.SIunits.Pressure p_su_init = 1E5 "Initial inlet pressure"  annotation (Dialog(enable=const_upstream,tab="Upstream"));

  parameter Boolean noevent=false
    "Avoids generating events during the transition";

  parameter Modelica.SIunits.Time tinit=10
    "Start time of the transition to the real boundary";
  parameter Modelica.SIunits.Time duration=5 "Duration of the transition";

  ThermoCycle.Functions.Init                              init_h(t_init=tinit,
      length=duration,noevent=noevent);
  ThermoCycle.Functions.Init                              init_mdot(t_init=tinit,
      length=duration,noevent=noevent);
  ThermoCycle.Functions.Init                              init_p(t_init=tinit,
      length=duration,noevent=noevent);

equation
   init_h.u1 = if Use_pT then Medium.specificEnthalpy_pTX(p_ex_init,T_ex_init,fill(0,0)) else h_ex_init;
   init_h.u2 = inStream(inlet.h_outflow);
   init_mdot.u1 = Mdot_ex_init;
   init_mdot.u2 = inlet.m_flow;
   init_p.u1 = p_su_init;
   init_p.u2 = outlet.p;

    // Common value (we assume that there is no reverse flow at initialization):"
   inlet.h_outflow = 4E5; // inStream(outlet.h_outflow);

   if const_downstream then
     outlet.h_outflow = init_h.y;
     outlet.m_flow = - init_mdot.y;
   else
     outlet.h_outflow = inStream(inlet.h_outflow);
     outlet.m_flow = - inlet.m_flow;
   end if;

   if const_upstream then
    inlet.p = init_p.y;
   else
    inlet.p = outlet.p;
   end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-32,-8},{28,8}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{-16,0},{10,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{10,0},{4,4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{10,0},{4,-4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}),
    Icon(graphics={
        Ellipse(
          extent={{-32,-8},{28,8}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{-16,0},{10,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{10,0},{4,4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{10,0},{4,-4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None)}));
end InitJunction;
