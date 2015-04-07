within ThermoCycle.Examples.TestComponents;
model Test_CrossCondenser

 ThermoCycle.Components.Units.HeatExchangers.CrossCondenser condenser(
    redeclare package Medium1 = Media.WaterIF95_FP,
    N=5,
    c_wall=500,
    steadystate_T_wall=false,
    redeclare package Medium2 = Modelica.Media.Incompressible.Examples.Glycol47,
    Discretization_sf=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    V_sf=1.5,
    A_wf=279.61,
    A_sf=252.09,
    M_wall_tot=2552.13,
    redeclare model Medium2HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence,
    Mdotnom_sf=585176/3600,
    U_wf=9250,
    h_su_wf_start=2.053e6,
    h_ex_wf_start=2.36e5,
    Unom_sf=769,
    Tstart_sf_in=285.84,
    Tstart_sf_out=295.1,
    T_sat_start=329.49,
    T_start_wall=326.65)
    annotation (Placement(transformation(extent={{-24,6},{8,32}})));
  Components.FluidFlow.Reservoirs.SourceMdot             sourceSF(
    UseT=true,
    redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47,
    Mdot_0=585176/3600,
    p=248000,
    T_0=283.15)
    annotation (Placement(transformation(extent={{-66,-2},{-50,14}})));
  Components.FluidFlow.Reservoirs.SinkP             sinkSF(redeclare package
      Medium = Modelica.Media.Incompressible.Examples.Glycol47, p0=248000)
    annotation (Placement(transformation(extent={{-54,22},{-66,34}})));
  Components.FluidFlow.Reservoirs.SourceMdot             source_wf(
    UseT=true,
    redeclare package Medium = Media.WaterIF95_FP,
    Mdot_0=585176/3600,
    p=248000,
    T_0=283.15)
    annotation (Placement(transformation(extent={{-14,52},{2,68}})));
  Components.FluidFlow.Reservoirs.SinkP             sink_wf(
                                                           redeclare package
      Medium = Media.WaterIF95_FP,                   p0=248000)
    annotation (Placement(transformation(extent={{-18,-24},{-30,-12}})));
equation

  connect(sourceSF.flangeB, condenser.InFlow_fl2) annotation (Line(
      points={{-50.8,6},{-36,6},{-36,0},{-20.8,0},{-20.8,12.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sinkSF.flangeB, condenser.OutFlow_fl2) annotation (Line(
      points={{-54.96,28},{-46,28},{-46,40},{-20.8,40},{-20.8,25.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_wf.flangeB, condenser.InFlow_fl1) annotation (Line(
      points={{1.2,60},{10,60},{10,38},{-4.8,38},{-4.8,28.1}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sink_wf.flangeB, condenser.OutFlow_fl1) annotation (Line(
      points={{-18.96,-18},{-14,-18},{-14,-16},{-4.8,-16},{-4.8,9.9}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_CrossCondenser;
