within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step4

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    h_0=281455,
    UseT=true,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p=2357000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-102,22},{-82,42}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245fa_CP,
    steadystate_T_sf=false,
    steadystate_h_wf=false,
    steadystate_T_wall=false,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.VaporQualityDependance)
    annotation (Placement(transformation(extent={{-40,30},{-8,68}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot  source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-30,78},{-10,98}})));
  ThermoCycle.Components.Units.PdropAndValves.DP dP(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    constinit=false,
    UseHomotopy=false,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150,
    use_rho_nom=false)
    annotation (Placement(transformation(extent={{14,26},{34,46}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Expander
                                                          expander(
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.ORCNext,
    V_s=1,
    constPinit=false,
    constinit=false,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    p_su_start=2357000,
    p_ex_start=153400,
    T_su_start=413.15)
    annotation (Placement(transformation(extent={{40,0},{72,32}})));
  Modelica.Blocks.Sources.Ramp N_rot(
    startTime=50,
    duration=0,
    height=0,
    offset=48.25)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,64})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive
                                                               generatorNext(Np=1)
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
 ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare package
      Medium = ThermoCycle.Media.R245fa_CP,  p0=153400)
    annotation (Placement(transformation(extent={{72,-26},{92,-6}})));
equation
  connect(sourceWF.flangeB, hx1DConst.inletWf)
                                             annotation (Line(
      points={{-83,32},{-76,32},{-76,30},{-66,30},{-66,39.5},{-40,39.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-11.8,87.9},{26,87.9},{26,58.5},{-8,58.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dP.InFlow) annotation (Line(
      points={{-8,39.5},{4,39.5},{4,36},{15,36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.flange_elc,generatorNext. shaft) annotation (Line(
      points={{66.6667,17.3333},{76.4,17.3333},{76.4,20},{95.4,20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(N_rot.y,generatorNext. f) annotation (Line(
      points={{83,64},{104.4,64},{104.4,29.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dP.OutFlow, expander.InFlow) annotation (Line(
      points={{33,36},{46.9333,36},{46.9333,22.1333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, sinkPFluid.flangeB) annotation (Line(
      points={{68,8},{68,-5.8},{73.6,-5.8},{73.6,-16}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput);
end step4;
