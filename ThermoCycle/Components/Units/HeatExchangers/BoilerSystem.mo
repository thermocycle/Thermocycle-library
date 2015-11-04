within ThermoCycle.Components.Units.HeatExchangers;
model BoilerSystem

replaceable package Medium_wf = ThermoCycle.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium "Single-phase fluid" annotation (choicesAllMatching=true);

replaceable package Medium_sf =
      ThermoCycle.Media.Incompressible.IncompressibleTables.FlueGas                           constrainedby
    Modelica.Media.Interfaces.PartialMedium "Single-phase fluid" annotation (choicesAllMatching=true);

/*************** Summary profile ******************/

 record SummaryBase
   replaceable Arrays T_profile;
   record Arrays
     parameter Integer n=6;
     Modelica.SIunits.Power[n] Xaxis;
     Modelica.SIunits.Temperature[n] Tsf;
     Modelica.SIunits.Temperature[n] Twall_eco;
     Modelica.SIunits.Temperature[n] Twall_eva;
     Modelica.SIunits.Temperature[n] Twall_sh1;
     Modelica.SIunits.Temperature[n] Twall_sh2;
     Modelica.SIunits.Temperature[n] Twf_1;
     Modelica.SIunits.Temperature[n] Twf_2;
   end Arrays;
     Real p;
     Real level;
     Real Pinch_eco_h;
     Real Pinch_eco_c;
     Real Pinch_eva_h;
     Real Pinch_eva_c;
     Real Pinch_sh1_h;
     Real Pinch_sh1_c;
     Real Pinch_sh2_h;
     Real Pinch_sh2_c;
 end SummaryBase;

 SummaryBase Summary( T_profile(
   n=6,
   Tsf = {ECO.stateOut_hf.T, ECO.stateIn_hf.T, EVA.stateOut_sf.T, SH1.stateOut_hf.T, SH2.stateOut_hf.T, SH2.stateIn_hf.T},
   Twall_eco = {ECO.T_w_1, ECO.T_w_2, 0, 0, 0, 0},
   Twall_eva = {0, 0, EVA.metalWallL.T_wall, EVA.metalWallL.T_wall, 0, 0},
   Twall_sh1 = {0, 0, 0, SH1.T_w_1, SH1.T_w_2, 0},
   Twall_sh2 = {0, 0, 0, 0, SH2.T_w_1, SH2.T_w_2},
   Twf_1 = {ECO.stateIn_cf.T, ECO.stateOut_cf.T, 0, 0, 0, 0},
   Twf_2 = {0, 0, EVA.stateIn_iso.T, EVA.stateOut_iso.T, SH1.stateOut_cf.T, SH2.stateOut_cf.T},
   Xaxis = {0,
             ECO.Q_dot_cf,
             ECO.Q_dot_cf,
             ECO.Q_dot_cf+EVA.Q_dot_iso,
             ECO.Q_dot_cf+EVA.Q_dot_iso+SH1.Q_dot_cf,
             ECO.Q_dot_cf+EVA.Q_dot_iso+SH1.Q_dot_cf+SH2.Q_dot_cf}),
   p=drum.drum_pL.p,
   level = drum.drum_pL.L,
   Pinch_eco_h = ECO.pinch_hf,
   Pinch_eco_c = ECO.pinch_cf,
   Pinch_eva_h = EVA.pinch_sf,
   Pinch_eva_c = EVA.pinch_iso,
   Pinch_sh1_h = SH1.pinch_hf,
   Pinch_sh1_c = SH1.pinch_cf,
   Pinch_sh2_c = SH2.pinch_cf,
   Pinch_sh2_h = SH2.pinch_hf);

/*************** PARAMETERS ******************/
parameter Medium_wf.MassFlowRate Mdot_w_nom=3.3 "Medium_wf nominal flow rate";
parameter Medium_wf.AbsolutePressure DELTAp_eva_nom=0.3e5
    "Nominal pressure drop in the evaporator";
parameter Medium_wf.AbsolutePressure DELTAp_eco_nom = 0.5e5
    "Nominal pressure drop in the ecnomizer";

parameter Medium_wf.AbsolutePressure p_start=42E5
    "Medium_wf pressure in the drum"                                               annotation(Dialog(tab="Initialization"));
parameter Medium_wf.Temperature T_w_su_start = 273.15+50
    "Medium_wf inlet temperature"                                                      annotation(Dialog(tab="Initialization"));
parameter Medium_wf.Temperature T_w_ex_start = 273.15 + 390
    "Medium_wf outlet temperature"                                                     annotation(Dialog(tab="Initialization"));
parameter Medium_wf.Temperature T_w_su_SH2_start= 273.15 + 320
    "Medium_wf temperature after the first superheater"                                                        annotation(Dialog(tab="Initialization"));
parameter Modelica.SIunits.ThermodynamicTemperature pinch_start(displayUnit="K")=15
    "Pinch point temperature difference"                                                                                annotation(Dialog(tab="Initialization"));

parameter Modelica.SIunits.ThermodynamicTemperature DELTAT_approach(displayUnit="K")=10
    "Approach temperature difference between the economizer and the drum"                                                                                     annotation(Dialog(tab="Initialization"));
parameter Real x_ex_ev_nom=0.32 "Vapor quality at the outlet of the evaporator"
                                                                                  annotation(Dialog(tab="Initialization"));
parameter Medium_sf.Temperature T_sf_su_start=273.15+400
    "Secondary fluid inlet temperature"                                                      annotation(Dialog(tab="Initialization"));

 /***************  VARIABLES ******************/
    Modelica.SIunits.Power Q_dot_tot "Boiler's power";

ThermoCycle.Components.Units.HeatExchangers.HX_twophase_pT EVA(
    redeclare package Medium_iso = Medium_wf,
    redeclare package Medium_sf = Medium_sf,
    steadystate_T_wall=false,
    M_wall=500,
    T_sf_su_start=T_sf_su_start - (T_sf_su_start - (Medium_wf.saturationTemperature(
         p_start + DELTAp_eva_nom) + pinch_start))*1/3,
    T_sf_ex_start=Medium_wf.saturationTemperature(p_start + DELTAp_eva_nom) +
        pinch_start,
    T_iso_start=Medium_wf.saturationTemperature(p_start + DELTAp_eva_nom),
    T_w_start=Medium_wf.saturationTemperature(p_start + DELTAp_eva_nom) +
        pinch_start/2,
    A_iso=150,
    A_sf=150,
    U_sf=700,
    U_iso=2000,
    T_wall_fixed=true)
    annotation (Placement(transformation(extent={{-44,-26},{-64,-6}})));
ThermoCycle.Components.Units.HeatExchangers.HX_singlephase_pT SH1(
    redeclare package Medium1 = Medium_wf,
    redeclare package Medium2 = Medium_sf,
    AU_global=4710,
    Use_AU=false,
    M_wall=300,
    U_cf=1000,
    U_hf=1000,
    T_cf_su_start=Medium_wf.saturationTemperature(p_start) + 1,
    T_hf_su_start=T_sf_su_start - (T_sf_su_start - (Medium_wf.saturationTemperature(p_start) + pinch_start))* 1/5,
    T_cf_ex_start=T_w_su_SH2_start,
    T_hf_ex_start=T_sf_su_start - (T_sf_su_start - (Medium_wf.saturationTemperature(p_start) + pinch_start))* 1/3,
    T_wall_fixed=true,
    A_cf=15,
    A_hf=15)
    annotation (Placement(transformation(extent={{-66,24},{-46,44}})));
ThermoCycle.Components.Units.HeatExchangers.HX_singlephase_pT   SH2(
    redeclare package Medium1 = Medium_wf,
    redeclare package Medium2 = Medium_sf,
    AU_global=3422,
    Use_AU=false,
    M_wall=200,
    T_cf_su_start=T_w_su_SH2_start,
    T_cf_ex_start=T_w_ex_start,
    T_hf_su_start=T_sf_su_start,
    T_hf_ex_start=T_sf_su_start - (T_sf_su_start - (Medium_wf.saturationTemperature(p_start) + pinch_start))* 1/5,
    U_hf=800,
    U_cf=600,
    T_wall_fixed=true,
    A_cf=15,
    A_hf=15)
    annotation (Placement(transformation(extent={{-46,48},{-66,68}})));
ThermoCycle.Components.Units.HeatExchangers.HX_singlephase_pT ECO(
    AU_global=27270,
    redeclare package Medium2 = Medium_sf,
    Use_AU=false,
    U_cf=800,
    redeclare package Medium1 = Medium_wf,
    U_hf=1000,
    M_wall=150,
    A_cf=100,
    A_hf=100,
    T_cf_su_start=T_w_su_start,
    T_cf_ex_start=Medium_wf.saturationTemperature(p_start) - 1,
    T_hf_ex_start=T_sf_su_start - (T_sf_su_start - (Medium_wf.saturationTemperature(p_start) + pinch_start))* 6/5,
    T_hf_su_start=Medium_wf.saturationTemperature(p_start) + pinch_start,
    T_wall_fixed=true)
    annotation (Placement(transformation(extent={{-68,-58},{-48,-38}})));
ThermoCycle.Components.Units.Tanks.Boiler_drum drum(
    redeclare package Medium = Medium_wf,
    p_ng=0,
    Vtot=4,
    pstart=p_start)
    annotation (Placement(transformation(extent={{38,-18},{78,22}})));
  ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Pump pump(
    PumpInput=ThermoCycle.Functions.Enumerations.PumpInputs.freq,
    f_pp0=50,
    eta_em=0.98,
    epsilon_v=0.7,
    redeclare package Medium = Medium_wf,
    M_dot_start=Mdot_w_nom/x_ex_ev_nom,
    eta_is=0.7,
    X_pp0=0.5,
    hstart=Medium_wf.dewEnthalpy(Medium_wf.setSat_p(p_start)),
    rhostart=1000,
    V_dot_max=0.015)
    annotation (Placement(transformation(extent={{26,-46},{6,-26}})));
  Modelica.Blocks.Sources.Ramp ramp2(
                                    offset=50,
    duration=2,
    startTime=0,
    height=0)
    annotation (Placement(transformation(extent={{34,-20},{24,-10}})));

  ThermoCycle.Interfaces.Fluid.FlangeA flangeA(redeclare package Medium = Medium_wf)
                                               annotation (Placement(
        transformation(extent={{-98,-58},{-78,-38}}),
                                                    iconTransformation(extent={{54,-96},
            {64,-86}})));
  ThermoCycle.Interfaces.Fluid.FlangeB flangeB(redeclare package Medium = Medium_wf)
                                               annotation (Placement(
        transformation(extent={{-98,46},{-78,66}}),  iconTransformation(extent={{16,90},
            {26,100}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outlet_vs_to_deaerator(redeclare package
      Medium = Medium_wf) annotation (Placement(transformation(extent={{66,38},{86,
            58}}), iconTransformation(extent={{56,14},{66,24}})));
  ThermoCycle.Interfaces.Fluid.FlangeA flangeA1(
                                               redeclare package Medium = Medium_wf)
                                               annotation (Placement(
        transformation(extent={{-26,42},{-6,62}}),  iconTransformation(extent={{70,46},
            {80,56}})));
ThermoCycle.Interfaces.Fluid.FlangeA_pT
             inlet_sf(redeclare package Medium =
        Medium_sf)
    annotation (Placement(transformation(extent={{-76,76},{-56,96}}),
        iconTransformation(extent={{-56,90},{-44,102}})));
ThermoCycle.Interfaces.Fluid.FlangeB_pT
             outlet_sf(redeclare package Medium =
        Medium_sf)
    annotation (Placement(transformation(extent={{-78,-92},{-58,-72}}),
        iconTransformation(extent={{-55,-100},{-45,-90}})));
  ThermoCycle.Components.Units.PdropAndValves.DP DP_eva(
    redeclare package Medium = Medium_wf,
    UseNom=true,
    use_rho_nom=true,
    p_nom=p_start + DELTAp_eva_nom,
    DELTAp_quad_nom=DELTAp_eva_nom,
    rho_nom=x_ex_ev_nom*1000,
    Mdot_nom=Mdot_w_nom/x_ex_ev_nom)
    annotation (Placement(transformation(extent={{-14,-4},{0,10}})));
  ThermoCycle.Components.Units.PdropAndValves.DP DP_eco(
    redeclare package Medium = Medium_wf,
    UseNom=true,
    use_rho_nom=true,
    Mdot_nom=3.28,
    rho_nom=1000,
    DELTAp_quad_nom=DELTAp_eco_nom,
    p_nom=4200000,
    T_nom=353.15)
    annotation (Placement(transformation(extent={{-24,-56},{-10,-42}})));
  Modelica.Blocks.Interfaces.RealOutput level annotation (Placement(
        transformation(extent={{82,2},{102,22}}),  iconTransformation(extent={{98,-22},
            {104,-16}})));
  FluidFlow.Sensors.SensTpSat sensSat(redeclare package Medium = Medium_wf)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation
   Q_dot_tot = ECO.Q_dot_cf + EVA.Q_dot_iso + SH1.Q_dot_cf + SH2.Q_dot_cf;

  connect(SH2.outlet_hf, SH1.inlet_hf) annotation (Line(
      points={{-47,50.6},{-47,41.2}},
      color={170,85,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(SH1.outlet_hf, EVA.inlet_sf) annotation (Line(
      points={{-65,26.6},{-65,-8.8},{-63,-8.8}},
      color={170,85,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(EVA.outlet_sf, ECO.inlet_hf) annotation (Line(
      points={{-45,-23.4},{-45,-31.7},{-49,-31.7},{-49,-40.8}},
      color={170,85,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(ramp2.y,pump. flow_in) annotation (Line(
      points={{23.5,-15},{19.2,-15},{19.2,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(drum.OutFlow_l,pump. InFlow) annotation (Line(
      points={{42.8,-7.6},{40,-7.6},{40,-36},{24,-36},{24,-35.5},{23.2,-35.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SH1.outlet_cf, SH2.inlet_cf) annotation (Line(
      points={{-45,33.8},{-32,33.8},{-32,57.8},{-45,57.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum.OutFlow_v, SH1.inlet_cf) annotation (Line(
      points={{58,20},{-78,20},{-78,33.8},{-67,33.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flangeA, ECO.inlet_cf) annotation (Line(
      points={{-88,-48},{-78,-48},{-78,-48.2},{-69,-48.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flangeB, SH2.outlet_cf) annotation (Line(
      points={{-88,56},{-84,56},{-84,57.8},{-67,57.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flangeA1, SH2.inlet_cf) annotation (Line(
      points={{-16,52},{-32,52},{-32,57.8},{-45,57.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ECO.outlet_hf, outlet_sf) annotation (Line(
      points={{-67,-55.4},{-67,-76.7},{-68,-76.7},{-68,-82}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(inlet_sf, SH2.inlet_hf) annotation (Line(
      points={{-66,86},{-65,86},{-65,65.2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(DP_eco.OutFlow, drum.InFlow_economizer) annotation (Line(
      points={{-10.7,-49},{22,-49},{22,-50},{58,-50},{58,-15.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(drum.level, level) annotation (Line(
      points={{76.8,2},{84,2},{84,12},{92,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ECO.outlet_cf, DP_eco.InFlow) annotation (Line(
      points={{-47,-48.2},{-35.5,-48.2},{-35.5,-49},{-23.3,-49}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.OutFlow, EVA.inlet_iso) annotation (Line(
      points={{10.4,-28.6},{-15.8,-28.6},{-15.8,-16.2},{-43,-16.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(DP_eva.OutFlow, drum.InFlow_evaporator) annotation (Line(
      points={{-0.7,3},{6,3},{6,2},{40,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(outlet_vs_to_deaerator, drum.OutFlow_v) annotation (Line(
      points={{76,48},{66,48},{66,46},{58,46},{58,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(EVA.outlet_iso, sensSat.InFlow) annotation (Line(
      points={{-65,-16.2},{-84,-16.2},{-84,5.2},{-47,5.2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sensSat.OutFlow, DP_eva.InFlow) annotation (Line(
      points={{-33,5.2},{-24,5.2},{-24,3},{-13.3,3}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Ellipse(
          extent={{20,20},{100,-60}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=0,
          endAngle=360,
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Ellipse(
          extent={{20,20},{100,-60}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=180,
          endAngle=360,
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-100,-50},{0,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={170,255,170},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,10},{0,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,128,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,90},{0,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,85,85},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,50},{0,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,85,85},
          fillPattern=FillPattern.HorizontalCylinder),
        Line(
          points={{0,60},{20,60},{20,40},{0,40}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={255,0,0},
          origin={2,60},
          rotation=-90),
        Text(
          extent={{-70,86},{-32,56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0},
          textString="SH2"),
        Text(
          extent={{-69,42},{-31,16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0},
          textString="SH1"),
        Text(
          extent={{-78,-8},{-22,-34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0},
          textString="EVA"),
        Text(
          extent={{-92,-58},{-6,-84}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0},
          textString="ECO"),
        Text(
          extent={{38,4},{84,-26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0},
          textString="drum"),
        Line(
          points={{0,-10},{0,-10},{0,4},{-2.4493e-016,14}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={14,-36},
          rotation=90,
          thickness=0.5),
        Line(
          points={{0,27},{0,27},{0,-27},{0,-27}},
          color={0,0,255},
          smooth=Smooth.None,
          origin={48,50},
          rotation=90,
          thickness=0.5,
          pattern=LinePattern.DashDot),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={0,0,255},
          origin={22,50},
          rotation=-90),
        Line(
          points={{60,20},{60,28},{0,28}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={255,0,0},
          origin={2,28},
          rotation=-90),
        Line(
          points={{-26,-6},{-26,4},{0,4},{-2.4493e-016,14}},
          color={0,128,255},
          smooth=Smooth.None,
          origin={14,0},
          rotation=90,
          thickness=0.5),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={0,128,255},
          origin={2,-36},
          rotation=-90),
        Polygon(
          points={{4,-4},{0,2},{-4,-4},{4,-4}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={0,128,255},
          origin={18,-26},
          rotation=-90),
        Line(
          points={{0,27},{0,27},{3.06162e-016,-32},{-14,-32}},
          color={0,0,255},
          smooth=Smooth.None,
          origin={28,-80},
          rotation=90,
          thickness=0.5),
        Line(
          points={{0,27},{-6.12323e-017,28},{0,-32},{8,-32}},
          color={0,0,255},
          smooth=Smooth.None,
          origin={28,-68},
          rotation=90,
          thickness=0.5),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={0,0,255},
          origin={2,-80},
          rotation=-90),
        Polygon(
          points={{-4,4},{0,-2},{4,4},{-4,4}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={0,0,255},
          origin={60,-60},
          rotation=180),
        Line(
          points={{22,86},{22,74},{0,74}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Polygon(
          points={{4,4},{0,-2},{-4,4},{4,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.None,
          fillColor={255,0,0},
          origin={22,88},
          rotation=180),
        Rectangle(extent={{-100,90},{0,-90}},  lineColor={0,0,0})}),
    experiment(StopTime=30),
    __Dymola_experimentSetupOutput);
end BoilerSystem;
