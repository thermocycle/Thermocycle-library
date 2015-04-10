within ThermoCycle.Components.HeatFlow.HeatTransfer;
model Smoothed "Smoothed: Smooth transitions between the different zones"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferSmoothed;
equation
  for i in 1:n loop
    U[i] = U_nom * massFlowFactor;
    q_dot[i] = U[i]*(thermalPortL[i].T - T_fluid[i]);
  end for;

annotation(Documentation(info="<html>

<p><big> The model <b>Smoothed</b> extends the partial model
 <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferSmoothed\">PartialHeatTransferSmoothed</a> 
 and calculates the heat transfer coefficient based on the following equation:</p>
  
 <p>
<img src=\"modelica://ThermoCycle/Resources/Images/HTC_massFlow.png\">
</p>  
  
<p><big> Note that in the model U_nom corresponds to the smoothed heat transfer coefficient calculated in  <a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferSmoothed\">PartialHeatTransferSmoothed</a> 
</p> 
 <p></p>
</html>"));
end Smoothed;
