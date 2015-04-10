within ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses;
partial model PartialPlateHeatExchangerCorrelation
  "Base class for heat transfer correlations for plate heat exchangers"
      extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferCorrelation;

  parameter Modelica.SIunits.Length a_hat(min=0,displayUnit="mm",nominal=0.002) = 0.002
    "Corrugation amplitude"
  annotation (Dialog(group="Geometry"));

  parameter Modelica.SIunits.Angle phi(min=0,displayUnit="deg",nominal=1) = Modelica.SIunits.Conversions.from_deg(45)
    "Corrugation angle"
  annotation (Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length Lambda(min=0,displayUnit="mm",nominal=0.01) = 0.0126
    "Corrugation wavelength"
  annotation (Dialog(group="Geometry"));
  parameter Modelica.SIunits.Length B_p(min=0,displayUnit="cm",nominal=0.10) = 0.1
    "Plate flow width"
  annotation (Dialog(group="Geometry"));

  // ... and the more specific ones
  parameter Real X =   2 * Modelica.Constants.pi*a_hat/Lambda "Wave number"
  annotation (Dialog(group="Advanced geometry"));
  parameter Real Phi = 1/6 * ( 1 + sqrt(1+X^2) + 4 * sqrt(1+X^2/2))
    "Enhancement factor"
  annotation (Dialog(group="Advanced geometry"));
  replaceable parameter Modelica.SIunits.Length d_h = 4 * a_hat / Phi
    "Characteristic length"
  annotation (Dialog(group="Advanced geometry"));
  replaceable parameter Modelica.SIunits.Area A_cro = 2 * a_hat * B_p
    "Cross-sectional area"
  annotation (Dialog(group="Advanced geometry"));

  Modelica.SIunits.CoefficientOfHeatTransfer alpha "The calculated HTC";

equation
  // Enhanced HTC,we can use the projected area for HX calculations
  U      = Phi * alpha;
annotation(Documentation(info="<html>
<p><b><font style=\"font-size: 11pt; color: #008000; \">Plate heat exchanger correlations</font></b></p>
<p>The model <b>PartialPlateHeatExchangerCorrelation </b>is the basic model for the calculation of heat transfer coefficients for plate heat exchangers. It provides some basic geometric definitions. It returns an enhanced HTC U based on geometry and alpha. Thus U can be used with the projected squared area of the device, which is also the way the discretised models work at the moment. </p>
<p>The geometry of the plate heat exchanger plates is defined by the parameters of this partial model. The most important ones can be found in the Geometry section of the parameter window: </p>
<ul>
<li>a_hat - Corrugation amplitude</li>
<li>phi - Corrugation angle (phi_co on drawing)</li>
<li>Lambda - Corrugation wavelength (l_co on drawing)</li>
<li>B_p - Plate flow width (d_hx on drawing)</li>
</ul>
<p>The more specific ones are defined by equations, which can be altered in the parameter window: </p>
<ul>
<li>X - Wave number</li>
<li>Phi - Enhancement factor</li>
<li>d_h - Characteristic length</li>
<li>A_cro - Cross-sectional area </li>
</ul>
<p>The default definitions are taken from Martin2010, but other correlations might use these parameters differently. Hence the possibility to modifiy the equations. </p>
<p><img src=\"modelica://ThermoCycle/Resources/Images/PlateHX.png\"/></p>
</html>"));
end PartialPlateHeatExchangerCorrelation;
