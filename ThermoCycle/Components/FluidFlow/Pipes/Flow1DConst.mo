within ThermoCycle.Components.FluidFlow.Pipes;
model Flow1DConst
  "1-D fluid flow model (finite volume discretization - ideal fluid model)"

/****************************** SUMMARY ****************************************/

public
record SummaryClass
  replaceable Arrays T_profile;
    record Arrays
    parameter Integer n;
    Modelica.SIunits.Temperature[n] T_cell;
      Modelica.SIunits.Temperature[n+1]  Tnode;
    end Arrays;

end SummaryClass;
 SummaryClass Summary(T_profile(n=N, T_cell = Cells[:].T, Tnode = Tnode_));

/************ Thermal and fluid ports ***********/
  Interfaces.Fluid.Flange_Cdot flange_Cdot
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Interfaces.Fluid.Flange_ex_Cdot flange_ex_Cdot
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));

/************ Geometric characteristics **************/
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1) = 10 "Number of cells";
  parameter Integer Nt(min=1)=1 "Number of cells in parallel";
  parameter Modelica.SIunits.Area A= 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  parameter Modelica.SIunits.MassFlowRate Mdotnom= 3
    "Norminal  fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer  Unom=500
    "Nominal heat transfer coefficient,secondary fluid";

/************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Temperature Tstart_inlet = 145 + 273.15
    "Inlet temperature start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart_outlet = 135 + 273.15
    "Outlet temperature start value"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature Tstart[N]=linspace(
        Tstart_inlet,
        Tstart_outlet,
        N) "Start value of temperature vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
parameter Boolean steadystate=true
    "if true, sets the derivative of T to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));

 /************************** NUMERICAL OPTIONS  ******************************/
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));

/********************************* HEAT TRANSFER MODEL ********************************/
/* Heat transfer Model */
replaceable model Flow1DConstHeatTransferModel =
ThermoCycle.Components.HeatFlow.HeatTransfer.MassFlowDependence_IdealFluid
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialHeatTransferZones_IdealFluid
    "Convective heat transfer"                                                         annotation (choicesAllMatching = true);

/***************  VARIABLES ******************/
Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";
Modelica.SIunits.Temperature Tnode_[N+1]
    "Temperature at each node of the cells";

/******************************** CELLS **************************/
  ThermoCycle.Components.FluidFlow.Pipes.CellConst
        Cells[N](
    redeclare each final model HeatTransfer = Flow1DConstHeatTransferModel,
    each Nt=Nt,
    each Vi=V/N,
    each Ai=A/N,
    each Mdotnom=Mdotnom,
    each Unom=Unom,
    each Discretization=Discretization,
    Tstart = Tstart,
    each steadystate=steadystate)
                                 annotation (Placement(transformation(extent={{-30,-66},
            {24,-22}})));
  Interfaces.HeatTransfer.ThermalPortConverter thermalPortConverter(N=N)
    annotation (Placement(transformation(extent={{-24,-18},{16,16}})));

equation
for i in 1:N-1 loop
  connect(Cells[i].OutFlow,Cells[i+1].InFlow);
end for;
  Q_tot = A/N*sum(Cells.qdot)*Nt;
  M_tot = Cells[1].rho_su*V
    "The density is considered constant along the component";
  Tnode_[1:N] = Cells.Tnode_su;
  Tnode_[N+1] = Cells[N].Tnode_ex;

  connect(flange_Cdot, Cells[1].InFlow) annotation (Line(
      points={{-90,0},{-56,0},{-56,-44},{-30,-44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cells[N].OutFlow, flange_ex_Cdot) annotation (Line(
      points={{24,-44},{38,-44},{38,-38},{58,-38},{58,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cells.Wall_int, thermalPortConverter.single) annotation (Line(
      points={{-3,-33},{-3,-18.5},{-4,-18.5},{-4,-7.97}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalPortConverter.multi, Wall_int) annotation (Line(
      points={{-4,4.95},{-4,27.475},{-4,50},{2,50}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Icon(graphics={Rectangle(extent={{-90,40},{90,-40}},
            lineColor={0,0,255})}), Diagram(graphics),Documentation(info="<HTML>
            <p><big>This model describes the flow of a constant heat capacity fluid through a discretized one dimensional tube.  It is obtained by connecting in series <b>N</b> <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.CellConst\">CellConst</a>
                
            <p><big> The model is characterized by a SummaryClass that provide a quick access to the following variables once the model is simulated:
           <ul><li> Temperature at each nodes
           <li>  Temperature at the center of each cell
           </ul>     
                </HTML>"));
end Flow1DConst;
