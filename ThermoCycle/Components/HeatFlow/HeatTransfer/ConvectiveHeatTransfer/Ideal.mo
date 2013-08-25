within ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer;
model Ideal "Cylinder heat transfer without thermal resistance"

  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation;
equation
  T_fluid = thermalPortL.T;
  annotation(Documentation(info="<html>
<p>Ideal heat transfer without thermal resistance. </p>
<p><br/>This is taken from: Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer</p>
</html>"));
end Ideal;
