within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass;
model PartialHeatTransfer_IdealFluid
// Partial heat transfer model

  parameter Integer n=1 "Number of heat transfer segments";
  // Inputs provided to heat transfer model

  //Outputs defined by the heat transfer model
  output Modelica.SIunits.HeatFlux q_dot "Heat flux";

  Interfaces.HeatTransfer.ThermalPortL thermalPortL annotation (Placement(
        transformation(extent={{-24,56},{20,76}}), iconTransformation(extent={{-24,
            56},{20,76}})));

equation
  q_dot = thermalPortL.phi;

annotation(Documentation(info="<html>
Base class for vessel heat transfer models.
</html>"),
      Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),        graphics={Ellipse(
            extent={{-60,64},{60,-56}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Sphere,
            fillColor={232,0,0}), Text(
            extent={{-38,26},{40,-14}},
            lineColor={0,0,0},
            textString="%name")}),
    Diagram(graphics));
end PartialHeatTransfer_IdealFluid;
