within ThermoCycle.Components.FluidFlow.Reservoirs;
model SourceMdot "Flowrate source for fluid flows"
  //The pressure is defined by the next component!
  extends ThermoCycle.Icons.Water.SourceW;
  replaceable package Medium = Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Mass flowrate if no connector";
  parameter Modelica.SIunits.Pressure p=101325 "Pressure";
  parameter Boolean UseT=true "Use temperature as input instead of enthalpy";
  parameter Modelica.SIunits.Temperature T_0=298.15
    "Temperature if no connector"                                                 annotation (Dialog(enable=UseT));
  parameter Modelica.SIunits.SpecificEnthalpy h_0=0 "Enthalpy if no connector" annotation (Dialog(enable=not UseT));
  Modelica.SIunits.SpecificEnthalpy h "specific enthalpy";
  Modelica.Blocks.Interfaces.RealInput in_Mdot annotation (Placement(
        transformation(
        origin={-40,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,60})));
  Modelica.Blocks.Interfaces.RealInput in_h annotation (Placement(
        transformation(
        origin={40,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,60})));
  Modelica.Blocks.Interfaces.RealInput in_T annotation (Placement(
        transformation(
        origin={2,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-2,60})));
 Interfaces.Fluid.FlangeB flangeB( redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  flangeB.m_flow = -in_Mdot;
  if cardinality(in_Mdot) == 0 then
    in_Mdot = Mdot_0 "Flow rate set by parameter";
  end if;
  if cardinality(in_T) == 0 then
    in_T = T_0 "Temperature set by parameter";
  end if;
  if UseT then
    h = Medium.specificEnthalpy_pTX(p,in_T,fill(0,0));
    flangeB.h_outflow = h;
  else
    flangeB.h_outflow = in_h;
    h = 0;
  end if;
  if cardinality(in_h) == 0 then
    in_h = h_0 "Enthalpy set by parameter";
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(extent={{-76,42},{-30,10}}, textString="Mdot"),
        Text(extent={{40,40},{84,12}}, textString="h"),
        Text(extent={{-20,40},{18,12}}, textString="T")}), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics),Documentation(info="<HTML> 
                    <p><big> Model <b>SourceMdot</b> represents an ideal mass flow sources, with prescribed enthalpy of the fluid flowing from the model to the port (i.e. out of the model).
                 <p><b><big>Modelling options</b></p>
               <p><big> In the <b>General</b> tab the following option is available:
        <ul>
        <li> UseT: if true uses the temperature as an input instead of using enthalpy</ul> 
 <p><big> The mass flow and temperature or enthalpy can be set as parameters or defined by the connectors. 
 
 <p><big>Note that boundary mass flow and enthalpy are imposed by the model only if the fluid is flowing out of the model. If flow reversal happens (i.e. mass flow flowing into <b>SourceMdot</b>) then the boundary pressure is imposed by the model.
                    
                    
                    </HTML>"));
end SourceMdot;
