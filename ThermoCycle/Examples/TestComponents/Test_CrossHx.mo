within ThermoCycle.Examples.TestComponents;
model Test_CrossHx

  Components.Units.HeatExchangers.CrossHX crossHX(
    V_wf=1.36e-4,
    A_wf=0.06248,
    V_sf=0,
    A_sf=1.091,
    Mdotnom_wf=0.19/12,
    Mdotnom_sf=6/12/2,
    M_wall_tot=2.85,
    c_wall=660,
    Unom_l=430,
    Unom_tp=4400,
    Unom_v=660,
    Unom_sf=50,
    UseNom_sf=true,
    redeclare package Medium2 = Modelica.Media.Air.SimpleAir,
    T_nom_sf=298.15,
    DELTAp_quad_nom_sf=50000,
    pstart_wf=211000,
    Tstart_wf_in=323.15)
    annotation (Placement(transformation(extent={{-44,-26},{34,54}})));
 Components.FluidFlow.Reservoirs.SourceMdot             sourceR245faCool(Mdot_0=0.19
                                                    /12,
    redeclare package Medium = ThermoCycle.Media.R245fa_CP,
    T_0=323.15)
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
 Components.FluidFlow.Reservoirs.SourceMdot             sourceAir(
    Mdot_0=6/12/2,
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    T_0=303.81)
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
 Components.FluidFlow.Reservoirs.SinkP             sinkP(redeclare package
      Medium = ThermoCycle.Media.R245fa_CP,  p0=211000)
    annotation (Placement(transformation(extent={{82,12},{102,32}})));
 Components.FluidFlow.Reservoirs.SinkP             sinkP1(redeclare package
      Medium =
        Modelica.Media.Air.SimpleAir)
    annotation (Placement(transformation(extent={{8,-56},{28,-36}})));
equation
  connect(sourceR245faCool.flangeB, crossHX.Inlet_fl1) annotation (Line(
      points={{-71,14},{-44.78,14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(crossHX.Outlet_fl1, sinkP.flangeB) annotation (Line(
      points={{33.22,14},{58.61,14},{58.61,22},{83.6,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceAir.flangeB, crossHX.Inlet_fl2) annotation (Line(
      points={{9,86},{14,86},{14,66},{-5,66},{-5,52.4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(crossHX.Outlet_fl2, sinkP1.flangeB) annotation (Line(
      points={{-5.78,-24.4},{-5.78,-46},{9.6,-46}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Test_CrossHx;
