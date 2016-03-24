within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.ComparisonSolarField;
model Test_EvaWaterBonilla "Comparison with Bonilla's general evaporator model"
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
    eps_NTU=false,
    pstart=6000000)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
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
    annotation (Placement(transformation(extent={{-7,4},{13,24}})));
  Modelica.Blocks.Sources.CombiTimeTable Irradiance(smoothness=Modelica.Blocks.
        Types.Smoothness.LinearSegments, table=[0.0,1200; 20000,1200; 24000,1100;
        50000,1100; 54000,1200; 80000,1200; 84000,1100; 110000,1100; 130000,1300;
        140000,1300])
    annotation (Placement(transformation(extent={{-88,74},{-68,94}},
        rotation=0)));

  MovingBoundaryLibrary.Components.Wall.Receiver receiver(T_amb(displayUnit="K")
       = 290, epsilon=0.1)
    annotation (Placement(transformation(extent={{-36,74},{-16,94}})));
initial equation
 //evaGeneral.volumeSH.h_b = h0;
der(evaGeneral.volumeSH.h_b) = 0;
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
equation
    /* If statement to allow parallel or counter current structure*/

  connect(wall3volumes.QmbIn, evaGeneral.mbOut)
    annotation (Line(
      points={{2.2,5},{2.2,-34},{0,-34},{0,-39}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(receiver.mbIn, wall3volumes.QmbOut) annotation (Line(
      points={{-16.2,84},{2,84},{2,24},{3.2,24},{3.2,23.2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(Irradiance.y[1], receiver.Irr) annotation (Line(
      points={{-67,84},{-37,84}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, evaGeneral.InFlow) annotation (Line(
      points={{-53,-50},{-32,-50},{-32,-47.8},{-10.2,-47.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, sinkP.flangeB) annotation (Line(
      points={{9.8,-47.8},{45.9,-47.8},{45.9,-50},{81.6,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput, Documentation(info="<HTML>
          
          <p><big> This model is used to compare the ThermoCycle MB model with Bonilla's
          general evaportator model. The receiver adapted to the ThermoCycle model takes
          into account the ambiant heat losses. 
          </HTML>"));
end Test_EvaWaterBonilla;
