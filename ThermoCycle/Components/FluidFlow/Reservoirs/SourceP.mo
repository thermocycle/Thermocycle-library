within ThermoCycle.Components.FluidFlow.Reservoirs;
model SourceP "Pressure source for water/steam flows"
  extends ThermoCycle.Icons.Water.SourceP;
  replaceable package Medium = Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Pressure p0=1.01325e5 "Nominal pressure";
  parameter Modelica.SIunits.SpecificEnthalpy h_0=1e5
    "Enthalpy if no connector" annotation (Dialog(enable=not UseT));
  parameter Modelica.SIunits.Temperature T_0= 273.15+25
    "Temperature of fluid going out if no connector";
  parameter Boolean UseT=true "Use temperature as input instead of enthalpy";

  Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
  Modelica.SIunits.Pressure p "pressure";

  Modelica.Blocks.Interfaces.RealInput in_p
    annotation (Placement(transformation(
        origin={-40,92},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,82})));
  Modelica.Blocks.Interfaces.RealInput in_h
    annotation (Placement(transformation(
        origin={40,90},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,70})));
  Modelica.Blocks.Interfaces.RealInput in_T
    annotation (Placement(transformation(
        origin={2,92},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={2,92})));
  Interfaces.Fluid.FlangeB flange( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{84,-10},{104,10}})));

equation
    flange.p = p;
   p = in_p;
  if cardinality(in_p)==0 then
    in_p = p0 "Pressure set by parameter";
  end if;

    if cardinality(in_T) == 0 then
    in_T = T_0 "Temperature set by parameter";
    end if;

  if UseT then
    h = Medium.specificEnthalpy_pTX(p,in_T,fill(0,0));
  flange.h_outflow =h;
  else
    flange.h_outflow =in_h;
    h = 0;
  end if;

  if cardinality(in_h)==0 then
    in_h = h "Enthalpy set by parameter";
  end if;
  annotation (
    Diagram(graphics),
    Icon(graphics={Text(extent={{-110,104},{-56,64}},textString=
                                                 "p0"), Text(extent={{68,82},{100,
              44}},     textString=
                             "h")}),
    Documentation(info="<HTML>

<p><big> Model <b>SourceP</b> sets the boundary pressure and enthalpy of the fluid flowing from the model to the port (i.e. out of the model).
 <p><b><big>Modelling options</b></p>
               <p><big> In the <b>General</b> tab the following option is availabe:
        <ul>
        <li> UseT: if true uses the temperature as an input instead of using enthalpy</ul>
<p><big> The pressure and temperature or enthalpy can be set as parameters or defined by the connectors.
 <p><big>Note that boundary enthalpy is imposed by the model only if the fluid is flowing out of the model. If flow reversal happens (i.e. mass flow flowing into <b>SourceP</b>) then only the boundary pressure is imposed by the model.
 <p>



</html>"));
end SourceP;
