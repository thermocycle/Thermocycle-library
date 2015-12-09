within ThermoCycle.Components.Units.Tanks;
package HeatStorageWaterHeater
  "Stratified tank with an internal heat exchanger and ambient heat losses (nodal model)"
  model Heat_storage "Stratified tank with ambient heat losses (nodal model)"

  replaceable package MainFluid = ThermoCycle.Media.StandardWater
                                                 constrainedby
      Modelica.Media.Interfaces.PartialMedium "Main fluid"   annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.Length htot=1 "Total height of the tank";
    parameter Modelica.SIunits.Length h1=0.3
      "Height of the bottom of the heat exchanger";
    parameter Modelica.SIunits.Length h2=0.6
      "Height of the top of the heat exchanger";

    parameter Integer N=15 "Total number of cells";
    parameter Integer N1=integer(h1*N/htot)
      "Cell corresponding to the bottom of the heat exchanger";
    parameter Integer N2=integer(h2*N/htot)
      "Cell corresponding to the top of the heat exhcanger";

    parameter Modelica.SIunits.Area A_amb=2
      "Total heat exchange area from the tank to the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.Area A_hx=1
      "Total heat exchanger area from in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.Volume V_tank=0.3 "Total capacity of the tank" annotation(group="Tank");
    parameter Modelica.SIunits.Volume V_hx=0.005
      "Internal volume of the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1
      "Nominal mass flow rate in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_amb=1
      "Heat transfer coefficient between the tank and the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_hx=4000
      "Nominal heat transfer coefficient in the heat exchanger" annotation(group="Heat exchanger");

  parameter Modelica.SIunits.Mass M_wall_hx= 5
      "Mass of the metal wall between the two fluids" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall_hx= 500
      "Specific heat capacity of metal wall" annotation(group="Heat exchanger");

     parameter Boolean FlowReversal = false
      "Allow flow reversal (might complexify the final system of equations)";
   parameter Modelica.SIunits.Pressure pstart_tank=1E5
      "Tank pressure start value"      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_tank=273.15+10
      "Tank inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_tank=273.15+60
      "Tank outlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificEnthalpy hstart_tank[N]=linspace(
          MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_inlet_tank),MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_outlet_tank),
          N) "Start value of enthalpy vector (initialized by default)" annotation (Dialog(tab="Initialization"));

    parameter Modelica.SIunits.Pressure pstart_hx=1E5
      "Heat exchanger pressure start value"
                                       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_hx=273.15+70
      "Heat exchanger inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_hx=273.15+50
      "Heat exchanger outlet temperature start value"
       annotation (Dialog(tab="Initialization"));

    parameter Boolean steadystate_tank=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));
    parameter Boolean steadystate_hx=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));

    Cell1DimInc_2ports cell1DimInc_hx[N](
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
      each Vi=V_tank/N,
      each Mdotnom=1,
      each Unom=U_amb,
      each Unom_hx=Unom_hx,
      each Ai=A_amb/N,
      each pstart=pstart_tank,
      hstart=hstart_tank,
      each A_hx=1/(N2 - N1 + 1),
      each FlowReversal=FlowReversal)
      annotation (Placement(transformation(extent={{-16,-10},{18,24}})));

  public
  record SummaryBase
    replaceable Arrays T_profile;
    record Arrays
     parameter Integer n;
     Real[n] Twf(min=0);
    end Arrays;
  end SummaryBase;
  replaceable record SummaryClass = SummaryBase;
  SummaryClass Summary( T_profile( n=N,Twf = cell1DimInc_hx.T));

  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_ext
      annotation (Placement(transformation(extent={{-14,48},{16,60}}),
          iconTransformation(extent={{-40,-6},{-34,12}})));
    ThermoCycle.Interfaces.Fluid.FlangeA MainFluid_su(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-52,-94},{-32,-74}}),
                     iconTransformation(extent={{-42,-84},{-32,-74}})));
    ThermoCycle.Interfaces.Fluid.FlangeB MainFluid_ex(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-14,72},{6,
              92}}),
          iconTransformation(extent={{-6,80},{6,92}})));
  equation

  /* Connection of the different cell of the tank in series */
    for i in 1:N - 1 loop
      connect(cell1DimInc_hx[i].OutFlow, cell1DimInc_hx[i + 1].InFlow);
    end for;

  /* Connection of the different cell of the tank in series */
    for i in 1:N loop
      connect(Wall_ext,cell1DimInc_hx[i].Wall_int);
    end for;

    connect(MainFluid_su, cell1DimInc_hx[1].InFlow) annotation (Line(
        points={{-42,-84},{-51,-84},{-51,7},{-16,7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(cell1DimInc_hx[N].OutFlow, MainFluid_ex) annotation (Line(
        points={{18,7.17},{68,7.17},{68,82},{-4,82}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Line(
        points={{-0.4,-12.26},{-0.4,-9.445},{-0.08,-9.445},{-0.08,-6.63},{2.32,
            -6.63},{2.32,-1.5}},
        color={255,0,0},
        smooth=Smooth.None), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      experiment(StopTime=5000),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Ellipse(
            extent={{-40,60},{40,88}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-40,72},{40,-84}},
            lineColor={215,215,215},
            fillPattern=FillPattern.Solid,
            fillColor={215,215,215}),
          Line(
            points={{-40,-84},{40,-84},{40,74}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,74},{-40,-84}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,66},{40,66}},
            color={0,0,0},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>Nodal model of a stratified tank, with the following hypotheses:</p>
<ul>
<li>No heat transfer between the different nodes</li>
<li>No internal heat exchange</li>
<li>Incompressible fluid</li>
</ul>
<p><br>The tank is discretized using a modified version of the incompressible Cell1Dim model adding an additional heat port. The heat exchanger is modeled using the Flow1Dim component and a wall component.</p>
</html>"));
  end Heat_storage;

  model Heat_storage_hx
    "Stratified tank with an internal heat exchanger and ambient heat losses (nodal model)"

  replaceable package MainFluid = ThermoCycle.Media.StandardWater
                                                 constrainedby
      Modelica.Media.Interfaces.PartialMedium "Main fluid"   annotation (choicesAllMatching = true);
  replaceable package SecondaryFluid = ThermoCycle.Media.StandardWater
                                                 constrainedby
      Modelica.Media.Interfaces.PartialMedium "Secondary fluid"  annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.Length htot=1 "Total height of the tank";
    parameter Modelica.SIunits.Length h1=0.3
      "Height of the bottom of the heat exchanger";
    parameter Modelica.SIunits.Length h2=0.6
      "Height of the top of the heat exchanger";

    parameter Integer N=15 "Total number of cells";
    parameter Integer N1=integer(h1*N/htot)
      "Cell corresponding to the bottom of the heat exchanger";
    parameter Integer N2=integer(h2*N/htot)
      "Cell corresponding to the top of the heat exhcanger";

    parameter Modelica.SIunits.Area A_amb=2
      "Total heat exchange area from the tank to the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.Area A_hx=1
      "Total heat exchanger area from in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.Volume V_tank=0.3 "Total capacity of the tank" annotation(group="Tank");
    parameter Modelica.SIunits.Volume V_hx=0.005
      "Internal volume of the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1
      "Nominal mass flow rate in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_amb=1
      "Heat transfer coefficient between the tank and the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_hx=4000
      "Nominal heat transfer coefficient in the heat exchanger" annotation(group="Heat exchanger");

  parameter Modelica.SIunits.Mass M_wall_hx= 5
      "Mass of the metal wall between the two fluids" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall_hx= 500
      "Specific heat capacity of metal wall" annotation(group="Heat exchanger");
  parameter Boolean FlowReversal = false
      "Allow flow reversal (might complexify the final system of equations)";
   parameter Modelica.SIunits.Pressure pstart_tank=1E5
      "Tank pressure start value"      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_tank=273.15+10
      "Tank inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_tank=273.15+60
      "Tank outlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificEnthalpy hstart_tank[N]=linspace(
          MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_inlet_tank),MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_outlet_tank),
          N) "Start value of enthalpy vector (initialized by default)" annotation (Dialog(tab="Initialization"));

    parameter Modelica.SIunits.Pressure pstart_hx=1E5
      "Heat exchanger pressure start value"
                                       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_hx=273.15+70
      "Heat exchanger inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_hx=273.15+50
      "Heat exchanger outlet temperature start value"
       annotation (Dialog(tab="Initialization"));

    parameter Boolean steadystate_tank=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));
    parameter Boolean steadystate_hx=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));

    ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc flow1Dim(
      redeclare package Medium = SecondaryFluid,
      A=A_hx,
      V=V_hx,
      Mdotnom=Mdot_nom,
      Unom=Unom_hx,
      steadystate=steadystate_hx,
      N=N2 - N1 + 1,
      pstart=100000,
      Tstart_inlet=363.15,
      Tstart_outlet=343.15)
      annotation (Placement(transformation(extent={{20,-84},{-16,-50}})));
    Cell1DimInc_2ports cell1DimInc_hx[N](
      redeclare package Medium = MainFluid,
      redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
      each Vi=V_tank/N,
      each Mdotnom=1,
      each Unom=U_amb,
      each Unom_hx=Unom_hx,
      each Ai=A_amb/N,
      each pstart=pstart_tank,
      hstart=hstart_tank,
      each A_hx=1/(N2 - N1 + 1),
      each FlowReversal=FlowReversal)
      annotation (Placement(transformation(extent={{-16,-10},{18,24}})));

    ThermoCycle.Interfaces.HeatTransfer.ThermalPortConverter thermalPortConverter(N=N2 - N1
           + 1)
      annotation (Placement(transformation(extent={{-8,-4},{12,-32}})));

    ThermoCycle.Components.HeatFlow.Walls.MetalWall
                                        metalWall(
      Aext=A_hx,
      Aint=A_hx,
      c_wall=c_wall_hx,
      M_wall=M_wall_hx,
      Tstart_wall_1=Tstart_inlet_hx - 5,
      Tstart_wall_end=Tstart_outlet_hx - 5,
      steadystate_T_wall=false,
      N=N2 - N1 + 1)
      annotation (Placement(transformation(extent={{-18,-56},{21,-28}})));

  protected
  Real Tsf_[N](min=0);
  Real Twall_[N](min=0);

  public
  record SummaryBase
    replaceable Arrays T_profile;
    record Arrays
     parameter Integer n;
     Real[n] Tsf(min=0);
     Real[n] Twall(min=0);
     Real[n] Twf(min=0);
    end Arrays;
  end SummaryBase;
  replaceable record SummaryClass = SummaryBase;
  SummaryClass Summary( T_profile( n=N, Tsf = Tsf_,  Twall = Twall_, Twf = cell1DimInc_hx.T));

  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_ext
      annotation (Placement(transformation(extent={{-14,48},{16,60}}),
          iconTransformation(extent={{-40,-6},{-34,12}})));
    ThermoCycle.Interfaces.Fluid.FlangeA MainFluid_su(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-52,-94},{-32,-74}}),
                     iconTransformation(extent={{-42,-84},{-32,-74}})));
    ThermoCycle.Interfaces.Fluid.FlangeB SecondaryFluid_ex(redeclare package
        Medium = SecondaryFluid)
                     annotation (Placement(transformation(extent={{-64,-76},{-44,-56}}),
          iconTransformation(extent={{34,-36},{46,-24}})));
    ThermoCycle.Interfaces.Fluid.FlangeB MainFluid_ex(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-14,72},{6,
              92}}),
          iconTransformation(extent={{-6,80},{6,92}})));
    ThermoCycle.Interfaces.Fluid.FlangeA SecondaryFluid_su(redeclare package
        Medium = SecondaryFluid)
                          annotation (Placement(transformation(extent={{54,-76},{74,
              -56}}),iconTransformation(extent={{34,28},{46,40}})));
  equation

  /* Connection of the different cell of the tank in series */
    for i in 1:N - 1 loop
      connect(cell1DimInc_hx[i].OutFlow, cell1DimInc_hx[i + 1].InFlow);
    end for;

  /* Connection of the different cell of the tank in series */
    for i in 1:N loop
      connect(Wall_ext,cell1DimInc_hx[i].Wall_int);
    end for;

    for i in 1:N1-1 loop
      Tsf_[i]=273.15;
      Twall_[i]=273.15;
    end for;

    for i in 1:(N2 - N1+1) loop
      connect(thermalPortConverter.single[i], cell1DimInc_hx[N1 + i - 1].HXInt);
    end for;

      Tsf_[N1:N2]=flow1Dim.Summary.T[end:-1:1];
      Twall_[N1:N2]=metalWall.T_wall[end:-1:1];

    for i in N2+1:N loop
      Tsf_[i]=273.15;
      Twall_[i]=273.15;
    end for;

    connect(thermalPortConverter.multi, metalWall.Wall_int) annotation (Line(
        points={{2,-22.9},{2,-29.35},{1.5,-29.35},{1.5,-37.8}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(metalWall.Wall_ext, flow1Dim.Wall_int) annotation (Line(
        points={{1.11,-46.2},{1.11,-52.0584},{2,-52.0584},{2,-59.9167}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(MainFluid_su, cell1DimInc_hx[1].InFlow) annotation (Line(
        points={{-42,-84},{-51,-84},{-51,7},{-16,7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(cell1DimInc_hx[N].OutFlow, MainFluid_ex) annotation (Line(
        points={{18,7.17},{68,7.17},{68,82},{-4,82}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(SecondaryFluid_ex, flow1Dim.OutFlow)
                                             annotation (Line(
        points={{-54,-66},{-54,-66.8583},{-13,-66.8583}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flow1Dim.InFlow, SecondaryFluid_su)
                                            annotation (Line(
        points={{17,-67},{60.5,-67},{60.5,-66},{64,-66}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Line(
        points={{-0.4,-12.26},{-0.4,-9.445},{-0.08,-9.445},{-0.08,-6.63},{2.32,
            -6.63},{2.32,-1.5}},
        color={255,0,0},
        smooth=Smooth.None), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      experiment(StopTime=5000),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Ellipse(
            extent={{-40,60},{40,88}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-40,72},{40,-84}},
            lineColor={215,215,215},
            fillPattern=FillPattern.Solid,
            fillColor={215,215,215}),
          Line(
            points={{40,34},{-10,34},{20,22},{-10,12},{20,2},{-8,-10},{22,-20},{-8,
                -32},{38,-32}},
            color={0,0,0},
            smooth=Smooth.None,
            thickness=0.5),
          Line(
            points={{22,-36},{34,-32},{22,-28}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{-40,-84},{40,-84},{40,74}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,74},{-40,-84}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,66},{40,66}},
            color={0,0,0},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>Nodal model of a stratified tank, with the following hypotheses:</p>
<p><ul>
<li>No heat transfer between the different nodes</li>
<li>The internal heat exchanger is discretized in the same way as the tank: each cell of the heat exchanger corresponds to one cell of the tank and exchanges heat with that cell only.</li>
<li>Incompressible fluid in both the tank and the heat exchanger</li>
</ul></p>
<p><br/>The tank is discretized using a modified version of the incompressible Cell1Dim model adding an additional heat port. The heat exchanger is modeled using the Flow1Dim component and a wall component.</p>
</html>"));
  end Heat_storage_hx;

  model Cell1DimInc_2ports
    "1-D incompressible fluid flow model with three thermal ports (two with a heat transfer model)"
    replaceable package Medium = ThermoCycle.Media.StandardWater constrainedby
      Modelica.Media.Interfaces.PartialMedium
      "Medium model - Incompressible Fluid" annotation (choicesAllMatching=true);

    /************ Thermal and fluid ports ***********/
    ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
          Medium) annotation (Placement(transformation(extent={{-100,-10},{-80,
              10}}), iconTransformation(extent={{-120,-20},{-80,20}})));
    ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
          Medium) annotation (Placement(transformation(extent={{80,-10},{100,10}}),
          iconTransformation(extent={{80,-18},{120,20}})));
    ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_int annotation (
        Placement(transformation(extent={{-28,40},{32,60}}), iconTransformation(
            extent={{-40,40},{40,60}})));

    /************ Geometric characteristics **************/
    constant Real pi=Modelica.Constants.pi "pi-greco";
    parameter Modelica.SIunits.Volume Vi "Volume of a single cell";
    parameter Modelica.SIunits.Area Ai "Lateral surface of a single cell";
    parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
    parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom;
    parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_hx
      "Nominal Heat transfer coefficient ";

    parameter Modelica.SIunits.Area A_hx;

    /************ FLUID INITIAL VALUES ***************/
    parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
      annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
      annotation (Dialog(tab="Initialization"));

    /****************** NUMERICAL OPTIONS  ***********************/
    parameter Boolean steadystate=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(group="Initialization options", tab="Initialization"));

    /********************************* HEAT TRANSFER MODEL ********************************/
    /* Heat transfer Model */
    replaceable model HeatTransfer =
        ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
      constrainedby
      ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
      "Convective heat transfer" annotation (choicesAllMatching=true);
    parameter Boolean FlowReversal = false
      "Allow flow reversal (might complexify the final system of equations)";

    HeatTransfer heatTransfer(
      redeclare final package Medium = Medium,
      final n=1,
      final Mdotnom=Mdotnom,
      final Unom_l=Unom,
      final Unom_tp=Unom,
      final Unom_v=Unom,
      final M_dot=M_dot,
      final x=0,
      final FluidState={fluidState})
      annotation (Placement(transformation(extent={{-30,-12},{-10,8}})));

    HeatTransfer heatTransfer1(
      redeclare final package Medium = Medium,
      final n=1,
      final Mdotnom=Mdotnom,
      final Unom_l=Unom_hx,
      final Unom_tp=Unom_hx,
      final Unom_v=Unom_hx,
      final M_dot=M_dot,
      final x=0,
      final FluidState={fluidState})
      annotation (Placement(transformation(extent={{2,8},{22,-12}})));
    ThermoCycle.Interfaces.HeatTransfer.ThermalPortL HXInt annotation (
        Placement(transformation(extent={{20,-60},{40,-40}}),
          iconTransformation(extent={{20,-60},{40,-40}})));

    /***************  VARIABLES ******************/
    Medium.ThermodynamicState fluidState;
    Medium.AbsolutePressure p(start=pstart);
    Modelica.SIunits.MassFlowRate M_dot(start=Mdotnom);
    Medium.SpecificEnthalpy h(start=hstart, stateSelect=StateSelect.always)
      "Fluid specific enthalpy at the cells";
    Medium.Temperature T "Fluid temperature";
    //Modelica.SIunits.Temperature T_wall "Internal wall temperature";
    Medium.Density rho "Fluid cell density";
    Modelica.SIunits.SpecificEnthalpy hnode_su(start=hstart)
      "Enthalpy state variable at inlet node";
    Modelica.SIunits.SpecificEnthalpy hnode_ex(start=hstart)
      "Enthalpy state variable at outlet node";
    Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
    //   Modelica.SIunits.CoefficientOfHeatTransfer U
    //     "Heat transfer coefficient between wall and working fluid";
    Modelica.SIunits.Power Q_tot
      "Total heat flux exchanged by the thermal port";
    Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";

    Modelica.SIunits.HeatFlux qdot_hx;

    /***********************************  EQUATIONS ************************************/

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a direct_heat_port
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}}),
          iconTransformation(extent={{-40,-60},{-20,-40}})));
  equation
    /* Fluid Properties */
    fluidState = Medium.setState_ph(p, h);
    T = Medium.temperature(fluidState);
    rho = Medium.density(fluidState);
    /* ENERGY BALANCE */
    Vi*rho*der(h) + M_dot*(hnode_ex - hnode_su) - A_hx*qdot_hx = Ai*qdot + direct_heat_port.Q_flow
      "Energy balance";

    Q_tot = Ai*qdot "Total heat flow through the thermal port";
    M_tot = Vi*rho;

    qdot = heatTransfer.q_dot[1];

    qdot_hx = heatTransfer1.q_dot[1];

    if FlowReversal then
      hnode_ex = if M_dot >= 0 then h else inStream(OutFlow.h_outflow);
      hnode_su = if M_dot <= 0 then h else inStream(InFlow.h_outflow);
      InFlow.h_outflow = hnode_su;
    else
      hnode_su = inStream(InFlow.h_outflow);
      hnode_ex = h;
      InFlow.h_outflow = hstart;
    end if;

    //* BOUNDARY CONDITIONS *//
    /* Enthalpies */
    OutFlow.h_outflow = hnode_ex;
    /* pressures */
    p = OutFlow.p;
    InFlow.p = p;
    /*Mass Flow*/
    M_dot = InFlow.m_flow;
    OutFlow.m_flow = -M_dot;
    InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
    OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);

    direct_heat_port.T = T;

  initial equation
    if steadystate then
      der(h) = 0;
    end if;

  equation
    connect(HXInt, heatTransfer1.thermalPortL[1]) annotation (Line(
        points={{30,-50},{11.8,-50},{11.8,-8.6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(Wall_int, heatTransfer.thermalPortL[1]) annotation (Line(
        points={{2,50},{-8,50},{-8,4.6},{-20.2,4.6}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}}), graphics),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics={Rectangle(
            extent={{-80,40},{84,-40}},
            lineColor={255,0,0},
            fillColor={0,255,255},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<HTML>
          
         <p><big>This model describes the flow of an incompressible fluid through a single cell. An overall flow model can be obtained by interconnecting several cells in series (see <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc\">Flow1DimInc</a>).
          <p><big><b>Enthalpy</b> is selected as state variable. 
          <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. The relation between the cell and node values depends on the discretization scheme selected. 
 <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic energy balance and on a static  mass and  momentum balances
         <li> Constant pressure is assumed in the cell
         <li> Axial thermal energy transfer is neglected
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

 <p><big>The model is characterized by two flow connector and one lumped thermal port connector. During normal operation the fluid enters the model from the <em>InFlow</em> connector and exits from the <em>OutFlow</em> connector. In case of flow reversal the fluid direction is inversed.
 
 <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>Cell1DimInc</em> model.
 
        
        <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are available:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> HeatTransfer: the user can choose the thermal energy model he prefers </ul> 
        <p><big> In the <b>Initialization</b> tab the following options are available:
        <ul><li> steadystate: If it sets to true, the derivative of enthalpy is sets to zero during <em>Initialization</em> 
         </ul>
        <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method. The authors raccomand the <em>UpWind Scheme - AllowsFlowReversal</em> in case flow reversal is expected.
</ul>
 <p><big> 
        </HTML>"));
  end Cell1DimInc_2ports;

  model Test_heat_storage

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      h_0=2.8E5,
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      UseT=true,
      Mdot_0=0.2,
      p=100000,
      T_0=283.15)
      annotation (Placement(transformation(extent={{-82,-88},{-50,-56}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(h=2E5, redeclare
        package Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{28,22},{52,44}})));
    ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T
      annotation (Placement(transformation(extent={{-60,-12},{-40,8}})));
    Modelica.Blocks.Sources.Constant const(k=273.15 + 25)
      annotation (Placement(transformation(extent={{-76,24},{-56,44}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot1(
      h_0=2.8E5,
      UseT=true,
      redeclare package Medium = ThermoCycle.Media.StandardWater,
      Mdot_0=1,
      p=100000,
      T_0=363.15)
      annotation (Placement(transformation(extent={{82,-28},{50,4}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP1(h=2E5, redeclare
        package Medium = ThermoCycle.Media.StandardWater)
      annotation (Placement(transformation(extent={{38,-72},{62,-50}})));

    Heat_storage_hx heat_storage_hx(
      N=25,
      V_tank=0.15,
      h1=0.2,
      h2=0.8,
      Unom_hx=2000)
      annotation (Placement(transformation(extent={{-36,-66},{36,10}})));
    Modelica.Blocks.Sources.Step step(
      offset=273.15 + 90,
      height=-40,
      startTime=100)
      annotation (Placement(transformation(extent={{26,66},{46,86}})));
  equation

    connect(const.y, source_T.Temperature) annotation (Line(
        points={{-55,34},{-44,34},{-44,3},{-49,3}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(sourceMdot1.flangeB, heat_storage_hx.SecondaryFluid_su) annotation (
        Line(
        points={{51.6,-12},{32,-12},{32,-15.08},{14.4,-15.08}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(heat_storage_hx.SecondaryFluid_ex, sinkP1.flangeB) annotation (Line(
        points={{14.4,-39.4},{27.2,-39.4},{27.2,-61},{39.92,-61}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sinkP.flangeB, heat_storage_hx.MainFluid_ex) annotation (Line(
        points={{29.92,33},{0,33},{0,4.68}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, heat_storage_hx.MainFluid_su) annotation (Line(
        points={{-51.6,-72},{-32,-72},{-32,-58.02},{-13.32,-58.02}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(source_T.ThermalPortCell, heat_storage_hx.Wall_ext) annotation (
        Line(
        points={{-49.1,-5.1},{-49.1,-26.86},{-13.32,-26.86}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(step.y, sourceMdot1.in_T) annotation (Line(
        points={{47,76},{66.32,76},{66.32,-2.4}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Line(
        points={{-0.4,-12.26},{-0.4,-9.445},{-0.08,-9.445},{-0.08,-6.63},{2.32,
            -6.63},{2.32,-1.5}},
        color={255,0,0},
        smooth=Smooth.None), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      experiment(StopTime=1000),
      __Dymola_experimentSetupOutput);
  end Test_heat_storage;

  model Heat_storage_hx_R
    "Stratified tank with an internal heat exchanger, ambient heat losses and resistance heating"

  replaceable package MainFluid = ThermoCycle.Media.StandardWater
                                                 constrainedby
      Modelica.Media.Interfaces.PartialMedium "Main fluid"   annotation (choicesAllMatching = true);
  replaceable package SecondaryFluid = ThermoCycle.Media.StandardWater
                                                 constrainedby
      Modelica.Media.Interfaces.PartialMedium "Secondary fluid"  annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.Length htot=1 "Total height of the tank";
    parameter Modelica.SIunits.Length h1=0.3
      "Height of the bottom of the heat exchanger";
    parameter Modelica.SIunits.Length h2=0.6
      "Height of the top of the heat exchanger";
    parameter Modelica.SIunits.Length h_T = 0.7
      "Height of the temperature sensor";

    parameter Integer N=15 "Total number of cells";
    parameter Integer N1=integer(h1*N/htot)
      "Cell corresponding to the bottom of the heat exchanger";
    parameter Integer N2=integer(h2*N/htot)
      "Cell corresponding to the top of the heat exhcanger";
    parameter Integer N_T = integer(h_T*N/htot)
      "Cell corresponding to the tempearture sensor";

    parameter Modelica.SIunits.Area A_amb=2
      "Total heat exchange area from the tank to the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.Area A_hx=1
      "Total heat exchanger area from in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.Volume V_tank=0.3 "Total capacity of the tank" annotation(group="Tank");
    parameter Modelica.SIunits.Volume V_hx=0.005
      "Internal volume of the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.1
      "Nominal mass flow rate in the heat exchanger" annotation(group="Heat exchanger");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_amb=1
      "Heat transfer coefficient between the tank and the ambient" annotation(group="Tank");
    parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_hx=4000
      "Nominal heat transfer coefficient in the heat exchanger" annotation(group="Heat exchanger");

  parameter Modelica.SIunits.Mass M_wall_hx= 5
      "Mass of the metal wall between the two fluids" annotation(group="Heat exchanger");
  parameter Modelica.SIunits.SpecificHeatCapacity c_wall_hx= 500
      "Specific heat capacity of metal wall" annotation(group="Heat exchanger");
   parameter Modelica.SIunits.Power Wdot_res=3000
      "Nominal power of the electrical resistance";
   parameter Modelica.SIunits.Temperature Tmax = 273.15+90;

   parameter Modelica.SIunits.Pressure pstart_tank=1E5
      "Tank pressure start value"      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_tank=273.15+10
      "Tank inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_tank=273.15+60
      "Tank outlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificEnthalpy hstart_tank[N]=linspace(
          MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_inlet_tank),MainFluid.specificEnthalpy_pT(pstart_tank,Tstart_outlet_tank),
          N) "Start value of enthalpy vector (initialized by default)" annotation (Dialog(tab="Initialization"));

    parameter Modelica.SIunits.Pressure pstart_hx=1E5
      "Heat exchanger pressure start value"
                                       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_inlet_hx=273.15+70
      "Heat exchanger inlet temperature start value"
       annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature Tstart_outlet_hx=273.15+50
      "Heat exchanger outlet temperature start value"
       annotation (Dialog(tab="Initialization"));

    parameter Boolean steadystate_tank=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));
    parameter Boolean steadystate_hx=true
      "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
      annotation (Dialog(tab="Initialization"));

    ThermoCycle.Components.FluidFlow.Pipes.Flow1DimInc flow1Dim(
      redeclare package Medium = SecondaryFluid,
      A=A_hx,
      V=V_hx,
      Mdotnom=Mdot_nom,
      Unom=Unom_hx,
      steadystate=steadystate_hx,
      N=N2 - N1 + 1,
      pstart=100000,
      Tstart_inlet=363.15,
      Tstart_outlet=343.15,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal)
      annotation (Placement(transformation(extent={{20,-84},{-16,-50}})));
    Cell1DimInc_2ports cell1DimInc_hx[N](
      redeclare package Medium = MainFluid,
      redeclare model HeatTransfer =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
      each Vi=V_tank/N,
      each Mdotnom=1,
      each Unom=U_amb,
      each Unom_hx=Unom_hx,
      each Ai=A_amb/N,
      each pstart=pstart_tank,
      hstart=hstart_tank,
      each A_hx=1/(N2 - N1 + 1))
      annotation (Placement(transformation(extent={{-16,-10},{18,24}})));

    ThermoCycle.Interfaces.HeatTransfer.ThermalPortConverter thermalPortConverter(N=N2 - N1
           + 1)
      annotation (Placement(transformation(extent={{-8,-4},{12,-32}})));

    ThermoCycle.Components.HeatFlow.Walls.MetalWall
                                        metalWall(
      Aext=A_hx,
      Aint=A_hx,
      c_wall=c_wall_hx,
      M_wall=M_wall_hx,
      Tstart_wall_1=Tstart_inlet_hx - 5,
      Tstart_wall_end=Tstart_outlet_hx - 5,
      steadystate_T_wall=false,
      N=N2 - N1 + 1)
      annotation (Placement(transformation(extent={{-18,-56},{21,-28}})));

  protected
  Real Tsf_[N](min=0);
  Real Twall_[N](min=0);

  public
  record SummaryBase
    replaceable Arrays T_profile;
    record Arrays
     parameter Integer n;
     Real[n] Tsf(min=0);
     Real[n] Twall(min=0);
     Real[n] Twf(min=0);
    end Arrays;
  end SummaryBase;
  replaceable record SummaryClass = SummaryBase;
  SummaryClass Summary( T_profile( n=N, Tsf = Tsf_,  Twall = Twall_, Twf = cell1DimInc_hx.T));

  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL Wall_ext
      annotation (Placement(transformation(extent={{-14,48},{16,60}}),
          iconTransformation(extent={{-40,-6},{-34,12}})));
    ThermoCycle.Interfaces.Fluid.FlangeA MainFluid_su(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-52,-94},{-32,-74}}),
                     iconTransformation(extent={{-42,-84},{-32,-74}})));
    ThermoCycle.Interfaces.Fluid.FlangeB SecondaryFluid_ex(redeclare package
        Medium = SecondaryFluid)
                     annotation (Placement(transformation(extent={{-64,-76},{-44,-56}}),
          iconTransformation(extent={{34,-36},{46,-24}})));
    ThermoCycle.Interfaces.Fluid.FlangeB MainFluid_ex(redeclare package Medium
        = MainFluid) annotation (Placement(transformation(extent={{-14,72},{6,
              92}}),
          iconTransformation(extent={{-6,80},{6,92}})));
    ThermoCycle.Interfaces.Fluid.FlangeA SecondaryFluid_su(redeclare package
        Medium = SecondaryFluid)
                          annotation (Placement(transformation(extent={{54,-76},{74,
              -56}}),iconTransformation(extent={{34,28},{46,40}})));
    Modelica.Blocks.Interfaces.BooleanInput R_on_off annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-100}), iconTransformation(
          extent={{-3,-4},{3,4}},
          rotation=90,
          origin={0,-81})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Resistor[N]
      annotation (Placement(transformation(extent={{-44,-26},{-24,-6}})));
    Modelica.Blocks.Interfaces.RealOutput Temperature(quantity="ThermodynamicTemperature",unit="K",displayUnit="degC") annotation (Placement(
          transformation(extent={{-52,24},{-32,44}}), iconTransformation(extent={{
              -36,24},{-46,34}})));
  equation

    if cardinality(R_on_off)==0 then
      R_on_off = false "Thermal resistance is desactivated by default";
    end if;

  /* Connection of the different cell of the tank in series */
    for i in 1:N - 1 loop
      connect(cell1DimInc_hx[i].OutFlow, cell1DimInc_hx[i + 1].InFlow);
    end for;

  /* Connection of the different cell of the tank in series */
    for i in 1:N loop
      connect(Wall_ext,cell1DimInc_hx[i].Wall_int);
      Resistor[i].Q_flow = if R_on_off then Wdot_res/N else 0;
      assert(cell1DimInc_hx[i].T < Tmax,"Maximum temperature reached in the tank");
    end for;

    for i in 1:N1-1 loop
      Tsf_[i]=273.15;
      Twall_[i]=273.15;
    end for;

    for i in 1:(N2 - N1+1) loop
      connect(thermalPortConverter.single[i], cell1DimInc_hx[N1 + i - 1].HXInt);
      assert(flow1Dim.Summary.T[i] < Tmax,"Maximum temperature reached in the tank");
    end for;

      Tsf_[N1:N2]=flow1Dim.Summary.T[end:-1:1];
      Twall_[N1:N2]=metalWall.T_wall[end:-1:1];

    for i in N2+1:N loop
      Tsf_[i]=273.15;
      Twall_[i]=273.15;
    end for;

    Temperature = cell1DimInc_hx[N_T].T;

    connect(thermalPortConverter.multi, metalWall.Wall_int) annotation (Line(
        points={{2,-22.9},{2,-29.35},{1.5,-29.35},{1.5,-37.8}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(metalWall.Wall_ext, flow1Dim.Wall_int) annotation (Line(
        points={{1.11,-46.2},{1.11,-52.0584},{2,-52.0584},{2,-59.9167}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(MainFluid_su, cell1DimInc_hx[1].InFlow) annotation (Line(
        points={{-42,-84},{-51,-84},{-51,7},{-16,7}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(cell1DimInc_hx[N].OutFlow, MainFluid_ex) annotation (Line(
        points={{18,7.17},{68,7.17},{68,82},{-4,82}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(SecondaryFluid_ex, flow1Dim.OutFlow)
                                             annotation (Line(
        points={{-54,-66},{-54,-66.8583},{-13,-66.8583}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flow1Dim.InFlow, SecondaryFluid_su)
                                            annotation (Line(
        points={{17,-67},{60.5,-67},{60.5,-66},{64,-66}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(Resistor.port, cell1DimInc_hx.direct_heat_port) annotation (Line(
        points={{-24,-16},{-4.1,-16},{-4.1,-1.5}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Line(
        points={{-0.4,-12.26},{-0.4,-9.445},{-0.08,-9.445},{-0.08,-6.63},{2.32,
            -6.63},{2.32,-1.5}},
        color={255,0,0},
        smooth=Smooth.None), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics),
      experiment(StopTime=5000),
      __Dymola_experimentSetupOutput,
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Ellipse(
            extent={{-40,60},{40,88}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-40,72},{40,-84}},
            lineColor={215,215,215},
            fillPattern=FillPattern.Solid,
            fillColor={215,215,215}),
          Line(
            points={{40,34},{-10,34},{20,22},{-10,12},{20,2},{-8,-10},{22,-20},{-8,
                -32},{38,-32}},
            color={0,0,0},
            smooth=Smooth.None,
            thickness=0.5),
          Line(
            points={{22,-36},{34,-32},{22,-28}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.None),
          Line(
            points={{-40,-84},{40,-84},{40,74}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,74},{-40,-84}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{-40,66},{40,66}},
            color={0,0,0},
            smooth=Smooth.None)}),
      Documentation(info="<html>
<p>Nodal model of a stratified tank, with the following hypotheses:</p>
<p><ul>
<li>No heat transfer between the different nodes</li>
<li>The internal heat exchanger is discretized in the same way as the tank: each cell of the heat exchanger corresponds to one cell of the tank and exchanges heat with that cell only.</li>
<li>Incompressible fluid in both the tank and the heat exchanger</li>
</ul></p>
<p><br/>The tank is discretized using a modified version of the incompressible Cell1Dim model adding an additional heat port. The heat exchanger is modeled using the Flow1Dim component and a wall component.</p>
</html>"));
  end Heat_storage_hx_R;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-42,52},{38,80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,64},{38,-92}},
          lineColor={215,215,215},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Line(
          points={{38,26},{-12,26},{18,14},{-12,4},{18,-6},{-10,-18},{20,-28},{
              -10,-40},{36,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{26,-44},{38,-40},{26,-36}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-42,-92},{38,-92},{38,66}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-42,66},{-42,-92}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-42,58},{38,58}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>Nodal model of a stratified tank, with the following hypotheses:</p>
<p><ul>
<li>No heat transfer between the different nodes</li>
<li>The internal heat exchanger is discretized in the same way as the tank: each cell of the heat exchanger corresponds to one cell of the tank and exchanges heat with that cell only.</li>
<li>Incompressible fluid in both the tank and the heat exchanger</li>
</ul></p>
<p><br/>The tank is discretized using a modified version of the incompressible Cell1Dim model adding an additional heat port. The heat exchanger is modeled using the Flow1Dim component and a wall component.</p>
</html>"));
end HeatStorageWaterHeater;
