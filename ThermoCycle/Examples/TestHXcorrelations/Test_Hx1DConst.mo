within ThermoCycle.Examples.TestHXcorrelations;
model Test_Hx1DConst

  // replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
  //   Modelica.Media.Interfaces.PartialMedium "Medium"
  //   annotation(choicesAllMatching=true);
  replaceable package Medium = ExternalMedia.Media.CoolPropMedium (
  mediumName="R134a",
  substanceNames={"R134a|debug=0|calc_transport=1|enable_EXTTP=1|enable_TTSE=0"});

ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkPFluid(redeclare package
      Medium = Medium,  p0=2357000)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceWF(
    Mdot_0=0.2588,
    h_0=281455,
    UseT=true,
    redeclare package Medium = Medium,
    p=2357000,
    T_0=353.15)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst hx1DConst(
    redeclare package Medium1 = Medium,
    steadystate_T_sf=true,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    N=10,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind,
    SecondaryFluid(Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff))
    annotation (Placement(transformation(extent={{-20,0},{20,40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot   source_Cdot(
    cp=1978,
    rho=928.2,
    Mdot_0=3,
    T_0=418.15)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation
  connect(sourceWF.flangeB, hx1DConst.inletWf)
                                             annotation (Line(
      points={{-61,10},{-20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hx1DConst.outletWf, sinkPFluid.flangeB)
                                                annotation (Line(
      points={{20,10},{22,10},{22,10},{36,10},{36,10},{60,10},{62,10},{62,10},{
          61.6,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(source_Cdot.flange, hx1DConst.inletSf)
                                               annotation (Line(
      points={{8.2,59.9},{36,59.9},{36,30},{20,30}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_Hx1DConst;
