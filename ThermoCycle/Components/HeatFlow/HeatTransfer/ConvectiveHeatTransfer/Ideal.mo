within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model Ideal "Ideal: Heat transfer without thermal resistance"

  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
equation
  T_fluid = thermalPortL.T;
  annotation(Documentation(info="<html>
<p><big>Ideal heat transfer without thermal resistance. </p>
<p></p>
</html>"));
end Ideal;
