within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClass;
partial model PartialHeatTransfer
  "Basic component for partial heat transfer model"
replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation(Dialog(tab="Internal Interface",enable=false));
  parameter Integer n=1 "Number of heat transfer segments";
  // Inputs provided to heat transfer model
  input Medium.ThermodynamicState[n] FluidState
    "Thermodynamic states of flow segments";

  //Outputs defined by the heat transfer model
  output Modelica.SIunits.HeatFlux[n] q_dot "Heat flux";

    //Variables

    Modelica.SIunits.Temperature[n] T_fluid = Medium.temperature(FluidState)
    "Temperature of the fluid for the heat transfer process";

  Interfaces.HeatTransfer.ThermalPortL[n] thermalPortL annotation (Placement(
        transformation(extent={{-24,56},{20,76}}), iconTransformation(extent={{-24,
            56},{20,76}})));

equation
  q_dot = thermalPortL.phi;

annotation(Documentation(info="<html>
<p><big> The Partial model <b>PartialHeatTransfer</b> is the basic model for heat transfer of a real fluid in the library. It calculates the
heat flux, q_dot[n], exchanged through the thermal port, ThermalPortL[n], for each segment n, based on the thermodynamic state of the fluid flow ,FluidState[n],  
and the temperatures at the boundary, T_fluid and thermalPortL.T.</p>
<p><big> In order to complete the model - from <FONT COLOR=blue>partial model</FONT>  to <FONT COLOR=blue> model</FONT> -
 one equation relating the exchanged heat flux, q_dot, with the fluid temperature, T_fluid,
and the temperature at the boundary thermalPortL.T has to be privided.  
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
end PartialHeatTransfer;
