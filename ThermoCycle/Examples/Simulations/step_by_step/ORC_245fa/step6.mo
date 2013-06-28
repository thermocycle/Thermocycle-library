within ThermoCycle.Examples.Simulations.step_by_step.ORC_245fa;
model step6

 ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    p=2357000,
    UseT=false,
    T_0=353.15,
    h_0=2.49E5)
    annotation (Placement(transformation(extent={{-76,-70},{-56,-50}})));
ThermoCycle.Components.Units.HeatExchangers.Hx1DConst hx1DConst(
    N=10,
    redeclare package Medium1 = ThermoCycle.Media.R245faCool,
    steadystate_T_sf=false,
    steadystate_h_wf=false,
    steadystate_T_wall=false)
    annotation (Placement(transformation(extent={{-46,28},{-12,60}})));
ThermoCycle.Components.FluidFlow.Reservoirs.Source_Cdot2 source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-30,78},{-10,98}})));
 ThermoCycle.Components.Units.PdropAndValves.DP dp_hp(
    A=(2*137*77609.9)^(-0.5),
    k=11857.8*137,
    Mdot_nom=0.2588,
    t_init=500,
    redeclare package Medium = ThermoCycle.Media.R245faCool,
    constinit=false,
    UseHomotopy=false,
    p_nom=2357000,
    T_nom=413.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150,
    use_rho_nom=true)
    annotation (Placement(transformation(extent={{14,26},{34,46}})));
ThermoCycle.Components.Units.ExpandersAndPumps.Expander expander(
    ExpType=ThermoCycle.Functions.Enumerations.ExpTypes.ORCNext,
    V_s=1,
    p_su_start=2357000,
    p_ex_start=153400,
    T_su_start=413.15,
    constPinit=false,
    constinit=false)
    annotation (Placement(transformation(extent={{40,0},{72,32}})));
  Modelica.Blocks.Sources.Ramp N_rot(
    startTime=50,
    duration=0,
    height=0,
    offset=48.25)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,64})));
 ThermoCycle.Components.Units.ExpandersAndPumps.Generator generatorNext(Np=1)
    annotation (Placement(transformation(extent={{94,10},{114,30}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(p0=153400)
    annotation (Placement(transformation(extent={{54,-76},{74,-56}})));
 ThermoCycle.Components.Units.HeatExchangers.HxRec1D recuperator(
    N=10,
    steadystate_h_cold=true,
    steadystate_h_hot=true,
    steadystate_T_wall=true)
    annotation (Placement(transformation(extent={{-16,15},{16,-15}},
        rotation=90,
        origin={1,-22})));
  ThermoCycle.Components.Units.PdropAndValves.DP dp_lp(
    k=38.4E3*9.5,
    A=(2*9.5*23282.7)^(-0.5),
    Mdot_nom=0.2588,
    p_nom=190000,
    T_nom=351.15,
    DELTAp_lin_nom=3000,
    DELTAp_quad_nom=5150,
    use_rho_nom=true)
    annotation (Placement(transformation(extent={{46,-16},{26,4}})));
equation
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{-11.8,87.9},{26,87.9},{26,52},{-12,52}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, dp_hp.InFlow)
                                         annotation (Line(
      points={{-12,36},{15,36}},
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
  connect(dp_hp.OutFlow, expander.InFlow) annotation (Line(
      points={{33,36},{46.9333,36},{46.9333,22.1333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(expander.OutFlow, dp_lp.InFlow) annotation (Line(
      points={{68,8},{68,-6},{45,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl1, sourceWF.flangeB) annotation (Line(
      points={{-4,-32.6667},{-4,-60},{-57,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl2, sinkPFluid.flangeB) annotation (Line(
      points={{6.8,-32.4533},{6.8,-66.2},{55.6,-66.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.inlet_fl2, dp_lp.OutFlow) annotation (Line(
      points={{7,-11.5467},{7,-6},{27,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(recuperator.outlet_fl1, hx1DConst.inletWf) annotation (Line(
      points={{-4,-11.3333},{-4,2},{-66,2},{-66,36},{-46,36}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput);
end step6;
