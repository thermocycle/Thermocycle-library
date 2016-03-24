within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests;
package TestEvaporator 
 extends Modelica.Icons.ExamplesPackage;


annotation (   Documentation(info="<HTML>
<p><big>  In this package the evaporator MB model is tested with and without pressure drop after it.
<p><big> The model I developed has still some issue when modeling alone i.e. negative length of the subcooled. It could be solved
by implementing an advanced version of the epsilon-NTU. It fails to reduce DAE index when adding a pdrop after it--> Try by adding wall and Casella's initial conditions.
<p><big> Bonilla's model is very fast and elegant but it does not work when adding a Pdrop component after it. It fails to start the simulation
<p><big> Casella's model seems very unstable when adding a finite volume secondary fluid on the other side.. It runs when
adding a Pdrop but it fails after a while presenting a very weird trend


   </HTML>"));
end TestEvaporator;
