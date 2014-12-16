within ThermoCycle.Components.FluidFlow.Sensors;
model SensMdot "Mass Flowrate sensor for working fluid"
  extends ThermoCycle.Icons.Water.SensThrough;
  replaceable package Medium = ThermoCycle.Media.DummyFluid
                                            constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealOutput Mdot annotation (Placement(
        transformation(extent={{60,40},{100,80}}, rotation=0)));
  Interfaces.Fluid.FlangeA InFlow( m_flow(min=0),redeclare package Medium = Medium)
                annotation (Placement(transformation(extent={{-50,-50},{-30,-30}}),
        iconTransformation(extent={{-50,-50},{-30,-30}})));
  Interfaces.Fluid.FlangeB OutFlow(m_flow(min=0), redeclare package Medium = Medium)
                 annotation (Placement(transformation(extent={{30,-50},{50,-30}}),
        iconTransformation(extent={{30,-50},{50,-30}})));
equation
  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  // Boundary conditions
  /* pressure */
  InFlow.p = OutFlow.p;
  /* Enthalpy */
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
  /* MassFlow */
  Mdot = InFlow.m_flow;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{-42,86},{40,26}},
          lineColor={0,0,0},
          textString="M",
          pattern=LinePattern.Dot,
          lineThickness=0.5), Line(
          points={{-4,86},{0,86},{0,88},{-4,88},{-4,86},{-2,88},{0,88}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None)}),
    Documentation(info="<HTML>
<p><big> Model <b>SensMdot</b> represents an ideal mass flow sensor.
    
</html>
"));
end SensMdot;
