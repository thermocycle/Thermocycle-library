within ThermoCycle.Examples.Simulations.step_by_step;
package HeatPump_R407c "5th exercice class: step-by-step resolution"
extends Modelica.Icons.Package;
  model step1

    ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
      Mdotnom=0.044,
      redeclare model Flow1DimHeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      A=4,
      V=0.002,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      pstart=1650000,
      Tstart_inlet=345.15,
      Tstart_outlet=305.15)
      annotation (Placement(transformation(extent={{18,6},{-18,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium = ThermoCycle.Media.R407c_CP,
                                          p0=1650000)
      annotation (Placement(transformation(extent={{-54,14},{-74,34}})));
    ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=10)
      annotation (Placement(transformation(extent={{-10,52},{10,72}})));
    Modelica.Blocks.Sources.Constant const(k=280)
      annotation (Placement(transformation(extent={{-52,72},{-36,88}})));
  equation
    connect(sourceMdot.flangeB, flow1Dim.InFlow) annotation (Line(
        points={{49,24},{15,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
        points={{-15,24.15},{-35.5,24.15},{-35.5,24},{-55.6,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
        points={{-0.1,57.9},{-0.1,52.95},{0,52.95},{0,31.5}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(const.y, source_T.Temperature) annotation (Line(
        points={{-35.2,80},{0,80},{0,66}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}),      graphics));
  end step1;

  model step2

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium = ThermoCycle.Media.R407c_CP,
      h=4E5,
      p0=1650000)
      annotation (Placement(transformation(extent={{-52,14},{-72,34}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
  equation
    connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl2, sinkP1.flangeB) annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sinkP.flangeB, hx1DInc.outlet_fl1) annotation (Line(
        points={{-53.6,24},{-13,24}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput);
  end step2;

  model step3

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium = ThermoCycle.Media.R407c_CP,
      h=4E5,
      p0=1650000)
      annotation (Placement(transformation(extent={{-50,-42},{-70,-22}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  equation
    connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl2, sinkP1.flangeB) annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl1, tank_pL.InFlow) annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sinkP.flangeB, tank_pL.OutFlow) annotation (Line(
        points={{-51.6,-32},{-40,-32},{-40,-2.8}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput);
  end step3;

  model step4

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_0=-0.044,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{-4,-28},{-24,-8}})));
  equation
    connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl2, sinkP1.flangeB) annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl1, tank_pL.InFlow) annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, sourceMdot2.flangeB) annotation (Line(
        points={{-40,-2.8},{-40,-18},{-23,-18}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput);
  end step4;

  model step5

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.55,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(redeclare package
        Medium = ThermoCycle.Media.R407c_CP,
                                          p0=380000)
      annotation (Placement(transformation(extent={{-2,-50},{18,-30}})));
  equation
    connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl2, sinkP1.flangeB) annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(hx1DInc.outlet_fl1, tank_pL.InFlow) annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(valve.OutFlow, sinkP2.flangeB) annotation (Line(
        points={{-40,-35},{-40,-40},{-0.4,-40}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step5;

  model step6

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.55,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(redeclare package
        Medium = ex5.R407c, p0=380000)
      annotation (Placement(transformation(extent={{42,-62},{62,-42}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_wf=0.044,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
      A_sf=20,
      Unom_sf=100,
      Mdotnom_sf=0.76,
      pstart_wf=460000,
      Tstart_inlet_wf=263.15,
      Tstart_outlet_wf=277.15,
      Tstart_inlet_sf=280.15,
      Tstart_outlet_sf=273.15)
      annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa,
      Mdot_0=1.76,
      T_0=273.15)
      annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
        Medium = Modelica.Media.Air.DryAirNasa)
      annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
  equation
    connect(sourceMdot.flangeB, condenser.inlet_fl1)
                                                   annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                    annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl2, sinkP1.flangeB)
                                                annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl1, tank_pL.InFlow)
                                                annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl1, sinkP2.flangeB) annotation (Line(
        points={{11,-52},{43.6,-52}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
        points={{-9,-52},{-40,-52},{-40,-35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
        points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
        points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step6;

  model step7

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.044,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p=1600000,
      T_0=345.15)
      annotation (Placement(transformation(extent={{68,14},{48,34}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.55,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP2(redeclare package
        Medium = ThermoCycle.Media.R407c_CP,
                                          p0=1650000)
      annotation (Placement(transformation(extent={{66,-10},{86,10}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_wf=0.044,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
      A_sf=20,
      Unom_sf=100,
      Mdotnom_sf=0.76,
      pstart_wf=460000,
      Tstart_inlet_wf=263.15,
      Tstart_outlet_wf=277.15,
      Tstart_inlet_sf=280.15,
      Tstart_outlet_sf=273.15)
      annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa,
      Mdot_0=1.76,
      T_0=273.15)
      annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
        Medium = Modelica.Media.Air.DryAirNasa)
      annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                              compressor(
      epsilon_v=0.9,
      V_s=50e-6,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      p_su_start=380000,
      p_ex_start=1650000,
      T_su_start=278.15) annotation (Placement(transformation(
          extent={{-12,-12},{12,12}},
          rotation=180,
          origin={52,-22})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                                 electricDrive
      annotation (Placement(transformation(extent={{28,-32},{8,-12}})));
    Modelica.Blocks.Sources.Ramp ramp(offset=50)
      annotation (Placement(transformation(extent={{-14,-10},{-4,0}})));
  equation
    connect(sourceMdot.flangeB, condenser.inlet_fl1)
                                                   annotation (Line(
        points={{49,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                    annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl2, sinkP1.flangeB)
                                                annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl1, tank_pL.InFlow)
                                                annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
        points={{-9,-52},{-40,-52},{-40,-35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
        points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
        points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(compressor.OutFlow, sinkP2.flangeB) annotation (Line(
        points={{43.4,-18},{42,-18},{42,0},{67.6,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl1, compressor.InFlow) annotation (Line(
        points={{11,-52},{74,-52},{74,-29.8},{58.8,-29.8}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
        points={{26.6,-22},{44,-22}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(ramp.y, electricDrive.f) annotation (Line(
        points={{-3.5,-5},{17.6,-5},{17.6,-12.6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step7;

  model step8

    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.45,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_wf=0.044,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
      A_sf=20,
      Unom_sf=100,
      Mdotnom_sf=0.76,
      pstart_wf=460000,
      Tstart_inlet_wf=263.15,
      Tstart_outlet_wf=277.15,
      Tstart_inlet_sf=280.15,
      Tstart_outlet_sf=273.15)
      annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa,
      Mdot_0=1.76,
      T_0=273.15)
      annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
        Medium = Modelica.Media.Air.DryAirNasa)
      annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                              compressor(
      epsilon_v=0.9,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      V_s=85e-6,
      p_su_start=380000,
      p_ex_start=1650000,
      T_su_start=278.15) annotation (Placement(transformation(
          extent={{-19,-18},{19,18}},
          rotation=180,
          origin={59,-16})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                                 electricDrive
      annotation (Placement(transformation(extent={{28,-26},{8,-6}})));
    Modelica.Blocks.Sources.Ramp ramp(offset=50)
      annotation (Placement(transformation(extent={{-14,-2},{-4,8}})));
  equation
    connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                    annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl2, sinkP1.flangeB)
                                                annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl1, tank_pL.InFlow)
                                                annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
        points={{-9,-52},{-40,-52},{-40,-35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
        points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
        points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl1, compressor.InFlow) annotation (Line(
        points={{11,-52},{74,-52},{74,-27.7},{69.7667,-27.7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
        points={{26.6,-16},{36.4667,-16},{36.4667,-16},{46.3333,-16}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(ramp.y, electricDrive.f) annotation (Line(
        points={{-3.5,3},{17.6,3},{17.6,-6.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(compressor.OutFlow, condenser.inlet_fl1) annotation (Line(
        points={{45.3833,-10},{44,-10},{44,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step8;

  model step9

    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=308.15)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.45,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_wf=0.044,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
      A_sf=20,
      Unom_sf=100,
      Mdotnom_sf=0.76,
      pstart_wf=460000,
      Tstart_inlet_wf=263.15,
      Tstart_outlet_wf=277.15,
      Tstart_inlet_sf=280.15,
      Tstart_outlet_sf=273.15)
      annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa,
      Mdot_0=1.76,
      T_0=273.15)
      annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
        Medium = Modelica.Media.Air.DryAirNasa)
      annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                              compressor(
      epsilon_v=0.9,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      V_s=85e-6,
      p_su_start=380000,
      p_ex_start=1650000,
      T_su_start=278.15) annotation (Placement(transformation(
          extent={{-19,-18},{19,18}},
          rotation=180,
          origin={59,-16})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                                 electricDrive
      annotation (Placement(transformation(extent={{28,-26},{8,-6}})));
    Modelica.Blocks.Sources.Ramp ramp(offset=50)
      annotation (Placement(transformation(extent={{-14,-2},{-4,8}})));
    ThermoCycle.Components.Units.PdropAndValves.DP dp_ev(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      UseNom=true,
      Mdot_nom=0.044,
      use_rho_nom=true,
      p_nom=400000,
      T_nom=283.15,
      DELTAp_quad_nom=20000)
      annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
    ThermoCycle.Components.Units.PdropAndValves.DP dp_cd(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      UseNom=true,
      Mdot_nom=0.044,
      use_rho_nom=true,
      p_nom=1650000,
      T_nom=345.15,
      DELTAp_quad_nom=20000)
      annotation (Placement(transformation(extent={{38,14},{18,34}})));
  equation
    connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                    annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl2, sinkP1.flangeB)
                                                annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl1, tank_pL.InFlow)
                                                annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
        points={{-9,-52},{-40,-52},{-40,-35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
        points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
        points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
        points={{26.6,-16},{36.4667,-16},{36.4667,-16},{46.3333,-16}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(ramp.y, electricDrive.f) annotation (Line(
        points={{-3.5,3},{17.6,3},{17.6,-6.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl1, dp_ev.InFlow) annotation (Line(
        points={{11,-52},{31,-52}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dp_ev.OutFlow, compressor.InFlow) annotation (Line(
        points={{49,-52},{69.7667,-52},{69.7667,-27.7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(compressor.OutFlow, dp_cd.InFlow) annotation (Line(
        points={{45.3833,-10},{44,-10},{44,24},{37,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dp_cd.OutFlow, condenser.inlet_fl1) annotation (Line(
        points={{19,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step9;

  model step10

    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc condenser(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      redeclare package Medium2 = ThermoCycle.Media.StandardWater,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_sf=0.52,
      Mdotnom_wf=0.044,
      A_sf=4,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      pstart_wf=1650000,
      Tstart_inlet_wf=345.15,
      Tstart_outlet_wf=308.15,
      Tstart_inlet_sf=303.15,
      Tstart_outlet_sf=303.15,
      steadystate_h_wf=true)
      annotation (Placement(transformation(extent={{10,16},{-16,42}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=0.52,
      T_0=298.15)
      annotation (Placement(transformation(extent={{-66,46},{-46,66}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
        Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{36,44},{56,64}})));
    ThermoCycle.Components.Units.Tanks.Tank_pL tank_pL(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Vtot=0.004,
      pstart=1650000)
      annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
    ThermoCycle.Components.Units.PdropAndValves.Valve valve(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      Mdot_nom=0.044,
      UseNom=false,
      Afull=15e-7,
      Xopen=0.45,
      p_nom=1650000,
      T_nom=308.15,
      DELTAp_nom=1200000)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-40,-26})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DInc evaporator(
      redeclare package Medium1 = ThermoCycle.Media.R407c_CP,
      N=10,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.Constant,
      M_wall=10,
      Mdotnom_wf=0.044,
      A_wf=4,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      V_sf=0.002,
      V_wf=0.002,
      redeclare package Medium2 = Modelica.Media.Air.DryAirNasa,
      A_sf=20,
      Unom_sf=100,
      Mdotnom_sf=0.76,
      steadystate_h_wf=true,
      pstart_wf=500000,
      Tstart_inlet_wf=263.15,
      Tstart_outlet_wf=277.15,
      Tstart_inlet_sf=280.15,
      Tstart_outlet_sf=273.15)
      annotation (Placement(transformation(extent={{-12,-44},{14,-70}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot2(
      redeclare package Medium = Modelica.Media.Air.DryAirNasa,
      Mdot_0=1.76,
      T_0=273.15)
      annotation (Placement(transformation(extent={{48,-90},{28,-70}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP3(redeclare package
        Medium = Modelica.Media.Air.DryAirNasa)
      annotation (Placement(transformation(extent={{-30,-86},{-50,-66}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Compressor
                                                              compressor(
      epsilon_v=0.9,
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      V_s=85e-6,
      p_su_start=380000,
      p_ex_start=1650000,
      T_su_start=278.15) annotation (Placement(transformation(
          extent={{-19,-18},{19,18}},
          rotation=180,
          origin={59,-16})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                                 electricDrive
      annotation (Placement(transformation(extent={{28,-26},{8,-6}})));
    ThermoCycle.Components.Units.PdropAndValves.DP dp_ev(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      UseNom=true,
      Mdot_nom=0.044,
      p_nom=380000,
      T_nom=283.15,
      DELTAp_quad_nom=20000)
      annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
    ThermoCycle.Components.Units.PdropAndValves.DP dp_cd(
      redeclare package Medium = ThermoCycle.Media.R407c_CP,
      UseNom=true,
      Mdot_nom=0.044,
      p_nom=1650000,
      T_nom=345.15,
      DELTAp_quad_nom=20000)
      annotation (Placement(transformation(extent={{38,14},{18,34}})));
    Modelica.Blocks.Sources.Ramp ramp(offset=50,
      height=10,
      duration=2,
      startTime=50)
      annotation (Placement(transformation(extent={{-12,0},{-2,10}})));
    Modelica.Blocks.Sources.Ramp ramp1(
      height=0.1,
      duration=0,
      offset=0.45,
      startTime=75)
      annotation (Placement(transformation(extent={{-82,-32},{-72,-22}})));
  equation
    connect(sourceMdot1.flangeB, condenser.inlet_fl2)
                                                    annotation (Line(
        points={{-47,56},{-32,56},{-32,35},{-12.8,35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl2, sinkP1.flangeB)
                                                annotation (Line(
        points={{6.8,34.8},{24,34.8},{24,54},{37.6,54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.outlet_fl1, tank_pL.InFlow)
                                                annotation (Line(
        points={{-13,24},{-40,24},{-40,14.4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tank_pL.OutFlow, valve.InFlow) annotation (Line(
        points={{-40,-2.8},{-40,-17}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.inlet_fl1, valve.OutFlow) annotation (Line(
        points={{-9,-52},{-40,-52},{-40,-35}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot2.flangeB, evaporator.inlet_fl2) annotation (Line(
        points={{29,-80},{20,-80},{20,-63},{10.8,-63}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl2, sinkP3.flangeB) annotation (Line(
        points={{-8.8,-62.8},{-20,-62.8},{-20,-76},{-31.6,-76}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(electricDrive.shaft, compressor.flange_elc) annotation (Line(
        points={{26.6,-16},{36.4667,-16},{36.4667,-16},{46.3333,-16}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(evaporator.outlet_fl1, dp_ev.InFlow) annotation (Line(
        points={{11,-52},{31,-52}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dp_ev.OutFlow, compressor.InFlow) annotation (Line(
        points={{49,-52},{69.7667,-52},{69.7667,-27.7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(compressor.OutFlow, dp_cd.InFlow) annotation (Line(
        points={{45.3833,-10},{44,-10},{44,24},{37,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dp_cd.OutFlow, condenser.inlet_fl1) annotation (Line(
        points={{19,24},{7,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(ramp.y, electricDrive.f) annotation (Line(
        points={{-1.5,5},{17.6,5},{17.6,-6.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ramp1.y, valve.cmd) annotation (Line(
        points={{-71.5,-27},{-60.75,-27},{-60.75,-26},{-48,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(StopTime=100),
      __Dymola_experimentSetupOutput);
  end step10;
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
