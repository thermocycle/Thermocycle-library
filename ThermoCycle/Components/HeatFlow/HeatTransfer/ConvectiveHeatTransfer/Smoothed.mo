within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model Smoothed
  "Smoothed: Smooth transitions between the different flow regimes"
  extends BaseClasses.PartialConvectiveSmoothed;
equation
  for i in 1:n loop
    U[i] = U_nom * massFlowFactor;
    q_dot[i] = U[i]*(thermalPortL[i].T - T_fluid[i]);
  end for;

annotation(Documentation(info="<html>

<p><big> The model <b>Smoothed</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveSmoothed\">PartialConvectiveSmoothed</a>
 and calculates the heat transfer coefficient based on the following equation:</p>

 <p>
<img src=\"modelica://ThermoCycle/Resources/Images/HTC_massFlow.png\">
</p>

<p><big> Note that in the model U_nom corresponds to the smoothed heat transfer coefficient calculated in  <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveSmoothed\">PartialConvectiveSmoothed</a>
</p>
 <p></p>
</html>"));
end Smoothed;
