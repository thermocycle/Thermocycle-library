within ThermoCycle.Components.FluidFlow.Pipes;
model Flow1DimInc
  "1-D fluid flow model (finite volume discretization - incompressible fluid model). Based on the Cell component"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Medium model - Incompressible Fluid" annotation (choicesAllMatching = true);
public
 record SummaryClass
    replaceable Arrays T_profile;
    record Arrays
    parameter Integer n;
    Modelica.SIunits.Temperature[n] T_cell;
    end Arrays;
    parameter Integer n;
    Modelica.SIunits.SpecificEnthalpy[n] h;
    Modelica.SIunits.Temperature[n] T;
    Modelica.SIunits.SpecificEnthalpy[n+1] hnode;
    Modelica.SIunits.Density[n] rho;
    Modelica.SIunits.MassFlowRate Mdot;
   Modelica.SIunits.Pressure p;
 end SummaryClass;
 SummaryClass Summary( T_profile(n=N, T_cell = Cells[:].T), n=N, h = Cells[:].h, hnode = hnode_, rho = Cells.rho, T = Cells.T, Mdot = InFlow.m_flow, p = Cells[1].p);
/************ Thermal and fluid ports ***********/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
/************ Geometric characteristics **************/
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1)=10 "Number of cells";
  parameter Modelica.SIunits.Area A = 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  parameter Modelica.SIunits.MassFlowRate Mdotnom = 0.2588
    "Nominal fluid flow rate";
   parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "if HTtype = Const: Heat transfer coefficient";
 /********************************* FLUID INITIAL VALUES ******************************/
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_inlet "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_outlet "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart[N]=linspace(
        Medium.specificEnthalpy_pTX(pstart,Tstart_inlet,fill(0,0)),Medium.specificEnthalpy_pTX(pstart,Tstart_outlet,fill(0,0)),
        N) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/***************************************   NUMERICAL OPTIONS  ***************************************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
  /******************************* HEAT TRANSFER MODEL **************************************/
replaceable model Flow1DimIncHeatTransferModel =
    ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones
    "Fluid heat transfer model" annotation (choicesAllMatching = true);
/***************  VARIABLES ******************/
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
  /********************************** CELLS *****************************************/
 ThermoCycle.Components.FluidFlow.Pipes.Cell1DimInc
        Cells[N](
    redeclare package Medium = Medium,
    redeclare each final model HeatTransfer = Flow1DimIncHeatTransferModel,
    each Vi=V/N,
    each Ai=A/N,
    each Nt=Nt,
    each Mdotnom=Mdotnom,
    each Unom=Unom,
    each pstart=pstart,
    each Discretization=Discretization,
    hstart = hstart,
    each steadystate=steadystate)
                        annotation (Placement(transformation(extent={{-26,-62},
            {28,-18}})));
  Interfaces.HeatTransfer.ThermalPortConverter
                       thermalPortConverter(N=N)
    annotation (Placement(transformation(extent={{-8,-4},{10,22}})));
protected
  Modelica.SIunits.SpecificEnthalpy hnode_[N+1];
  /*************************************** EQUATION *************************************/
equation
  // Connect wall and refrigerant cells with eachother
  for i in 1:N-1 loop
    connect(Cells[i].OutFlow, Cells[i+1].InFlow);
  end for;
  hnode_[1:N] = Cells.hnode_su;
  hnode_[N+1] = Cells[N].hnode_ex;
  Q_tot = A/N*sum(Cells.qdot)*Nt "Total heat flow through the thermal port";
  M_tot = V/N*sum(Cells.rho);
  connect(InFlow, Cells[1].InFlow) annotation (Line(
      points={{-90,0},{-60,0},{-60,-40},{-26,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermalPortConverter.single, Cells.Wall_int) annotation (Line(
      points={{1,3.67},{2,-16},{1,-29}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalPortConverter.multi, Wall_int) annotation (Line(
      points={{1,13.55},{1,48},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cells[N].OutFlow, OutFlow) annotation (Line(
      points={{28,-39.78},{50,-39.78},{50,0},{90,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,
            -120},{120,120}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-120,-120},{120,120}}),
                                      graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
       <p><big>This model describes the flow of incompressible fluid through a discretized one dimensional tube. It is obtained by connecting in series <b>N</b> <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Cell1DimInc\">Cell1DimInc</a>.    
          
          <p><big> The model is characterized by a SummaryClass that provide a quick access to the following variables once the model is simulated:
           <ul><li> Enthalpy at each node
           <li>  Enthalpy at the center of each cell
           <li> Density at the center of each cell
           <li> Massflow at each node
           <li> Temperature at the center of each cell
           <li> Pressure in the tube
           </ul>
          
      </HTML>"));
end Flow1DimInc;
