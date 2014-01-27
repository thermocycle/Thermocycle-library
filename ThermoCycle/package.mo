within ;
package ThermoCycle "A library for the simulation of thermal systems"


  annotation (uses(Modelica(version="3.2"),CoolProp2Modelica,
    TILMedia(version="2.1.4"),
    ThermoPower(version="3.0")),                              Documentation(info="<HTML>
 <p><big>  The <b>ThermoCycle</b> library is an <b>open-source</b> library for dynamic modelling of ORC
systems developed in the Modelica language. The library aims at providing a robust framework to model thermal systems, including ORC systems.</p>

<p>
<img src=\"modelica://ThermoCycle/Resources/Images/ThermoCycleLibrary.png\">
</p> 
<p><big> Thermodynamic properties of organic fluids require complex equations of state available only in external libraries such as FluidProp, Refprop or CoolProp. 
  Thermodynamic properties in the ThermoCycle library are computed using the open-source library <b>CoolProp</b>. 
The interface between ThermoCycle and CoolProp on the Modelica level is ensured by the <b>CoolProp2Modelica</b> library, which is based on a modified version of the External Media library.</p>
</p>
<p><big><b>HOW TO HAVE THERMOCYCLE AND COOLPROP2MODELICA WORKING PROPERLY ON YOUR SYSTEM?</b></big></p>
<p><big>The CoolProp2Modelica library is the interface between Modelica and CoolProp.</p>

<p><big>The library requires the CoolProp Modelica wrapper to be installed on the target system. This wrapper can be downloaded and compiled from the  CoolProp website <a href=\"http://coolprop.sourceforge.net/HowGetIt.html\">http://www.http://coolprop.sourceforge.net/</a>. Pre-compiled versions using VisualStudio2010 and VisualStudio2008 
have also been made available. 

Once downloaded the CoolPropLib.lib file has to be copied in the “Dymola\bin\lib\” folder of the Dymola installation, usually in C:\Program Files\ .

</p>
<p></p>
<p><big><b>LIBRARY STRUCTURE</b></big></p>
<p><big>The library is composed by 7 top-level package which are listed below:
<ul>
        <li><em><strong>Components
        <li><em><strong>Examples
        <li><em><strong>Functions
        <li><em><strong>Icons</strong></em></li>
        <li><em><strong>Interfaces</strong></em></li>
        <li><em><strong>Media</strong></em></li>
        <li><em><strong>Obsolete</strong></em></li>
</ul>
</p>

<p><big>
<ul>
<li><strong><a href=\"modelica://ThermoCycle.Components\">Components</a> </strong>is the central part of the library. It is organized in three sub-package: FluidFlow, HeatFlow and Units. It contains all the models available in the library from the simple cell model for fluid flow to complete model of heat exchangers, expanders and control unit.

<li><strong><a href=\"modelica://ThermoCycle.Examples\">Examples</a> </strong>contains models where the components of the library can be tested. It includes several ORC plant models and it also provides a step by step procedure to build an ORC power unit.

<li><strong><a href=\"modelica://ThermoCycle.Functions\">Functions</a> </strong>are the empirical correlations used to characterized some of the models presents in the library.

<li><strong><a href=\"modelica://ThermoCycle.Icons\">Icons</a> </strong>define the graphical interface for some of the models in the library

<li><strong><a href=\"modelica://ThermoCycle.Interfaces\">Interfaces</a> </strong>define the type of connectors used in the library. The flow connectors are available for compressible, incompressible and perfect fluid model.

<li><strong><a href=\"modelica://ThermoCycle.Media\">Media</a> </strong>contains a list of some of the fluid available in the library. The CoolProp2Modelica library is anyway necessary to allow the coupling with CoolProp for computing the thermo-physical and transport properties of the fluids.
<li><strong><a href=\"modelica://ThermoCycle.Obsolete\">Obsolete</a> </strong> is a storage of some old models that are replaced by new ones during the development of the library but that are still used in some examples. 
</ul>


   </HTML>"));
end ThermoCycle;
