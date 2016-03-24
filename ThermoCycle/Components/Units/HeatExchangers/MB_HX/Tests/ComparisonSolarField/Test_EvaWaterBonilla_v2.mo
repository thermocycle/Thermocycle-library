within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.ComparisonSolarField;
model Test_EvaWaterBonilla_v2
  "Comparison with Bonnilla's general evaporator model"
replaceable package Medium =
    ExternalMedia.Examples.WaterCoolProp;

  parameter Modelica.SIunits.AbsolutePressure p_out = 60E5;
  parameter Modelica.SIunits.Temperature T_sf_su = 1000+273.15;
parameter Medium.ThermodynamicState stateOut= Medium.setState_pT(p_out,T_sf_su-100);
parameter Modelica.SIunits.SpecificEnthalpy h0 = Medium.specificEnthalpy(stateOut);
parameter Integer n=3;
parameter Boolean counterCurrent = true;

  MovingBoundaryLibrary.Components.Evaporator.EvaGeneral evaGeneral(
    redeclare package Medium = Medium,
    lstartSH=150,
    AA=0.001963,
    YY=0.15,
    Ltotal=500,
    lstartSC=75,
    lstartTP=275,
    hstartSC=7.69E5,
    hstartTP=1.999E6,
    hstartSH=3.135E6,
    UnomSC=2500,
    UnomTP=8000,
    UnomSH=2000,
    pstart=6000000)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    T_0(displayUnit="K") = 350,
    p=6000000)
    annotation (Placement(transformation(extent={{-72,-60},{-52,-40}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       6000000)
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  MovingBoundaryLibrary.Components.Wall.wall3volumes wall3volumes(
    cp_w=500,
    L_total=500,
    M_w=80,
    TstartWall={513.15,513.15,673.15})
    annotation (Placement(transformation(extent={{-9,-20},{11,0}})));

  Modelica.Blocks.Sources.CombiTimeTable Irradiance(smoothness=Modelica.Blocks.
        Types.Smoothness.LinearSegments, table=[0.0,1200; 20000,1200; 24000,1100;
        50000,1100; 54000,1000; 80000,1000; 84000,1100; 110000,1100; 130000,1300;
        140000,1300])
    annotation (Placement(transformation(extent={{-88,74},{-68,94}},
        rotation=0)));

  MovingBoundaryLibrary.Components.Wall.Receiver receiver(T_amb(displayUnit="K")
       = 290, epsilon=0.1)
    annotation (Placement(transformation(extent={{-24,66},{-4,86}})));

initial equation
 //evaGeneral.volumeSH.h_b = h0;
der(evaGeneral.volumeSH.h_b) = 0;
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
equation
    /* If statement to allow parallel or counter current structure*/

  connect(wall3volumes.QmbIn, evaGeneral.mbOut)
    annotation (Line(
      points={{0.2,-19},{0.2,-34},{0,-34},{0,-41}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(receiver.mbIn, wall3volumes.QmbOut) annotation (Line(
      points={{-4.2,76},{12,76},{12,28},{1.2,28},{1.2,-0.8}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(Irradiance.y[1], receiver.Irr) annotation (Line(
      points={{-67,84},{-46,84},{-46,76},{-25,76}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, evaGeneral.InFlow) annotation (Line(
      points={{-53,-50},{-32,-50},{-32,-49.8},{-10.2,-49.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, sinkP.flangeB) annotation (Line(
      points={{9.8,-49.8},{45.9,-49.8},{45.9,-50},{81.6,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=150000),
    __Dymola_experimentSetupOutput,Documentation(info="<HTML>
          
          <p><big> In this model, the irradiance ramps down until the SH zone disappear. 
          As a proper switching process is not implemented yet, this leads to a negative SH zone length.
          Hence, for the SH zone, h_b is lower than h_a.
          </HTML>"));
end Test_EvaWaterBonilla_v2;
