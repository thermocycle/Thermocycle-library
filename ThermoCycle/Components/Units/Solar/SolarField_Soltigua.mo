within ThermoCycle.Components.Units.Solar;
model SolarField_Soltigua "Solar field model with Soltigua collector"
replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                           constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/********************* PARAMETERS *******************************************************************/
constant Real  pi = Modelica.Constants.pi;

/********************* GEOMETRIES *********************/
parameter Integer N(min=1) = 2 "Number of cells per collector";
parameter Integer Ns(min=1) = 1 "Number of Collector in series";
parameter Integer Nt(min=1) = 1 "Number of collectors in parallel";

/*********************  Parameters for Defocusing *********************/
parameter Real Def = 25
    "Percentage value of the SF surface that goes to defocusing (25-50-75)"                     annotation(Dialog(group="DEFOCUSING", tab="General"));
/*********************  Parameters for convective heat transfer in the fluid *********************/

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.MassFlowRate Mdotnom "Total nominal Mass flow";
// Fluid initial values
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector" annotation (Dialog(tab="Initialization"));

final parameter Modelica.SIunits.Temperature[Ns] Tstart_inlet_collector =  ThermoCycle.Functions.Solar.T_start_inlet(T_start_inlet=Tstart_inlet,T_start_outlet=Tstart_outlet,Ns=Ns);

final parameter Modelica.SIunits.Temperature[Ns] Tstart_outlet_collector = ThermoCycle.Functions.Solar.T_start_outlet(T_start_inlet=Tstart_inlet,T_start_outlet=Tstart_outlet,Ns=Ns);

parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
/*steady state */
parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Initialization options", tab="Initialization"));
/*********************************   NUMERICAL OPTION  *************************************************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));

/****************** GEOMETRY  *********************/
inner replaceable parameter
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.BaseGeometry
                                                                                        CollectorGeometry
constrainedby
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua.BaseGeometry
                                                                                       annotation (choicesAllMatching=true);

/*************************** HEAT TRANSFER ************************************/
/*Secondary fluid*/
replaceable model FluidHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

/******************************************  COMPONENTS *********************************************************/

 ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSoltigua[Ns] SolarAbsorber(each N=N, each geometry=CollectorGeometry, each Defocusing = Def)
    annotation (Placement(transformation(extent={{-24,6},{14,40}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-86,60},{-46,100}}),
        iconTransformation(extent={{-15,-15},{15,15}},
        rotation=0,
        origin={-69,95})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-88,20},{-48,60}}),
        iconTransformation(extent={{-15,-15},{15,15}},
        rotation=0,
        origin={-69,51})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-88,-18},{-48,22}}),
        iconTransformation(extent={{-15,-15},{15,15}},
        rotation=0,
        origin={-69,15})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-86,-54},{-46,-14}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-66,-30})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{12,-112},{32,-92}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,80},{10,100}}),
        iconTransformation(extent={{30,108},{50,128}})));
  Components.FluidFlow.Pipes.Flow1Dim[Ns] flow1Dim(redeclare each package
      Medium =                                                                     Medium1,
  redeclare each final model Flow1DimHeatTransferModel =
        FluidHeatTransferModel,
    each N=N,
    each Nt=Nt,
    each A=CollectorGeometry.A_ext_t,
    each V=CollectorGeometry.V_tube_int,
    each Mdotnom=Mdotnom,
    each Unom_l=Unom_l,
    each Unom_tp=Unom_tp,
    each Unom_v=Unom_v,
    each pstart=pstart,
    Tstart_inlet=Tstart_inlet_collector,
    Tstart_outlet=Tstart_outlet_collector,
    each Mdotconst=Mdotconst,
    each max_der=max_der,
    each filter_dMdt=filter_dMdt,
    each max_drhodt=max_drhodt,
    each TT=TT,
    each steadystate=steadystate_T_fl,
    each Discretization=Discretization)
                                  annotation (Placement(transformation(
        extent={{-27.5,-31.5},{27.5,31.5}},
        rotation=90,
        origin={44.5,23.5})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-72,-76},{-64,-68}})));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger
    annotation (Placement(transformation(extent={{-50,-60},{-40,-50}})));
  Modelica.Blocks.Interfaces.BooleanInput Defocusing
    annotation (Placement(transformation(extent={{-128,-92},{-88,-52}}),
        iconTransformation(extent={{-82,-96},{-42,-56}})));

public
  record SummaryBase
    replaceable Arrays T_profile;
    record Arrays
     parameter Integer n;
     parameter Integer Ns;
     Modelica.SIunits.Temperature[Ns,n] T_fluid;
    end Arrays;
    Real Eta_solarCollector "Total efficiency of solar collector";
    Modelica.SIunits.Power Q_htf
      "Total heat through the termal heat transfer fluid flowing in the solar collector";
  end SummaryBase;
  replaceable record SummaryClass = SummaryBase;
  SummaryClass Summary( T_profile( n=N, Ns=Ns,T_fluid = T_fluid_),Eta_solarCollector=Eta_tot,Q_htf = Q_tot);
protected
   Modelica.SIunits.Temperature T_fluid_[Ns,N];
  //,Eta_solarCollector= absorberSchott.Eta_TOT,Philoss = absorberSchott.Phi_loss_ref_m,Q_htf = flow1Dim.Q_tot);
 Real Eta_tot "Total efficiency";
 Modelica.SIunits.HeatFlowRate Q_tot
    "Total thermal energy flow on the tube from the sun [W]";
equation
   for i in 1:Ns loop
     for k in 1:N loop
     T_fluid_[i,k] = flow1Dim[i].Cells[k].T;
     end for;
   end for;
Eta_tot = sum(SolarAbsorber[:].Eta_tot)/Ns;
Q_tot = sum(flow1Dim[:].Q_tot) "Total power absorbed by the fluid";

for i in 1:Ns loop
     connect(Theta, SolarAbsorber[i].Theta) annotation (Line(
      points={{-68,40},{-52,40},{-52,38},{-42,38},{-42,30.65},{-21.91,30.65}},
      color={0,0,127},
      smooth=Smooth.None));
           connect(v_wind, SolarAbsorber[i].v_wind) annotation (Line(
      points={{-66,80},{-50,80},{-50,78},{-36,78},{-36,37.45},{-21.91,37.45}},
      color={0,0,127},
      smooth=Smooth.None));
     connect(SolarAbsorber[i].wall_int, flow1Dim[i].Wall_int) annotation (Line(
      points={{12.1,23},{20.5,23},{20.5,23.5},{31.375,23.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tamb, SolarAbsorber[i].Tamb) annotation (Line(
      points={{-68,2},{-56,2},{-56,4},{-42,4},{-42,24.36},{-22.1,24.36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DNI, SolarAbsorber[i].DNI) annotation (Line(
      points={{-66,-34},{-52,-34},{-52,-32},{-32,-32},{-32,17.73},{-21.53,17.73}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(booleanToInteger.y, SolarAbsorber[i].Focusing) annotation (Line(
      points={{-39.5,-55},{-24,-55},{-24,8.38}},
      color={255,127,0},
      smooth=Smooth.None));

end for;

    for i in 1: Ns - 1 loop
  connect(flow1Dim[i].OutFlow,flow1Dim[i+1].InFlow);
end for;

  connect(OutFlow, flow1Dim[Ns].OutFlow) annotation (Line(
      points={{0,90},{44.2375,90},{44.2375,46.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, flow1Dim[1].InFlow) annotation (Line(
      points={{0,-90},{28,-90},{28,-86},{44.5,-86},{44.5,0.583333}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(Defocusing,not1. u) annotation (Line(
      points={{-108,-72},{-72.8,-72}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y,booleanToInteger. u) annotation (Line(
      points={{-63.6,-72},{-58,-72},{-58,-55},{-51,-55}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanToInteger.y, SolarAbsorber[1].Focusing) annotation (Line(
      points={{-39.5,-55},{-24,-55},{-24,8.38}},
      color={255,127,0},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-80,-100},{100,120}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-80,-100},{100,
            120}},
          preserveAspectRatio=false), graphics={
           Bitmap(extent={{-92,120},{130,-98}},  fileName=
              "modelica://ThermoCycle/Resources/Images/Avatar_SF.jpg"),
                                          Text(
          extent={{-88,118},{58,94}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-66,-42},{-36,-52}},
          lineColor={0,0,0},
          textString="DNI"),
        Text(
          extent={{-58,2},{-32,-6}},
          lineColor={0,0,0},
          textString="Tamb[K]"),
        Text(
          extent={{-68,36},{-18,28}},
          lineColor={0,0,0},
          textString="Theta[rad]"),
        Text(
          extent={{-58,88},{-26,72}},
          lineColor={0,0,0},
          textString="V_wind [m/s]"),
        Text(
          extent={{-52,-80},{-22,-90}},
          lineColor={0,0,0},
          textString="Defocusing")}),
                                 Documentation(info="<HTML>

<p><big>The <b>SolarField_Soltigua</b> model is based on the same modeling concept of the <a href=\"modelica://ThermoCycle.Components.Units.Solar.SolarField_Forristal\">SolarField_Forristal</a> model.
 <p><big>The dynamic one-dimensional radial energy balance around the heat collector element is represented by the    <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSoltigua\">AbsSoltigua</a> model.
<p><big>In this model the dimensions of the collectors are fixed and the user can choose the configuration of the solar field:
 <ul><li> Nt: Number of collectors in series
 <li> Ns: Number of collectors in parallel
 </ul>
  <p><big>The model allows to defocusing the collectors based on the internal focusing signal.
   <ul>
   <li>Defocusing = 0 --> Net collecting surface for each collector = 41 m²   
   <li> Defocusing =1 --> Net collecting surface for each collector = 2.3 m²
   </ul>
  
 
 
 
 </HTML>"));
end SolarField_Soltigua;
