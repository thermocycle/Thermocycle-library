within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator.UnitNoWall;
model EvaG
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
    eps_NTU=epsNTU_pf)
    annotation (Placement(transformation(extent={{-40,-94},{40,-54}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    DTstart=DTstartsf,
    n=nCV,
    Usf=Unomsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-40,60},{40,100}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{-108,-70},{-88,-50}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlowPF(redeclare package Medium =
                                                       Medium)
    annotation (Placement(transformation(extent={{88,-68},{108,-48}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot
    InFlowSF annotation (Placement(
        transformation(extent={{88,50},{108,70}})));

            final parameter Integer  nCV= 3;
/* GEOMETRIES */
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
    /* WALL */

  /* BOOLEAN */
parameter Boolean epsNTU_sf = false "SF-wall :If True use eps-NTU " annotation (Dialog(group = "Heat transfer"));
parameter Boolean epsNTU_pf = false "PF-wall :If True use eps-NTU  " annotation (Dialog(group = "Heat transfer"));
parameter Boolean counterCurrent = true
    "If true countercurrent - PARALLEL FLOW NOT STABLE";

/* INITIAL VALUES */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSC=2500
    "SC - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
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

parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

equation
  connect(secondaryFluid.InFlow_sf, InFlowSF)
    annotation (Line(
      points={{36,80},{80,80},{80,60},{98,60}},
      color={255,0,0},
      smooth=Smooth.None));

if counterCurrent then
connect( evaGeneral.mbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(evaGeneral.mbOut, secondaryFluid.mbIn);
end if;

initial equation
  if SteadyStatePF then
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
    der(evaGeneral.volumeSH.h_b) = 0;
  end if;
  if Set_h_pf_out then
    evaGeneral.volumeSH.h_b = h_pf_out;
  end if;

equation
  connect(InFlowPF, evaGeneral.InFlow) annotation (Line(
      points={{-98,-60},{-88,-60},{-88,-62},{-70,-62},{-70,-73.6},{-40.8,-73.6}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(evaGeneral.OutFlow, OutFlowPF) annotation (Line(
      points={{39.2,-73.6},{68,-73.6},{68,-58},{98,-58}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics));
end EvaG;
