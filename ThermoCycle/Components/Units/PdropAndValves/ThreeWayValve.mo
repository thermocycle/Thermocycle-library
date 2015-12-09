within ThermoCycle.Components.Units.PdropAndValves;
model ThreeWayValve
  "Three-way valve assuming a linear relationship with the pressure drop and on/off signal"
  extends ThermoCycle.Icons.Water.Valve;
   Modelica.Blocks.Interfaces.BooleanInput cmd annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270)));
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  Real K "Valve throat area";
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1
    "Nominal mass flow rate (one way or the other)"
                             annotation (Dialog(tab="Nominal Conditions"));
  parameter Modelica.SIunits.Pressure   DELTAp_nom=0.01 "Nominal pressure drop"
                             annotation (Dialog(tab="Nominal Conditions"));
  parameter Boolean damp_signal=true
    "If true, the on/off signal is damped with a first order filter";
  parameter Modelica.SIunits.Time tau = 5 "Time constant of the damping" annotation(Dialog(enable=damp_signal));
  Modelica.SIunits.MassFlowRate Mdot(start=Mdot_nom);
  Real X(min=0,max=1);

  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-84},{10,-64}}),
        iconTransformation(extent={{-10,-84},{10,-64}})));
  ThermoCycle.Interfaces.Fluid.FlangeB out_on(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB out_off(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=tau, y_start=0)
    annotation (Placement(transformation(extent={{-8,-6},{12,14}})));
equation
  InFlow.m_flow + out_on.m_flow + out_off.m_flow = 0 "Mass balance";

  if cardinality(cmd) == 0 then
    cmd = false;
  end if;

  K = Mdot_nom/DELTAp_nom;

  out_on.m_flow = - max(0,X * K * (InFlow.p - out_on.p));
  out_off.m_flow = - max(0,(1-X) * K * (InFlow.p - out_off.p));

  firstOrder.u = if cmd then 1 else 0;

  if damp_signal then
    X = firstOrder.y;
  else
    X = if cmd then 1 else 0;
  end if;

  Mdot = InFlow.m_flow;

    //if Mdot>0, the reverse flow can be imposed, which simplifies the DAE system:
  InFlow.h_outflow = 6E6;

  out_on.h_outflow = inStream(InFlow.h_outflow);
  out_off.h_outflow = inStream(InFlow.h_outflow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Polygon(
          points={{-40,40},{-40,-40},{28,4.2838e-015},{-40,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={0,-28},
          rotation=90),
        Line(
          points={{0,-54},{0,-20},{-10,-34},{0,-20},{8,-32}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{34,16},{72,-18}},
          lineColor={0,0,255},
          textString="ON"),
        Text(
          extent={{-74,18},{-36,-16}},
          lineColor={0,0,255},
          textString="Off")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML>
<p><big> The <b>Valve</b> model represents the expansion of a fluid through a valve.
 <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> The expansion is assumed isenthalpic
         <li> Incompressible flow for computing the pressure drop
         </ul>
</HTML>",
        uses(Modelica(version="3.2"))));
end ThreeWayValve;
