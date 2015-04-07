within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step3

 Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(  Mdot_0=0.2588,
    h_0=281455,
    UseT=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=2357000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1DConst    hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_T_sf=false,
    steadystate_h_wf=false,
    steadystate_T_wall=false,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance)
    annotation (Placement(transformation(extent={{-30,-2},{2,36}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-20,46},{0,66}})));
 ThermoCycle.Components.Units.PdropAndValves.DP dP(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    constinit=false,
    UseHomotopy=false,
    use_rho_nom=false,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150)
    annotation (Placement(transformation(extent={{24,-6},{44,14}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SinkVdot  sinkVdot(
    Vdot_0=1.889e-3,
    h_out=5.04E5,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    pstart=2357000)
    annotation (Placement(transformation(extent={{62,-6},{82,14}})));
equation
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-1.8,55.9},{36,55.9},{36,26.5},{2,26.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dP.InFlow) annotation (Line(
      points={{2,7.5},{14,7.5},{14,4},{25,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dP.OutFlow, sinkVdot.flangeB) annotation (Line(
      points={{43,4},{62.2,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, hx1DConst.inletWf) annotation (Line(
      points={{-73,0},{-62,0},{-62,-4},{-40,-4},{-40,7.5},{-30,7.5}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput);
end step3;
