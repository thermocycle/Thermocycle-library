within ThermoCycle.Examples.TestComponents;
package Sizing
  extends Modelica.Icons.Package;
  model Sizing_evaporator

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
      Mdot_0=2,
      T_0=653.15,
      cp=2046,
      rho=1000)
      annotation (Placement(transformation(extent={{58,40},{38,60}})));
    ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
      Mdotconst_wf=false,
      steadystate_h_wf=true,
      steadystate_T_wall=true,
      steadystate_T_sf=false,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      N=30,
      redeclare package Medium1 = ThermoCycle.Media.Water,
      V_sf=0.0314159,
      V_wf=0.0314159,
      Unom_sf=20000,
      redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
      Unom_l=3000,
      Unom_tp=10000,
      Unom_v=3000,
      M_wall=9.35E+01,
      c_wall=385,
      Mdotnom_sf=2,
      Mdotnom_wf=0.05,
      Tstart_inlet_wf=510.97 + 50,
      Tstart_outlet_wf=585.97 + 35,
      Tstart_inlet_sf=360 + 273.15,
      pstart_wf=6000000,
      Tstart_outlet_sf=625.15)
      annotation (Placement(transformation(extent={{-28,0},{8,38}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      Mdot_0=0.05,
      redeclare package Medium = ThermoCycle.Media.Water,
      p=6000000,
      UseT=false,
      T_0=356.26,
      h_0=852450)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
        Medium = ThermoCycle.Media.Water, p0=6000000)
      annotation (Placement(transformation(extent={{76,-6},{96,14}})));
    Modelica.Blocks.Sources.Constant Hin(k=852540)
      annotation (Placement(transformation(extent={{-106,24},{-86,44}},
            rotation=0)));
  equation
    connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
        points={{8,28.5},{16,28.5},{16,30},{24,30},{24,49.9},{39.8,49.9}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
        points={{-71,-10},{-66,-10},{-66,6},{-54,6},{-54,9.5},{-28,9.5}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(Hin.y, sourceMdot.in_h) annotation (Line(
        points={{-85,34},{-74,34},{-74,-4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(eva.outletWf, sinkP.flangeB) annotation (Line(
        points={{8,9.5},{46,9.5},{46,4},{77.6,4}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Sizing_evaporator;
end Sizing;
