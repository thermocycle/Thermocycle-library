within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit;
model EvaDw
replaceable package Medium =
     ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  ThermoCycle.Interfaces.Fluid.FlangeA InflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-46},{-90,-26}}),
        iconTransformation(extent={{-110,-46},{-90,-26}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    Usf=Unomsf,
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    n=nCV,
    DTstart=DTstartsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-30,60},{34,100}})));
  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Wall.wall Wall(
    cp_w=cpw,
    L_total=Ltotal,
    M_w=Mw,
    TstartWall=TstartWall,
    n=2) annotation (Placement(transformation(extent={{-18,-24},{22,24}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlowSF
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{90,70},{110,90}})));
            EvaDry evaDry(redeclare package Medium = Medium,
    AA=AA,
    YY=YY,
    Ltotal=Ltotal,
    Mdotnom=Mdotnom,
    UnomSH=UnomSH,
    UnomTP=UnomTP,
    pstart=pstart,
    hstartSH=hstartSH,
    lstartSH=lstartSH,
    hstartTP=hstartTP,
    lstartTP=lstartTP,
    eps_NTU=epsNTU_pf,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
                annotation (Placement(
        transformation(extent={{-24,-98},{38,-60}})));

/* GEOMETRIES */
final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

    /* WALL */
parameter Modelica.SIunits.SpecificHeatCapacity cpw
    "Specific heat capacity (constant)"                                                       annotation(Dialog(group="Metal Wall",__Dymola_label="Cp wall:"));
    parameter Modelica.SIunits.Mass Mw "Total mass flow of the wall" annotation(Dialog(group="Metal Wall",__Dymola_label="Mass wall:"));

  /* BOOLEAN */
parameter Boolean epsNTU_sf = false "SF-wall :If True use eps-NTU " annotation (Dialog(group = "Heat transfer"));
parameter Boolean epsNTU_pf = false "PF-wall :If True use eps-NTU  " annotation (Dialog(group = "Heat transfer"));
parameter Boolean counterCurrent = true
    "If true countercurrent - PARALLEL FLOW NOT STABLE";

    /* HEAT TRANSFER */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=2500
    "SC - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));

    /* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSH=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));

/* initialization wall */
parameter Modelica.SIunits.Temperature TstartWall[nCV]
    "Start temperature of the wall"                                                        annotation (Dialog(tab="Initialization",group= "Wall"));
parameter Boolean SteadyStateWall = false
    "If true set Twall to zero during initialization"                                      annotation (Dialog(tab="Initialization",group= "Wall"));

       /* Steady state working fluid */
parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

    /* initialization secondary fluid */
parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

  ThermoCycle.Interfaces.Fluid.Flange_ex_Cdot OutFlowSF
    annotation (Placement(transformation(extent={{-108,72},{-88,92}}),
        iconTransformation(extent={{-108,72},{-88,92}})));
equation
    /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
end if;
  connect(secondaryFluid.InFlow_sf, InFlowSF) annotation (Line(
      points={{30.8,80},{58,80},{58,80},{100,80}},
      color={255,0,0},
      smooth=Smooth.None));

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0};
  end if;
if SteadyStatePF then
    der(evaDry.volumeTP.ll) = 0;
    der(evaDry.volumeSH.h_b) = 0;
  end if;
  if Set_h_pf_out then
    evaDry.volumeSH.h_b = h_pf_out;
  end if;

public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[6] Twf;
     Modelica.SIunits.Temperature[6] Twall;
     Modelica.SIunits.Temperature[6] Tsf;
     end Arrays;
     Modelica.SIunits.Length[6] l_cell;
     Modelica.SIunits.Power Qwf;
     Modelica.SIunits.Power Qsf;
  end SummaryClass;
  SummaryClass Summary(T_profile(Twf = evaDry.Summary.T_profile.T_cell[:],Twall= Wall.Summary.T_profile.T_cell[:], Tsf = secondaryFluid.Summary.T_profile.T_cell[end:-1:1]),l_cell = evaDry.Summary.l_cell[:],Qwf = evaDry.Summary.Qtot,Qsf = secondaryFluid.Summary.Qtot);

equation
  connect(Wall.QmbIn, evaDry.mbOut) annotation (
      Line(
      points={{2,-26.4},{2,-36},{10.1,-36},{10.1,-56.2}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(InflowPF, evaDry.InFlow) annotation (Line(
      points={{-100,-36},{-60,-36},{-60,-82},{-24.6889,-82},{-24.6889,-84.0667}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaDry.OutFlow, OutflowPF) annotation (Line(
      points={{38.6889,-84.0667},{62,-84.0667},{62,-40},{100,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(secondaryFluid.OutFlow_sf, OutFlowSF) annotation (Line(
      points={{-26.8,80},{-54,80},{-54,82},{-98,82}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                        graphics),Icon(coordinateSystem(extent={{-100,-60},{100,
            100}}, preserveAspectRatio=false),
                                     graphics={
                               Bitmap(extent={{-100,116},{100,-74}},fileName="modelica://ThermoCycle/Resources/Images/MB/Eva_D.PNG")}));
end EvaDw;
