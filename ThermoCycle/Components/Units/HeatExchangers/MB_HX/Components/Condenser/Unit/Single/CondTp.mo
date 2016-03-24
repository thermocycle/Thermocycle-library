within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Condenser.Unit.Single;
model CondTp
replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

    /* Components */
  ThermoCycle.Interfaces.Fluid.FlangeA InflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutflowPF(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{88,-70},{108,-50}})));
  SecondaryFluid.SecondaryFluid secondaryFluid(
    Usf=Unomsf,
    AA=AA,
    YY=YY,
    L_total=Ltotal,
    Tstart=Tstartsf,
    n=nCV,
    DTstart=DTstartsf,
    eps_NTU=epsNTU_sf)
    annotation (Placement(transformation(extent={{-34,60},{30,100}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlowSF
    annotation (Placement(transformation(extent={{86,50},{106,70}})));
ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Wall.wall Wall(
    L_total=Ltotal,
    cp_w=cpw,
    M_w=Mw,
    TstartWall=TstartWall,
    n=1) annotation (Placement(transformation(extent={{-18,-24},{20,20}})));
  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Cells.TwoPhase TwoPhase(
    redeclare package Medium = Medium,
    AA=AA,
    YY=YY,
    Ltotal=Ltotal,
    VoidFraction=VoidFraction,
    VoidF=VoidF,
    Mdotnom=Mdotnom,
    Unom=Unom,
    pstart=pstart,
    hstart=hstart,
    lstart=lstart)
    annotation (Placement(transformation(extent={{-12,-88},{8,-68}})));
/* GEOMETRIES */
 final parameter Integer  nCV= 1;
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

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=9000
    "TP - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unomsf=1000
    "SF - Nominal heat transfer coefficient"                                                annotation (Dialog(group = "Heat transfer"));
/* INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstart=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstart=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));

    /* initialization wall */
parameter Modelica.SIunits.Temperature TstartWall[nCV]
    "Start temperature of the wall"                                                        annotation (Dialog(tab="Initialization",group= "Wall"));
parameter Boolean SteadyStateWall = false
    "If true set Twall to zero during initialization"                                      annotation (Dialog(tab="Initialization",group= "Wall"));

    /* initialization secondary fluid */
parameter Modelica.SIunits.Temperature Tstartsf
    "Start value for average temperature of inlet cell" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));
parameter Modelica.SIunits.Temperature DTstartsf
    "Delta T to initialize second and third volume average temperature" annotation (Dialog(tab="Initialization",group= "Secondary fluid"));

    /* Steady state working fluid */
parameter Medium.SpecificEnthalpy h_pf_out = 1E5
    "Outlet enthalpy of the primary fluid"                                                 annotation(Dialog(tab="Initialization", enable= Set_h_pf_out, group= "Primary fluid"));
parameter Boolean SteadyStatePF = false
    "If true set length and h_out derivative of PF to zero"                                     annotation(Dialog(tab="Initialization",group= "Primary fluid"));
parameter Boolean Set_h_pf_out = false
    "If true set PF outlet enthalpy during initialization equal to h_pf_out"                annotation(Dialog(tab="Initialization",group= "Primary fluid"));

equation
    /* If statement to allow parallel or counter current structure*/
    if counterCurrent then
connect( Wall.QmbOut, secondaryFluid.mbIn[nCV:-1:1]);
else
  connect(Wall.QmbOut, secondaryFluid.mbIn);
    end if;

  connect(secondaryFluid.InFlow_sf, InFlowSF) annotation (Line(
      points={{26.8,80},{60,80},{60,60},{96,60}},
      color={255,0,0},
      smooth=Smooth.None));

initial equation
  if SteadyStateWall then
    der(Wall.Tw) = {0,0};
  end if;
if SteadyStatePF then
    der(TwoPhase.ll) = 0;
    der(TwoPhase.h_b) = 0;
  end if;
  if Set_h_pf_out then
    TwoPhase.h_b = h_pf_out;
  end if;

equation
  connect(InflowPF, TwoPhase.inFlow) annotation (Line(
      points={{-100,-60},{-58,-60},{-58,-78},{-12,-78}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(TwoPhase.outFlow, OutflowPF) annotation (Line(
      points={{8,-77.9},{50,-77.9},{50,-60},{98,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Wall.QmbIn[1], TwoPhase.mbOut) annotation (Line(
      points={{-0.52,-21.8},{-0.52,-44},{-2,-44},{-2,-69}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                        graphics));
end CondTp;
