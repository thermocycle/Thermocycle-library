within ;
package ThermoCycle "A library for the simulation of thermal systems"
                                                                      extends
  Modelica.Icons.Package;


  annotation (uses(ExternalMedia,Modelica(version="3.2.1")),                             Documentation(info="<html>
<h1>Welcome to the ThermoCycle library!</h1>
<p>The <b>ThermoCycle</b> library is an <b>open-source</b> library for dynamic modelling of ORC systems developed in the Modelica language. The library aims at providing a robust framework to model thermal systems, including ORC systems. </p>
<p><img src=\"modelica://ThermoCycle/Resources/Images/ThermoCycleLibrary.png\"/> </p>
<p>Thermodynamic properties of organic fluids require complex equations of state available only in external libraries such as FluidProp, REFPROP or CoolProp. Thermodynamic properties in the ThermoCycle library are computed using the open-source library <b>CoolProp</b>. The interface between ThermoCycle and CoolProp on the Modelica level is ensured by the <b>ExternalModelica</b> library. Please make sure that you have both ThermoCycle and ExternalMedia working properly before you try to run our models.</p>
<h2>LIBRARY STRUCTURE</h2>
<p>The library is composed by 7 top-level package which are listed below: </p>
<ul>
<li><b><a href=\"modelica://ThermoCycle.Components\">Components</a> </b>is the central part of the library. It is organized in three sub-package: FluidFlow, HeatFlow and Units. It contains all the models available in the library from the simple cell model for fluid flow to complete model of heat exchangers, expanders and control unit. </li>
<li><b><a href=\"modelica://ThermoCycle.Examples\">Examples</a> </b>contains models where the components of the library can be tested. It includes several ORC plant models and it also provides a step by step procedure to build an ORC power unit. </li>
<li><b><a href=\"modelica://ThermoCycle.Functions\">Functions</a> </b>are the empirical correlations used to characterized some of the models presents in the library. </li>
<li><b><a href=\"modelica://ThermoCycle.Icons\">Icons</a> </b>define the graphical interface for some of the models in the library </li>
<li><b><a href=\"modelica://ThermoCycle.Interfaces\">Interfaces</a> </b>define the type of connectors used in the library. The flow connectors are available for compressible, incompressible and perfect fluid model. </li>
<li><b><a href=\"modelica://ThermoCycle.Media\">Media</a> </b>contains a list of some of the fluid available in the library. The fluids in this package are labeled with the acronym <b>TC</b>. The CoolProp2Modelica library is anyway necessary to allow the coupling with CoolProp for computing the thermo-physical and transport properties of the fluids. </li>
<li><b><a href=\"modelica://ThermoCycle.Obsolete\">Obsolete</a> </b>is a storage of some old models that are replaced by new ones during the development of the library but that are still used in some examples. </li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Bitmap(extent={{-100,100},{100,-100}}, fileName=
            "modelica://ThermoCycle/Resources/Images/ThermoCycleLibrary.png")}));
end ThermoCycle;
