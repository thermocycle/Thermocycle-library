within ThermoCycle.Components.FluidFlow.Reservoirs;
model SourceCdot "Flowrate source for Cdot-type heat source"
  parameter Modelica.SIunits.MassFlowRate Mdot_0=0
    "Mass flowrate if input not connected";
  parameter Modelica.SIunits.Temperature T_0=298.13
    "Temperature if input not connected";
  parameter Modelica.SIunits.Temperature T_ref=323.15
    "Reference Temperature for the calculation of H_dot";
  parameter Modelica.SIunits.SpecificHeatCapacity cp=1000
    "Specific Heat capacity";
  parameter Modelica.SIunits.Density rho=1000 "Fluid Density";
  Modelica.Blocks.Interfaces.RealInput T_source
    annotation (Placement(transformation(
        origin={-40,60},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-15,-15},{15,15}},
        origin={-73,-21})));
  Interfaces.Fluid.Flange_ex_Cdot flange
                                annotation (Placement(transformation(extent={{82,-2},
            {102,18}}),       iconTransformation(extent={{62,-20},{102,18}})));
  Modelica.Blocks.Interfaces.RealOutput Hdot annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,64}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,44})));
  Modelica.Blocks.Interfaces.RealInput M_dot_source annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-76,62}), iconTransformation(
        extent={{16,-16},{-16,16}},
        rotation=180,
        origin={-70,18})));
equation
  flange.Mdot = M_dot_source;
  flange.T = T_source+273.15;
  if cardinality(M_dot_source) == 0 then
    flange.Mdot = Mdot_0 "Flow rate set by parameter";
  end if;
 if cardinality(T_source) == 0 then
  flange.T = T_0 "Temperature set by parameter";
 end if;
  flange.cp = cp;
  flange.rho = rho;
  Hdot = flange.Mdot * (flange.T - T_ref) * cp;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}
            ), graphics={
        Rectangle(extent={{-72,38},{80,-40}}, lineColor={0,0,0},
          radius=10),
        Polygon(
          points={{-12,-20},{32,0},{-12,20},{34,0},{-12,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{-100,-44},{100,-72}}, textString="%name"),
        Text(
          extent={{-34,36},{34,-6}},
          lineColor={0,0,0},
          textString="M",
          lineThickness=1),
        Text(
          extent={{-30,-2},{30,-44}},
          lineColor={0,0,0},
          textString="T"),
        Line(
          points={{-2,32},{2,32},{-2,32}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=1)}),    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}
            ), graphics={Text(extent={{-98,74},{-48,42}}, textString="w0"),
          Text(extent={{48,74},{98,42}}, textString="h")}),
Documentation(info="<HTML>
                    <p><big> Model <b>SourceCdot</b> represents an ideal mass flow source, with prescribed specific heat capacity, temperature and density of the constant heat capacity fluid flowing from the model to the port (i.e. out of the model).

 <p><big> The massFlow and temperature can be set as  parameters or defined by the connectors.

 <p><big>The calculation of the fluid thermal energy, calculated with respect to a user-defined reference temperature, is implemented in the model and accessible by the Hdot output.


                    </HTML>"));
end SourceCdot;
