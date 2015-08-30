within ThermoCycle.Components.HeatFlow.Walls;
model MetalWall
parameter Integer N(min=1)=10 "Number of cells";
// Wall initial values:
parameter Modelica.SIunits.Area Aext "Heat exchange area external side";
parameter Modelica.SIunits.Area Aint "Heat exchange area internal side";
 final parameter Modelica.SIunits.Area Aext_i=Aext/N
    "Heat exchange area of one cell external side";
 final parameter Modelica.SIunits.Area Aint_i=Aint/N
    "Heat exchange area of one cell internal side";
  parameter Modelica.SIunits.Mass M_wall "Wall mass";
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall
    "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Temperature Tstart_wall_1
    "Wall temperature start value - first node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall_end
    "Wall temperature start value - last node"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_wall[N]=linspace(
        Tstart_wall_1,
        Tstart_wall_end,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/*Numerical Option */
parameter Boolean steadystate_T_wall=true
    "if true, sets the derivative of T_wall to zero during Initialization"    annotation (Dialog(group="Initialization options", tab="Initialization"));
  Interfaces.HeatTransfer.ThermalPort Wall_int( N=N, T(start = Tstart_wall))
    annotation (Placement(transformation(extent={{-30,20},{30,40}}),
        iconTransformation(extent={{-30,20},{30,40}})));
  Interfaces.HeatTransfer.ThermalPort Wall_ext( N=N, T(start = Tstart_wall))
    annotation (Placement(transformation(extent={{-30,-20},{30,0}}),
        iconTransformation(extent={{-32,-40},{28,-20}})));
/* METAL WALL */
Modelica.SIunits.Temperature T_wall[N](start=linspace(
          Tstart_wall_1,
          Tstart_wall_end,
          N)) "Cell temperatures";

Modelica.SIunits.Power Q_tot_int
    "Total heat flux exchanged by the internal thermal port";
Modelica.SIunits.Power Q_tot_ext
    "Total heat flux exchanged by the external thermal port";
equation
  for j in 1:N loop
    /*Metal wall */
    M_wall/(N)*der(T_wall[j])*c_wall = Aext_i*Wall_ext.phi[j] + Aint_i*Wall_int.phi[j];
  end for;

  Q_tot_int = Aint*sum(Wall_int.phi)/N;
  Q_tot_ext = Aext*sum(Wall_ext.phi)/N;

//* BOUNDARY CONDITION *//
//No temperature gradient
Wall_ext.T = T_wall;
Wall_int.T = T_wall;
initial equation
if steadystate_T_wall then
    der(T_wall) = zeros(N);
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
<p><big> Model <b>MetalWall</b> represents a discretized 1-dimensional tube of solid material. The assumptions of the model are:
<ul><li> Wall thermal resistance is neglected (i.e. No temperature gradient in the wall)
<li> Longitudinal thermal energy conduction is neglected
<li> Dynamic thermal energy capacity is accounted for.
</u1>
 <p><b><big>Modelling options</b></p>
 <p><big> In the <b>Initialization</b> tab the following options are available:
        <ul><li> steadystate_T_wall: If it sets to true, the derivative of temperature is sets to zero during <em>Initialization</em> 
         </ul>
 
</html>"));
end MetalWall;
