within ThermoCycle.Components.FluidFlow.Reservoirs;
model SinkP "Pressure sink"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Pressure p0=1.01325e5 "Nominal pressure";
  parameter Modelica.SIunits.SpecificEnthalpy h=1e5 "Nominal specific enthalpy";
  Modelica.SIunits.Pressure p;
  Modelica.Blocks.Interfaces.RealInput in_p0 annotation (Placement(
        transformation(
        origin={-40,88},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Modelica.Blocks.Interfaces.RealInput in_h annotation (Placement(
        transformation(
        origin={40,88},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Interfaces.Fluid.FlangeB flangeB(  redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}}),
        iconTransformation(extent={{-94,-10},{-74,10}})));
equation
  flangeB.p = p;
  p = in_p0;
  if cardinality(in_p0) == 0 then
    in_p0 = p0 "Pressure set by parameter";
  end if;
  flangeB.h_outflow = in_h;
  if cardinality(in_h) == 0 then
    in_h = h "Enthalpy set by parameter";
  end if;
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{-106,92},{-56,50}}, textString=
              "p0"), Text(extent={{54,94},{112,52}}, textString="h")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<HTML> 
    <p><big> Model <b>SinkP</b> sets the boundary pressure of the fluid flowing from the port to the model (i.e. into the model).

  
 <p><big>Note that boundary pressure is imposed by the model if the fluid is flowing into the model. If flow reversal happens (i.e. mass flow flowing out og <b>SinkP</b>) then the boundary enthalpy is also imposed by the model.
 <p><big> The pressure and enthalpy can be set as parameters or defined by the connector.
 <p>


</html>"),
    conversion(noneFromVersion=""));
end SinkP;
