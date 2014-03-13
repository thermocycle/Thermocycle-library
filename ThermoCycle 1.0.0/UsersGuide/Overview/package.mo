within ThermoCycle.UsersGuide;
package Overview 
extends Modelica.Icons.Information;


annotation (Documentation(info="<HTML>
<p><big>
The ThermoCycle library aims at providing a robust framework to model small-capacity thermal systems,
with a focus on organic Rankine cycle (ORC) and heat pump systems. The goal is to provide a fully opensource
integrated solution going from thermodynamic properties, using CoolProp, to the simulation of complex
systems with their control strategy. 
</p>
<p><big>
The library is designed for system level simulations and the models
are either discretized in one dimensions or based on lumped parameters approximations. Homogeneous
one and two-phase flow are taken into account, while non-homogeneous, multi-phase flows are not considered
yet. The connectors used in the library are compatible with the interfaces of the Modelica Standard
Library and the models are able to handle reverse flow.
</p>


</HTML>
"));

end Overview;
