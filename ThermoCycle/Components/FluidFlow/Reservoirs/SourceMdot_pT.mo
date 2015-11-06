within ThermoCycle.Components.FluidFlow.Reservoirs;
model SourceMdot_pT
  "Flowrate source for single phase flows with pT as state variables"
  //The pressure is defined by the next component!
  extends ThermoCycle.Icons.Water.SourceW;
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Mass flowrate if no connector";
  parameter Modelica.SIunits.Temperature T_0=298.15
    "Temperature if no connector";
  parameter Modelica.SIunits.Pressure p=101325 "Pressure";
  parameter Medium.MassFraction X[Medium.nX] = Medium.X_default
    "Fixed value of composition"
    annotation (Evaluate = true,
                Dialog(enable = Medium.nXi > 0));
  parameter Medium.ExtraProperty C[Medium.nC](
     quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
  annotation (Evaluate=true,
              Dialog(enable = Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput in_Mdot annotation (Placement(
        transformation(
        origin={-40,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,60})));
  Modelica.Blocks.Interfaces.RealInput in_T annotation (Placement(
        transformation(
        origin={40,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,60})));
 ThermoCycle.Interfaces.Fluid.FlangeB_pT flangeB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  flangeB.m_flow = -in_Mdot;
  if cardinality(in_Mdot) == 0 then
    in_Mdot = Mdot_0 "Flow rate set by parameter";
  end if;
  if cardinality(in_T) == 0 then
    in_T = T_0 "Temperature set by parameter";
  end if;
  flangeB.T_outflow = in_T;
  flangeB.Xi_outflow = X[1:Medium.nXi];
  flangeB.C_outflow = C;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                         graphics={
        Text(extent={{-62,42},{-16,10}}, textString="Mdot"),
        Text(extent={{22,40},{60,12}},  textString="T")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                    graphics),Documentation(info="<html>
<p>Model <b>sourceMdot_pT</b> represents an ideal mass flow rate source for single phase flows with prescribed temperature of the fluid flowing from the model to the port (i.e.., out of the model). The port is a flange connector Flange_pT. </p>
<p>The mass flow rate and temperature can be set as parameters or defined by an input connector.</p>
<p>It must be noticed that the boundary mass flow rate and temperature are imposed by the model only if the fluid is flowing out of the model. If flow reversal happens (i.e., mass flow rate flowing into the model) then the boundary pressure is imposed by the model.</p>
</html>"));
end SourceMdot_pT;
