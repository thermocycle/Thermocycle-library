within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.SinglePhaseCorrelations;
model Constant "Constant: Constant heat transfer coefficient"
  extends BaseClasses.PartialSinglePhaseCorrelation;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_c = 1000
    "Heat transfer coefficient";
equation
  U = U_c;

annotation(Documentation(info="<html>

<p><big> The model <b>Constant</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialSinglePhaseCorrelation\">PartialSinglePhaseCorrelation</a> 
 and defines a constant heat transfer coefficient.
 
<p></p>
</html>"));
end Constant;
