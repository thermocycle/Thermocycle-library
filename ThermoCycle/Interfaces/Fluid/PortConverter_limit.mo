within ThermoCycle.Interfaces.Fluid;
model PortConverter_limit
  "Conversion between the standard Modelica fluid port and the limited port proposed in Cell1Dim_limit"
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  ThermoCycle.Interfaces.Fluid.FlangeA Classical(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}),
        iconTransformation(extent={{-60,-10},{-40,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeB_limit Limited(redeclare package Medium
      =                                                                         Medium)
    annotation (Placement(transformation(extent={{40,-10},{60,10}}),
        iconTransformation(extent={{40,-10},{60,10}})));
  parameter Modelica.SIunits.SpecificEnthalpy h_limit=-1E12;
equation
Classical.p = Limited.p;
Classical.m_flow = - Limited.m_flow;
Classical.h_outflow = inStream(Limited.h_outflow);
Limited.h_outflow = noEvent(max(inStream(Limited.h_limit),inStream(Classical.h_outflow)));
Limited.h_limit = h_limit;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(
          points={{-20,60},{-20,-60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1), Line(
          points={{20,60},{20,-60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1)}),
    Documentation(info="<html>
<p>Converter between the modelica.fluid port and the limited port proposed by :</p>
<p>Schulze et al., A limiter for Preventing Singularity in Simplified Finite Volume Methods</p>
<p><br/>S. Quoilin, July 2013</p>
</html>"));
end PortConverter_limit;
