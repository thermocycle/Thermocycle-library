within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.TwoPhaseCorrelations;
model Constant "Constant: Constant heat transfer coefficient"
  extends BaseClasses.PartialTwoPhaseCorrelation;
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_c = 3000
    "Heat transfer coefficient";
equation
  U = U_c;

   annotation(Documentation(info="<html>

<p><big> The model <b>Constant</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialTwoPhaseCorrelation\">PartialTwoPhaseCorrelation</a> and 
 impose a constant heat transfer coefficient.
 </p>


<p></p>

</html>"));
end Constant;
