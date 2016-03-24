within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Evaporator;
model EvaGeneral
 replaceable package Medium =
      ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
                                           annotation (choicesAllMatching=true);

/* Components */
  Cells.OnePhase volumeSC(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartSC,
    lstart=lstartSC,
    Mdotnom=Mdotnom,
    Unom=UnomSC,
    AA=AA,
    alone=false,
    YY=YY,
    eps_NTU=eps_NTU,
    Ltotal=Ltotal,
    subcooled=true)
    annotation (Placement(transformation(extent={{-48,-12},{-28,8}})));
  Cells.TwoPhase volumeTP(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartTP,
    lstart=lstartTP,
    Mdotnom=Mdotnom,
    Unom=UnomTP,
    AA=AA,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    General=true,
    Flooded=true,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{6,-12},{26,8}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare final package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(  redeclare final package Medium
      =                                                                           Medium)
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Cells.OnePhase volumeSH(
    redeclare final package Medium = Medium,
    AA=AA,
    Mdotnom=Mdotnom,
    Unom=UnomSH,
    pstart=pstart,
    hstart=hstartSH,
    lstart=lstartSH,
    subcooled=false,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    eps_NTU=eps_NTU)
    annotation (Placement(transformation(extent={{48,-12},{68,8}})));

  Interfaces.MbOut mbOut[nCV]
    annotation (Placement(transformation(extent={{-28,34},{24,50}})));

import ThermoCycle.Components.Units.HeatExchangers.MB_HX.Records;

/* Parameters */
final parameter Integer  nCV= 3;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

    /* Heat transfer */
parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.MassFlowRate Mdotnom=0.5 "Nominal fluid flow rate"
                              annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomSC=2500 annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomTP=9000 annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomSH=3000 annotation (Dialog(group = "Heat transfer"));

/* Initial values */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSC=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SH:Start value of length"
    annotation (Dialog(tab="Initialization"));

parameter Medium.SpecificEnthalpy hstartSC=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartSH=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));

Records.Mode mode[nCV];
/* Summary Class variables */
  Modelica.SIunits.Temperature[9] Temp;
  Modelica.SIunits.Length[9] length;
  Modelica.SIunits.Power[nCV] q_dot;
  Modelica.SIunits.Power qtot;
equation
  volumeSC.mode = mode[nCV-2];
  volumeTP.mode = mode[nCV-1];
  volumeSH.mode = mode[nCV];

  mode[nCV - 2] = Constants.ModeCompound;
  mode[nCV - 1] = Constants.ModeCompound;
  mode[nCV] = Constants.ModeCompound;
  /* Geometric constraints */
  volumeSC.ll + volumeTP.ll + volumeSH.ll = Ltotal;
  volumeSC.la = 0;

   volumeSC.lb = volumeTP.la;
   volumeTP.lb = volumeSH.la;

/* Equations for  SummaryClass variables*/
for i in 1:3 loop
  Temp[i] =  volumeSC.Temp[i];
  length[i] = volumeSC.length[i];
end for;
for i in 4:6 loop
  Temp[i] =  volumeTP.Temp[i-3];
  length[i] = volumeTP.length[i-3];
end for;
  for i in 7:9 loop
   Temp[i] = volumeSH.Temp[i-6];
   length[i] = volumeSH.length[i-6];
  end for;

   q_dot[1] = volumeSC.q_dot;
   q_dot[2] = volumeTP.q_dot;
   q_dot[3] = volumeSH.q_dot;
   qtot = sum(q_dot[:]);
public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[9] T_cell;
     end Arrays;
     Modelica.SIunits.Length[9] l_cell;
     Modelica.SIunits.Power[3] Qflow;
     Modelica.SIunits.Power Qtot;
  end SummaryClass;
  SummaryClass Summary(T_profile(T_cell = Temp[:]),l_cell = length[:],Qflow=q_dot[:],Qtot=qtot);

equation
  connect(InFlow, volumeSC.inFlow) annotation (Line(
      points={{-102,2},{-76,2},{-76,-2},{-48,-2}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(volumeSC.outFlow, volumeTP.inFlow) annotation (Line(
      points={{-28,-1.9},{-8,-1.9},{-8,-2},{6,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSC.mbOut, mbOut[1]) annotation (Line(
      points={{-38,7},{-38,22},{-19.3333,22},{-19.3333,42}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeTP.mbOut, mbOut[2]) annotation (Line(
      points={{16,7},{16,24},{-2,24},{-2,42}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeTP.outFlow,volumeSH. inFlow) annotation (Line(
      points={{26,-1.9},{34,-1.9},{34,-2},{48,-2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.outFlow,OutFlow)  annotation (Line(
      points={{68,-1.9},{80,-1.9},{80,0},{82,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.mbOut, mbOut[3]) annotation (Line(
      points={{58,7},{58,30},{10,30},{10,42},{15.3333,42}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-20},
            {80,40}}),  graphics),Icon(coordinateSystem(extent={{-100,-20},{80,40}},
                   preserveAspectRatio=true),
                                     graphics={
                               Bitmap(extent={{-102,106},{80,-88}}, fileName="modelica://ThermoCycle/Resources/Images/MB/Eva_G_wf.png")}));
end EvaGeneral;
