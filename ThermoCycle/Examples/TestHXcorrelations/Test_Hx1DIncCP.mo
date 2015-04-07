within ThermoCycle.Examples.TestHXcorrelations;
model Test_Hx1DIncCP
                     extends Modelica.Icons.Example;

    replaceable package WorkingFluid = ExternalMedia.Media.CoolPropMedium (mediumName=
         "SES36", substanceNames={"SES36|debug=0|calc_transport=1|enable_EXTTP=1|enable_TTSE=0"});
    replaceable package HTFMedium = ExternalMedia.Media.CoolPropMedium (mediumName=
         "T66", substanceNames={"T66|debug=0|calc_transport=1"});

  ThermoCycle.Components.Units.HeatExchangers.Hx1DInc hx1DInc(
    Mdotnom_sf=3.148,
    redeclare package Medium1 = WorkingFluid,
    Mdotnom_wf=0.3335,
    steadystate_h_wf=true,
    N=10,
    Unom_sf=900,
    Unom_l=3000,
    Unom_tp=3600,
    Unom_v=3000,
    redeclare package Medium2 =HTFMedium,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.SmoothedInit (
        redeclare model LiquidCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Constant,
        redeclare model TwoPhaseCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.TwoPhaseCorrelations.Constant,
        redeclare model VapourCorrelation =
            ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations.Constant),
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
    pstart_sf=100000,
    pstart_wf=888343,
    Tstart_inlet_wf=356.26,
    Tstart_outlet_wf=397.75,
    Tstart_inlet_sf=398.15,
    Tstart_outlet_sf=389.45)
    annotation (Placement(transformation(extent={{-38,-24},{24,38}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = WorkingFluid,
    Mdot_0=0.3335,
    UseT=false,
    h_0=84867,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-90,-28},{-70,-8}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = WorkingFluid,
    h=254381,
    p0=888343)
    annotation (Placement(transformation(extent={{68,-48},{88,-28}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
    Mdot_0=3.148,
    redeclare package Medium =
        HTFMedium,
    p=100000,
    T_0=398.15)
    annotation (Placement(transformation(extent={{26,70},{46,90}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(redeclare package
      Medium =
        HTFMedium, p0=
        100000)
    annotation (Placement(transformation(extent={{-54,72},{-36,90}})));
equation
  connect(hx1DInc.outlet_fl1, sinkP.flangeB) annotation (Line(
      points={{16.8462,-4.92308},{40,-4.92308},{40,-38},{69.6,-38}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, hx1DInc.inlet_fl2) annotation (Line(
      points={{45,80},{60,80},{60,21.3077},{16.3692,21.3077}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkP1.flangeB, hx1DInc.outlet_fl2) annotation (Line(
      points={{-52.56,81},{-80,81},{-80,20.8308},{-30.3692,20.8308}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, hx1DInc.inlet_fl1) annotation (Line(
      points={{-71,-18},{-44,-18},{-44,-4.92308},{-30.8462,-4.92308}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Hx1DIncCP;
