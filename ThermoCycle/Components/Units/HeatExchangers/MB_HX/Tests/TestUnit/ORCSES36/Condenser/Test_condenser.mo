within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestUnit.ORCSES36.Condenser;
model Test_condenser
  replaceable package Medium =ThermoCycle.Media.SES36_CP_Smooth;
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst Condenser(redeclare
      package Medium1 =                                                             Medium,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    counterCurrent=true,
    Unom_l=800,
    Unom_tp=800,
    Unom_v=800,
    N=20,
    Unom_sf=1600,
    steadystate_T_sf=false,
    steadystate_h_wf=true,
    steadystate_T_wall=false,
    Mdotnom_wf=0.3061,
    Mdotnom_sf=1.546,
    pstart_wf=91000,
    Tstart_inlet_wf=305.15,
    Tstart_outlet_wf=296.61,
    Tstart_inlet_sf=295.54,
    Tstart_outlet_sf=303.15)
    annotation (Placement(transformation(extent={{18,18},{-16,-12}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(         redeclare
      package Medium =                                                                         Medium,
    h=14015.5,
    p0=91000)
    annotation (Placement(transformation(extent={{-62,22},{-82,42}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot2(
    Mdot_0=1.546,
    cp=4183,
    rho=1000,
    T_0=295.54)
    annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
                                                                    redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{22,40},{42,60}})));
equation
  connect(sourceCdot2.flange, Condenser.inletSf) annotation (Line(
      points={{-35.8,-30.1},{-26,-30.1},{-26,-4.5},{-16,-4.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sinkP1.flangeB, Condenser.outletWf) annotation (Line(
      points={{-63.6,32},{-42,32},{-42,10.5},{-16,10.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, Condenser.inletWf) annotation (Line(
      points={{41,50},{44,50},{44,48},{48,48},{48,10.5},{18,10.5}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Test_condenser;
