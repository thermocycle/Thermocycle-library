within ThermoCycle.Components.Units.Solar;
model SolarField_SchottSopo_Inc
  "Solar field model with Schott PTR70 or Sopogy solar collector for incompressible fluids"
replaceable package Medium1 = ThermoCycle.Media.R245fa_CPRP
                                           constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/********************* PARAMETERS *******************************************************************/
constant Real  pi = Modelica.Constants.pi;

/********************* GEOMETRIES *********************/
parameter Integer N(min=1) = 2 "Number of cells per collector";
parameter Integer Ns(min=1) = 1 "Number of Collector in series";
parameter Integer Nt(min=1) = 1 "Number of collectors in parallel";

/*********************  Parameters for convective heat transfer in the fluid *********************/

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=300
    "Coefficient of heat transfer" annotation (Dialog(group="Heat transfer", tab="General"));
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
                                                                                                      annotation (Dialog(group="Intialization options", tab="Initialization"));
/*********************************   NUMERICAL OPTION  *************************************************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

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
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
   constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

/******************************************  COMPONENTS *********************************************************/

  ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSchottSopo[Ns] absorberSchott(each N=N, each geometry=CollectorGeometry)
    annotation (Placement(transformation(extent={{-24,6},{14,40}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-86,60},{-46,100}}),
        iconTransformation(extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={74,92})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-88,20},{-48,60}}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=-90,
        origin={27,93})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-88,-18},{-48,22}}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=-90,
        origin={-23,93})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-86,-54},{-46,-14}}),
        iconTransformation(extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={-68,92})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-108,-8},{-88,12}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,80},{10,100}}),
        iconTransformation(extent={{88,-8},{108,12}})));
  Components.FluidFlow.Pipes.Flow1DimInc[Ns] flow1DimInc(redeclare each package
      Medium =                                                                     Medium1,
  redeclare each final model Flow1DimIncHeatTransferModel =
        FluidHeatTransferModel,
    each N=N,
    each Nt=Nt,
    each A=CollectorGeometry.A_int_t,
    each V=CollectorGeometry.V_tube_int,
    each Mdotnom=Mdotnom,
    each Unom=Unom,
    each pstart=pstart,
    Tstart_inlet=Tstart_inlet_collector,
    Tstart_outlet=Tstart_outlet_collector,
    each steadystate=steadystate_T_fl,
    each Discretization=Discretization)
                                  annotation (Placement(transformation(
        extent={{-27.5,-31.5},{27.5,31.5}},
        rotation=90,
        origin={44.5,23.5})));

/******************************************  SUMMARY *********************************************************/

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
Real Eta_tot "Total efficiency";
Modelica.SIunits.HeatFlowRate Q_tot
    "Total thermal energy flow on the tube from the sun [W]";
equation
  for i in 1:Ns loop
    for k in 1:N loop
    T_fluid_[i,k] = flow1DimInc[i].Cells[k].T;
    end for;
  end for;
Eta_tot = sum(absorberSchott[:].Eta_TOT)/Ns;
Q_tot = sum(flow1DimInc[:].Q_tot)/Ns;

//

    for i in 1:Ns loop
     connect(Theta, absorberSchott[i].Theta) annotation (Line(
      points={{-68,40},{-52,40},{-52,38},{-42,38},{-42,28.61},{-22.29,28.61}},
      color={0,0,127},
      smooth=Smooth.None));
           connect(v_wind, absorberSchott[i].v_wind) annotation (Line(
      points={{-66,80},{-50,80},{-50,78},{-36,78},{-36,37.45},{-21.91,37.45}},
      color={0,0,127},
      smooth=Smooth.None));

     connect(absorberSchott[i].wall_int, flow1DimInc[i].Wall_int) annotation (Line(
      points={{12.1,23},{20.5,23},{20.5,23.5},{31.375,23.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Tamb, absorberSchott[i].Tamb) annotation (Line(
      points={{-68,2},{-56,2},{-56,4},{-42,4},{-42,19.6},{-22.48,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DNI, absorberSchott[i].DNI) annotation (Line(
      points={{-66,-34},{-52,-34},{-52,-32},{-32,-32},{-32,11.27},{-22.29,
          11.27}},
      color={0,0,127},
      smooth=Smooth.None));

    end for;
for i in 1: Ns - 1 loop
  connect(flow1DimInc[i].OutFlow,flow1DimInc[i+1].InFlow);
end for;

  connect(OutFlow, flow1DimInc[Ns].OutFlow) annotation (Line(
      points={{0,90},{44.2375,90},{44.2375,46.4167}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, flow1DimInc[1].InFlow) annotation (Line(
      points={{0,-90},{28,-90},{28,-86},{44.5,-86},{44.5,0.583333}},
      color={0,0,255},
      smooth=Smooth.None));

                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}},
          preserveAspectRatio=true),  graphics={
        Rectangle(
          extent={{-88,82},{88,-88}},
          pattern=LinePattern.Dot,
          lineColor={0,0,0},
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-18},{60,-50}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{8,-18},{38,-50}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,46},{60,14}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{6,46},{36,14}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Text(
          extent={{-80,-72},{66,-96}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Rectangle(
          extent={{-52,50},{-14,18}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-68,50},{-38,18}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-76,32},{68,32}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-76,32},{-76,-32},{-70,-32},{-70,-32}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-90,2},{-76,2},{-76,2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-76,-32},{66,-32}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{68,0},{80,0},{88,0}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Rectangle(
          extent={{-52,-14},{-14,-46}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-66,-14},{-36,-46}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{68,32},{68,-32},{62,-32},{62,-32}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-82,74},{-52,64}},
          lineColor={0,0,0},
          textString="DNI"),
        Text(
          extent={{-34,76},{-8,68}},
          lineColor={0,0,0},
          textString="Tamb[K]"),
        Text(
          extent={{2,76},{52,68}},
          lineColor={0,0,0},
          textString="Theta[rad]"),
        Text(
          extent={{56,80},{88,64}},
          lineColor={0,0,0},
          textString="V_winD [m/s]")}),
                                 Documentation(info="<HTML>

<p><big>The <b>SolarField_SchottSopo_Inc</b> model is based on the same modeling concept of the <a href=\"modelica://ThermoCycle.Components.Units.Solar.SolarField_Forristal_Inc\">SolarField_Forristal_Inc</a> model.
 <p><big>The dynamic one-dimensional radial energy balance around the heat collector element is based on the Schott test analysis using the  <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.AbsSchottSopo\">AbsSchottSopo</a> model.
 </HTML>"));
end SolarField_SchottSopo_Inc;
