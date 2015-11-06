within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkP_pT
  "Pressure sink for single phase fluids with pT as state variables"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Pressure p0=1.01325e5 "Nominal pressure";
  parameter Modelica.SIunits.Temperature T=283.15 "Nominal specific enthalpy";
  parameter Medium.MassFraction X[Medium.nX] = Medium.X_default
    "Fixed value of composition"
    annotation (Evaluate = true,
                Dialog(enable = Medium.nXi > 0));
  parameter Medium.ExtraProperty C[Medium.nC](
     quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
  annotation (Evaluate=true,
              Dialog(enable = Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput in_p0 annotation (Placement(
        transformation(
        origin={-40,88},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Modelica.Blocks.Interfaces.RealInput in_T annotation (Placement(
        transformation(
        origin={40,88},
        extent={{-20,-20},{20,20}},
        rotation=270)));
 ThermoCycle.Interfaces.Fluid.FlangeB_pT flangeB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}}),
        iconTransformation(extent={{-94,-10},{-74,10}})));
equation
  flangeB.p = in_p0;
  if cardinality(in_p0) == 0 then
    in_p0 = p0 "Pressure set by parameter";
  end if;
  flangeB.T_outflow = in_T;
  if cardinality(in_T) == 0 then
    in_T = T "Enthalpy set by parameter";
  end if;
  flangeB.Xi_outflow = X[1:Medium.nXi];
  flangeB.C_outflow = C;
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{-106,92},{-56,50}}, textString=
              "p0"), Text(extent={{54,94},{112,52}},
          textString="T",
          lineColor={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<html>
<p>Model <b>sinkP_pT</b> represents a pressure sink for single phase flows that sets the boundary pressure of the fluid from the port to the model (i.e., into the model). The port is a flange connector Flange_pT.</p>
<p>The pressure and temperature can be set as parameters or defined by an input connector.</p>
<p>It must be noticed that boundary pressure is imposed by the model if the fluid flowing into the model. If flow reversal happens (i.e., mass flow rate flowing out of the model) then the boundary temperature is also imposed by the model.</p>
</html>"),
    conversion(noneFromVersion=""));
end SinkP_pT;
