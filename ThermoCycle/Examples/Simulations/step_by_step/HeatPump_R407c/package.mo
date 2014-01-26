within ThermoCycle.Examples.Simulations.step_by_step;
package HeatPump_R407c "5th exercice class: step-by-step resolution"
extends Modelica.Icons.Package;


  annotation (Documentation(info="<HTML>
  <p><big> This package allows the user to build a basic heat pump system by following a step-by-step procedure.
  The complete heat pump model is composed by the following components: a compressor (scroll-type), two plate heat exchangers
  one liquid receiver, a valve and two pressure drop model.
  <ul>
  <li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step1\">Step1</a> </strong> We start by modeling the condensation of the working fluid with the following components:
  <ul><li><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a>: It represents the flow of the working fluid
  <li><a href=\"modelica://ThermoCycle.Components.HeatFlow.Sources.Source_T\">Source_T</a>: it represents the temperature source --> it allows the condensation of the fluid
  <li><a href=\"modelica://ThermoCycle.Components.FluidFlow.Reservoirs.SinkP\">SinkP</a>: pressure sink. It imposes the pressure to the system
  <li><a href=\"modelica://ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot\">SourceMdot</a>: Mass flow source. It imposes mass flow and inlet temperature to the system
  </ul>
  <li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step2\">Step2</a> </strong> We replace the Flow1Dim component with an heat exchanger component where the secondary fluid
  is considered incompressible --> <a href=\"modelica://ThermoCycle.Components.Units.HeatExchangers.Hx1DInc\">Hx1DInc</a>. 
  <ul><li>Choose StandardWater as working fluid for the secondary fluid
  <li> Choose upwind-AllowFlowReversal as discretization scheme
  <li> Impose constant heat transfer coefficient in the working fluid side
  <li> Impose an heat transfer coefficient depending on mass flow in the secondary fluid side
  </ul>
<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step3\">Step3</a> </strong> Add the <a href=\"modelica://ThermoCycle.Components.Units.Tanks.Tank_pL\">Liquid receiver</a> after the condenser. 
The pressure is imposed by the pressure sink connected to the liquid receiver. 

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step4\">Step4</a> </strong> Change the pressure sink after the liquid receiver with a volumetric flow sink. In this way
the pressure will be imposed by the tank system.

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step5\">Step5</a> </strong> Add the <a href=\"modelica://ThermoCycle.Components.Units.PdropAndValves.Valve\">Valve</a> component after the liquid receiver

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step6\">Step6</a> </strong> Add the evaporator after the valve considering the secondary fluid as an incompressible fluid --> <a href=\"modelica://ThermoCycle.Components.Units.HeatExchangers.Hx1DInc\">Hx1DInc</a>.
  <ul><li>Choose Air as working fluid for the secondary fluid
  <li> Choose upwind-AllowFlowReversal as discretization scheme
  <li> Impose constant heat transfer coefficient in the working fluid side
  <li> Impose an heat transfer coefficient depending on mass flow in the secondary fluid side

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step7\">Step7</a> </strong> Add the <a href=\"modelica://ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor\">Compressor</a> compoennt and the <a href=\"modelica://ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive\">Electric drive</a> component which
will allow to control the rotational speed fof the compressor. Add finally a constant source from the Modelica library (<a href=\"modelica://Modelica.Blocks.Sources.Constant\">Constant source</a>) to impose a constant rotational speed to the system.

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step8\">Step8</a> </strong> Close the cycle and simulate over 100 seconds

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step9\">Step9</a> </strong> Add pressure drop that are considered lumped in the lowest vapor density regions of both low and high pressure lines. Simulate over 100 seconds

<li><strong><a href=\"modelica://ThermoCycle.Examples.Simulations.step_by_step.HeatPump_R407c.step10\">Step10</a> </strong> In order to evaluate the dynamic performance of the system impose a variation in the compressor rotational speed at 50s and a variation in the aperture of the valve at 75s.


  </ul>
In order to get a better visualization of the results the authors suggest the use of the ThermoCycle viewer which can be easly downloaded from <a href=\"http://www.thermocycle.net/\">http://www.thermocycle.net/</a>.
  </HTML>"));
end HeatPump_R407c;
