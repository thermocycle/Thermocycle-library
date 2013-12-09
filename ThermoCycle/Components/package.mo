within ThermoCycle;
package Components 
  extends Modelica.Icons.Package;


annotation (Documentation(info="<HTML>
<p><big> The <strong><a href=\"modelica://ThermoCycle.Components\">Components</a> </strong> package is the central part of the library. It is organized in three sub-package: FluidFlow, HeatFlow and Units. It contains all the models available in the library from the
 simple cell model for fluid flow to complete model of heat exchangers, expanders and control unit. It is composed by the the follwing subpackages:
 
<ul><li><strong><a href=\"modelica://ThermoCycle.Components.FluidFlow\">FluidFlow</a> </strong> contains the pipes model of the library together with reservoir models to impose boundary conditions to fluid models, and sensors.
<li><strong><a href=\"modelica://ThermoCycle.Components.HeatFlow\">HeatFlow</a> </strong> contains wall models, heat transfer models, thermal sensors and reservoir models to impose boundary conditions to thermal models
<li><strong><a href=\"modelica://ThermoCycle.Components.Units\">Units</a> </strong> it contains the model of components typically used in Organic Rankine cycle system and CSP system. It also contains a package for basic PID controller and for parabolic solar collectors models.
</ul>



<dl><dt><b>Main Authors:</b> <br/></dt>
<dd>Sylvain Quoilin; &LT;<a href=\"squoilin@ulg.ac.be\">squoilin@ulg.ac.be</a>&GT;</dd>
<dd>Adriano Desideri &LT;<a href=\"adesideri@ulg.ac.be\">adesideri@ulg.ac.be</a>&GT;<br/></dd>
<dd>University of Liege</dd>
<dd>Laboratory of thermodynamics</dd>
<dd>Campus du Sart-Tilman Bât B49 (P33)</dd>
<dd>B-4000 Liège - BELGIUM -<br/></dd>
<dt><b>Copyright:</b> </dt>
<dd>Copyright &copy; 2013-2014, Sylvain Quoilin and Adriano Desideri.<br/></dd>
<dd><i>The IndustrialControlSystems package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>.</i><br/></dd>
</dl></html>"));
end Components;
