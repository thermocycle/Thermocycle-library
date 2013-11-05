within ;
package ThermoCycle "A library for the simulation of thermal systems"








  annotation (uses(Modelica(version="3.2"),CoolProp2Modelica),Documentation(info="<HTML>
 <p><big>  The <b>ThermoCycle</b> library is an <b>open-source</b> library for dynamic modelling of ORC
systems developed in the Modelica language. The library aims at providing a robust framework to model thermal systems, including ORC systems.</p>
 




<img src=\"modelica://ThermoCycle/Resources/Images/ThermoCycleLibrary.png\">
 
<p><big> A number of libraries are available to model steam or gas cycles (e.g. ThermoSysPro, Power Plants, etc.), but few are able to handle the fluids used in ORC systems.<\p>
<p><big> Thermodynamic properties of organic fluids require complex equations of state available only in external libraries such as FluidProp, Refprop or CoolProp. 
  Thermodynamic properties in the ThermoCycle library are coomputed using the open-source library <b>CoolProp</b>. 
The interface between ThermoCycle and CoolProp is ensured by the <b>CoolProp2Modelica</b> library, which is based on a modified version of the External Media library.</p>


<p><big>The library is composed by 6 top-level package which are listed below:
<ul>
        <li><em><strong>Components
        <li><em><strong>Examples
        <li><em><strong>Functions
        <li><em><strong>Icons</strong></em></li>
        <li><em><strong>Interfaces</strong></em></li>
        <li><em><strong>Media</strong></em></li>
</ul>
</p>

<p><big>
<ul>
<li><strong><a href=\"modelica://ThermoCycle.Components\">Components</a> </strong>is the central part of the library. It is organized in three sub-package: FluidFlow, HeatFlow and Units. It contains all the models available in the library from the simple cell model for fluid flow to complete model of heat exchangers, expanders and control unit.

<li><strong><a href=\"modelica://ThermoCycle.Examples\">Examples</a> </strong>contains models where the components of the library can be tested. It includes several ORC plant models and it also provides a step by step procedure to build an ORC power unit.

<li><strong><a href=\"modelica://ThermoCycle.Functions\">Functions</a> </strong>are the empirical correlations used to characterized some of the models presents in the library.

<li><strong><a href=\"modelica://ThermoCycle.Icons\">Icons</a> </strong>define the graphical interface for some of the models in the library

<li><strong><a href=\"modelica://ThermoCycle.Interfaces\">Interfaces</a> </strong>define the type of connectors used in the library. The flow connectors are available for compressible, incompressible and perfect fluid model.

<li><strong><a href=\"modelica://ThermoCycle.Media\">Media</a> </strong>contain a list of some of the fluid available in the library. The CoolProp2Modelica library is anyway necessary to allow the coupling with CoolProp for computing the thermo-physical and transport properties of the fluids.
</ul>


   </HTML>"));
end ThermoCycle;
