within ThermoCycle.Examples;
package TestNumericalMethods
                             extends Modelica.Icons.Package;
  model Cell1D_Trunc

    Components.FluidFlow.Pipes.Cell1Dim
           flow1Dim(
      Ai=0.2,
      Unom_l=400,
      Unom_tp=1000,
      Unom_v=400,
      max_drhodt=50,
      Vi=0.005,
      redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
      Mdotnom=0.3335,
      hstart=84867,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
      pstart=866735,
      Mdotconst=true)
      annotation (Placement(transformation(extent={{-24,8},{-4,28}})));
    ThermoCycle.Components.HeatFlow.Sources.Source_T_cell source_T
      annotation (Placement(transformation(extent={{-24,44},{-4,64}})));
    Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
      annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
    Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
      redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
      Mdot_0=0.3335,
      UseT=false,
      h_0=84867,
      p=888343,
      T_0=356.26)
      annotation (Placement(transformation(extent={{-90,12},{-70,32}})));
    Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
        Medium = CoolProp2Modelica.Media.SES36_CP,
      h=254381,
      p0=866735)
      annotation (Placement(transformation(extent={{40,4},{60,24}})));
    Modelica.Blocks.Sources.Sine sine(
      startTime=10,
      offset=0.3335,
      amplitude=0.5,
      phase=0,
      freqHz=0.1)
      annotation (Placement(transformation(extent={{-114,44},{-100,58}})));
  equation
    connect(const.y, source_T.Temperature) annotation (Line(
        points={{-45,82},{-28,82},{-28,80},{-13,80},{-13,59}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(flow1Dim.Wall_int, source_T.ThermalPortCell) annotation (Line(
        points={{-14,23},{-14,50.9},{-13.1,50.9}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
        points={{-71,22},{-40,22},{-40,18},{-24,18}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
        points={{-4,18.1},{16,18.1},{16,16},{41.6,16},{41.6,14}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sine.y, sourceMdot1.in_Mdot) annotation (Line(
        points={{-99.3,51},{-86,51},{-86,28}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
              100,100}}), graphics),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput);
  end Cell1D_Trunc;

  model flow1D_Trunc
    parameter Integer N = 10;
    ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim flow1Dim(
      A=2,
      Unom_l=400,
      Unom_tp=1000,
      Unom_v=400,
      N=N,
      V=0.003,
      Mdotnom=0.3,
      Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
      redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
      redeclare model Flow1DimHeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Constant,
      pstart=1000000,
      Tstart_inlet=323.15,
      Tstart_outlet=373.15,
      Mdotconst=true)
      annotation (Placement(transformation(extent={{-40,-4},{-2,34}})));

    ThermoCycle.Components.HeatFlow.Sources.Source_T source_T(N=N)
      annotation (Placement(transformation(extent={{-30,42},{4,64}})));
    Modelica.Blocks.Sources.Constant const(k=273.15 + 140)
      annotation (Placement(transformation(extent={{-62,64},{-54,72}})));
    Components.FluidFlow.Reservoirs.SourceMdot             sourceMdot1(
      redeclare package Medium = CoolProp2Modelica.Media.SES36_CP,
      Mdot_0=0.3335,
      UseT=false,
      h_0=84867,
      p=888343,
      T_0=356.26)
      annotation (Placement(transformation(extent={{-86,12},{-60,38}})));
    Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
        Medium = CoolProp2Modelica.Media.SES36_CP,
      h=254381,
      p0=866735)
      annotation (Placement(transformation(extent={{50,14},{70,34}})));
    Modelica.Blocks.Sources.Sine sine(
      startTime=10,
      offset=0.3335,
      amplitude=0.5,
      phase=0,
      freqHz=0.1)
      annotation (Placement(transformation(extent={{-126,40},{-112,54}})));
  equation
    connect(source_T.thermalPort, flow1Dim.Wall_int) annotation (Line(
        points={{-13.17,48.49},{-13.17,43.95},{-21,43.95},{-21,22.9167}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(const.y, source_T.Temperature) annotation (Line(
        points={{-53.6,68},{-13,68},{-13,57.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot1.flangeB, flow1Dim.InFlow) annotation (Line(
        points={{-61.3,25},{-52,25},{-52,15},{-36.8333,15}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flow1Dim.OutFlow, sinkP.flangeB) annotation (Line(
        points={{-5.16667,15.1583},{18,15.1583},{18,24},{51.6,24}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sine.y, sourceMdot1.in_Mdot) annotation (Line(
        points={{-111.3,47},{-97.65,47},{-97.65,32.8},{-80.8,32.8}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
              100,100}}), graphics={Text(
            extent={{-62,56},{-26,50}},
            lineColor={0,0,0},
            textString="Thermal port")}),
      experiment(StopTime=50, __Dymola_Algorithm="Dassl"),
      __Dymola_experimentSetupOutput);
  end flow1D_Trunc;
end TestNumericalMethods;
