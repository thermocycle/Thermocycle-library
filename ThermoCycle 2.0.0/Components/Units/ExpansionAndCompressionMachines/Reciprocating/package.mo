within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
package Reciprocating "A reciprocating machine with different connectors"
  extends Modelica.Icons.Package;


  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Reciprocating Machines</font></h4></p>
<p>A package that provides some basic models for dynamic modelling of reciprocating machines. 
A base class (BaseClasses.PartialRecipMachine) takes care of the internal slider-crank-mechanism and also provides 
an animation thanks to the Modelica.Mechanics.Multibody package. Interaction with other parts of your model is possible via rotational flange connectors (Modelica.Mechanics.Rotational.Interfaces.Flange_xxx) that convey torque and can be connected to other components. Please have a look at the examples to see how to use the connectors.</p>
<p>In order to create your own components from the units in this package, you should redefine geometry and initial conditions. Please note that there are two base classes that can be used for your own geometry, BaseClasses.BaseGeometry and BaseClasses.SimpleGeometry both provide all the necessary inputs. As the name suggests, BaseClasses.SimpleGeometry should be easier to use, but does not provide all the flexibility, e.g. no piston pin offset from crankshaft centre. </p>
<p>This work uses many components from the Modelica standard library and adds only a few things, please be aware that there are many devoted people behind the development of Modelica libraries and their implementations.</p>
<p>Licensed by the Modelica Association under the Modelica License 2</p>
<p>Copyright &copy; 2011-2013 Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark</p>
<p>Main contributor: Jorrit Wronski (jowr@mek.dtu.dk)</p>
</html>"),
       Icon(graphics));
end Reciprocating;
