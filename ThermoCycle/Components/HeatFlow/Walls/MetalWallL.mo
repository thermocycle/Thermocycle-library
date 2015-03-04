within ThermoCycle.Components.HeatFlow.Walls;
model MetalWallL
// Wall initial values:
  parameter Modelica.SIunits.Area Aext
    "Heat exchange area of one cell external side";
  parameter Modelica.SIunits.Area Aint
    "Heat exchange area of one cell internal side";
  parameter Modelica.SIunits.Mass M_wall "Mass of one cell";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall
    "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Temperature Tstart_wall
    "Start value of temperature (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/*Numerical Option */
parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL  Wall_int(T(start=Tstart_wall))
    annotation (Placement(transformation(extent={{-30,20},{30,40}}),
        iconTransformation(extent={{-30,20},{30,40}})));
ThermoCycle.Interfaces.HeatTransfer.ThermalPortL  Wall_ext(T(start=Tstart_wall))
    annotation (Placement(transformation(extent={{-30,-20},{30,0}}),
        iconTransformation(extent={{-32,-40},{28,-20}})));
/* METAL WALL */
Modelica.SIunits.Temperature T_wall(start=
          Tstart_wall) "Cell temperature";
equation
    /*Metal wall */
    M_wall*der(T_wall)*c_wall = Aext*Wall_ext.phi + Aint*Wall_int.phi;
//* BOUNDARY CONDITION *//
//No temperature gradient
Wall_ext.T = T_wall;
Wall_int.T = T_wall;
initial equation
if steadystate_T_wall then
    der(T_wall) = 0.0;
  end if;
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-62,20},{60,-20}},
          lineColor={135,135,135},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{28,36},{60,22}},
          lineColor={135,135,135},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="Int"),
        Text(
          extent={{32,-24},{64,-38}},
          lineColor={135,135,135},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="Ext")}),
    Documentation(info="<HTML>
<p><big> Model <b>MetalWallL</b> represents a lumped tube of solid material. The assumptions and options of the model are the same as the <b>MetalWall</b> model

 
</html>"));
end MetalWallL;
