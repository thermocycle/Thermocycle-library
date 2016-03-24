within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.TestRecuperator;
model Test_singlePhase
replaceable package Medium = ThermoCycle.Media.SES36_CP;
  MovingBoundaryLibrary.Components.Single.HX_singlephase_pT hX_singlephase_pT(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    A_cf=16.18,
    A_hf=16.18,
    U_cf=3000,
    U_hf=3000,
    p_cf_start=810927,
    p_hf_start=91000,
    T_cf_su_start=297.89,
    T_hf_su_start=367.25,
    T_cf_ex_start=355.27,
    T_hf_ex_start=311.1)
    annotation (Placement(transformation(extent={{-24,-10},{12,34}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=810927,
    T_0=297.89)
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(          redeclare
      package Medium =                                                                         Medium, p0=
       91000)
    annotation (Placement(transformation(extent={{38,-56},{58,-36}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
                                                                    redeclare
      package Medium =                                                                         Medium,
    Mdot_0=0.3061,
    p=91000,
    T_0=367.25)
    annotation (Placement(transformation(extent={{-34,56},{-14,76}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(         redeclare
      package Medium =                                                                         Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{46,2},{66,22}})));
equation
  connect(sourceMdot.flangeB, hX_singlephase_pT.inlet_cf) annotation (Line(
      points={{-61,8},{-44,8},{-44,11.56},{-25.8,11.56}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hX_singlephase_pT.outlet_hf, sinkP.flangeB) annotation (Line(
      points={{-22.2,-4.28},{-22.2,-46},{39.6,-46}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceMdot1.flangeB, hX_singlephase_pT.inlet_hf) annotation (Line(
      points={{-15,66},{10.2,66},{10.2,27.84}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hX_singlephase_pT.outlet_cf, sinkP1.flangeB) annotation (Line(
      points={{13.8,11.56},{30.9,11.56},{30.9,12},{47.6,12}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,120}}), graphics), Icon(coordinateSystem(extent={{-100,-120},
            {100,120}})));
end Test_singlePhase;
