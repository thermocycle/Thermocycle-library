within ThermoCycle.Components.Units.Solar;
model SolarField_SchottSopo
  "Solar field model with Schott PTR70 or Sopogy solar collector"
replaceable package Medium1 = ThermoCycle.Media.DummyFluid
                                           constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/********************* PARAMETERS *******************************************************************/
constant Real  pi = Modelica.Constants.pi;

/********************* GEOMETRIES *********************/
parameter Integer N(min=1) = 2 "Number of cells per collector";
parameter Integer Ns(min=1) = 1 "Number of Collector in series";
parameter Integer Nt(min=1) = 1 "Number of collectors in parallel";

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
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.BaseGeometry
                                                                                        CollectorGeometry
constrainedby
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.BaseGeometry
                                                                                       annotation (choicesAllMatching=true);

/*************************** HEAT TRANSFER ************************************/
/*Secondary fluid*/
replaceable model FluidHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

/******************************************  COMPONENTS *********************************************************/

  ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSchottSopo[Ns] absorberSchott(each N=N, each geometry=CollectorGeometry)
    annotation (Placement(transformation(extent={{-24,6},{14,40}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-104,58},{-64,98}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=0,
        origin={-66,98})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-100,10},{-60,50}}),
        iconTransformation(extent={{-17,-17},{17,17}},
        rotation=0,
        origin={-65,55})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-102,-22},{-62,18}}),
        iconTransformation(extent={{-19,-19},{19,19}},
        rotation=0,
        origin={-67,7})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-102,-68},{-62,-28}}),
        iconTransformation(extent={{-19,-19},{19,19}},
        rotation=0,
        origin={-65,-51})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{30,-112},{50,-92}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,80},{10,100}}),
        iconTransformation(extent={{30,108},{50,128}})));
  Components.FluidFlow.Pipes.Flow1Dim[Ns] flow1Dim(redeclare each package
      Medium =                                                                     Medium1,
  redeclare each final model Flow1DimHeatTransferModel =
        FluidHeatTransferModel,
    each N=N,
    each Nt=Nt,
    each A=CollectorGeometry.A_int_t,
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
Eta_tot = sum(absorberSchott[:].Eta_TOT)/Ns;
Q_tot = sum(flow1Dim[:].Q_tot) "Total power absorbed by the fluid";

//

    for i in 1:Ns loop
     connect(Theta, absorberSchott[i].Theta) annotation (Line(
      points={{-80,30},{-42,30},{-42,28.61},{-22.29,28.61}},
      color={0,0,127},
      smooth=Smooth.None));
           connect(v_wind, absorberSchott[i].v_wind) annotation (Line(
      points={{-84,78},{-36,78},{-36,37.45},{-21.91,37.45}},
      color={0,0,127},
      smooth=Smooth.None));

     connect(absorberSchott[i].wall_int, flow1Dim[i].Wall_int) annotation (Line(
      points={{12.1,23},{20.5,23},{20.5,23.5},{31.375,23.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tamb, absorberSchott[i].Tamb) annotation (Line(
      points={{-82,-2},{-56,-2},{-56,4},{-42,4},{-42,19.6},{-22.48,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DNI, absorberSchott[i].DNI) annotation (Line(
      points={{-82,-48},{-52,-48},{-52,-32},{-32,-32},{-32,11.27},{-22.29,11.27}},
      color={0,0,127},
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

                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-80,-100},{100,120}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-80,-100},{100,
            120}},
          preserveAspectRatio=false), graphics={
          Bitmap(extent={{-96,118},{126,-100}}, fileName=
              "modelica://ThermoCycle/Resources/Images/Avatar_SF.jpg"),
                                          Text(
          extent={{-80,114},{66,90}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-64,-66},{-34,-76}},
          lineColor={0,0,0},
          textString="DNI"),
        Text(
          extent={{-60,-6},{-34,-14}},
          lineColor={0,0,0},
          textString="Tamb[K]"),
        Text(
          extent={{-72,42},{-22,34}},
          lineColor={0,0,0},
          textString="Theta[rad]"),
        Text(
          extent={{-60,92},{-28,76}},
          lineColor={0,0,0},
          textString="V_wind [m/s]")}),
                                 Documentation(info="<HTML>

<p><big>The <b>SolarField_SchottSopo</b> model is based on the same modeling concept of the <a href=\"modelica://ThermoCycle.Components.Units.Solar.SolarField_Forristal\">SolarField_Forristal</a> model.
 <p><big>In this model the dimensions of the collectors are fixed and the user can choose the configuration of the solar field:
 <ul><li> Nt: Number of collectors in series
 <li> Ns: Number of collectors in parallel
 </ul>
 The dynamic one-dimensional radial energy balance around the heat collector element is based on the Schott test analysis using the  <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSchottSopo\">AbsSchottSopo</a> model.
 </HTML>"));
end SolarField_SchottSopo;
