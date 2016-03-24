within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.Unit;
model EvaGw
replaceable package Medium =
      ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
  /* Components */
  EvaGeneral evaGeneral(
    redeclare package Medium = Medium,
    Ltotal=Ltotal,
    AA=AA,
    YY=YY,
    Mdotnom=Mdotnom,
    UnomTP=UnomTP,
    UnomSH=UnomSH,
    hstartSC=hstartSC,
    lstartSC=lstartSC,
    hstartTP=hstartTP,
    hstartSH=hstartSH,
    lstartTP=lstartTP,
    lstartSH=lstartSH,
    UnomSC=UnomSC,
    pstart=pstart,
    eps_NTU=epsNTU_pf,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{-40,-100},{42,-72}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    DTstart=DTstartsf,
    n=nCV,
    Usf=Unomsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-38,60},{42,100}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{-110,-54},{-90,-34}}),
        iconTransformation(extent={{-110,-54},{-90,-34}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{78,-52},{98,-32}}),
        iconTransformation(extent={{78,-52},{98,-32}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot
    InFlowSF annotation (Placement(
        transformation(extent={{74,68},{94,84}}), iconTransformation(extent={{
            74,68},{94,84}})));
  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Wall.wall Wall(
    cp_w=cpw,
    L_total=Ltotal,
    M_w=Mw,
    TstartWall=TstartWall)
    annotation (Placement(transformation(extent={{-36,-14},{42,6}})));

           /* GEOMETRIES */
 final parameter Integer  nCV= 3;
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
    parameter Modelica.SIunits.Mass Mw "Total mass of the wall" annotation(Dialog(group="Metal Wall",__Dymola_label="Mass wall:"));

  /* BOOLEAN */
parameter Boolean epsNTU_sf = false "SF-wall :If True use eps-NTU " annotation (Dialog(group = "Heat transfer"));
parameter Boolean epsNTU_pf = false "PF-wall :If True use eps-NTU  " annotation (Dialog(group = "Heat transfer"));
parameter Boolean counterCurrent = true
    "If true countercurrent - PARALLEL FLOW NOT STABLE";

/* HEAT TRANSFER */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSC=2500
    "SC - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));

    /* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSH=1E5 "SH: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SH:Start value of length"
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
    annotation (Placement(transformation(extent={{-110,64},{-90,84}}),
        iconTransformation(extent={{-110,64},{-90,84}})));
equation
  connect(secondaryFluid.InFlow_sf, InFlowSF)
    annotation (Line(
      points={{38,80},{62,80},{62,76},{84,76}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(Wall.QmbIn, evaGeneral.mbOut)
    annotation (Line(
      points={{3,-15},{3,-32},{4.64444,-32},{4.64444,-71.0667}},
      color={0,0,255},
      smooth=Smooth.None));

if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
end if;

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0,0};
  end if;
  if SteadyStatePF then
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
    der(evaGeneral.volumeSH.h_b) = 0;
  end if;
  if Set_h_pf_out then
    evaGeneral.volumeSH.h_b = h_pf_out;
  end if;

public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[9] Twf;
     Modelica.SIunits.Temperature[9] Twall;
     Modelica.SIunits.Temperature[9] Tsf;
     end Arrays;
     Modelica.SIunits.Length[9] l_cell;
     Modelica.SIunits.Power Qwf;
     Modelica.SIunits.Power Qsf;
  end SummaryClass;
  SummaryClass Summary(T_profile(Twf = evaGeneral.Summary.T_profile.T_cell[:],Twall= Wall.Summary.T_profile.T_cell[:], Tsf = secondaryFluid.Summary.T_profile.T_cell[end:-1:1]),l_cell = evaGeneral.Summary.l_cell[:],Qwf = evaGeneral.Summary.Qtot,Qsf = secondaryFluid.Summary.Qtot);
  // Eva_G.PNG
equation
  connect(InFlowPF, evaGeneral.InFlow) annotation (Line(
      points={{-100,-44},{-58,-44},{-58,-89.7333},{-40.9111,-89.7333}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, OutFlowPF) annotation (Line(
      points={{42.9111,-90.6667},{64,-90.6667},{64,-42},{88,-42}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(OutFlowSF, secondaryFluid.OutFlow_sf) annotation (Line(
      points={{-100,74},{-68,74},{-68,80},{-34,80}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics),Icon(coordinateSystem(extent={{-100,
            -60},{80,80}},
                   preserveAspectRatio=false),
                                     graphics={
                               Bitmap(extent={{-102,116},{88,-88}}, fileName="modelica://ThermoCycle/Resources/Images/MB/Eva_G.png")}));
end EvaGw;
