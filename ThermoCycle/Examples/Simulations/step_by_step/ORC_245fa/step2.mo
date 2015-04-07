within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step2

 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP  sinkPFluid(redeclare
      package Medium = ThermoCycle.Media.R245fa_CP,  p0=2357000)
    annotation (Placement(transformation(extent={{78,-2},{98,18}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
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
equation
  connect(sourceWF.flangeB, hx1DConst.inletWf)
                                             annotation (Line(
      points={{-73,0},{-66,0},{-66,-2},{-56,-2},{-56,7.5},{-30,7.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-1.8,55.9},{36,55.9},{36,26.5},{2,26.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dP.InFlow) annotation (Line(
      points={{2,7.5},{14,7.5},{14,4},{25,4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dP.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{43,4},{64,4},{64,8},{79.6,8}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput);
end step2;
