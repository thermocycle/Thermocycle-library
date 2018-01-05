within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
package ScrollCompressor
  "Detailed, semi-empirical model of a scroll compressor"

  package R22
    extends ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium(
    mediumName="R22",
    libraryName="CoolProp",
    substanceNames={"R22"},
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph);
  end R22;

  model Test_nozzle
    import ThermoCycle;

    ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      h_0=480000,
      Mdot_0=0.005,
      p=1800000,
      UseT=true,
      T_0=423.15)
      annotation (Placement(transformation(extent={{-140,-24},{-104,12}})));
    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      h=430000,
      p0=600000)
      annotation (Placement(transformation(extent={{0,-22},{20,-2}})));
    Nozzle         fuite_interne2(
    redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
    Use_gamma=false,
      P_su_start=1800000,
      T_su_start=423.15,
      P_ex_start=600000)
      annotation (Placement(transformation(extent={{-88,-28},{-46,18}})));
    Modelica.Blocks.Sources.Ramp ramp(
      duration=5,
      startTime=0,
      height=0.01,
      offset=0.0001)
      annotation (Placement(transformation(extent={{-174,-14},{-154,6}})));
  equation
    connect(ramp.y, sourceMdot.in_Mdot) annotation (Line(
        points={{-153,-4},{-144,-4},{-144,28},{-132.8,28},{-132.8,4.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sourceMdot.flangeB, fuite_interne2.su) annotation (Line(
        points={{-105.8,-6},{-98,-6},{-98,-4.54},{-88.42,-4.54}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(fuite_interne2.ex, sinkP.flangeB) annotation (Line(
        points={{-46,-4.54},{-22,-4.54},{-22,-12},{1.6,-12}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics),
      experiment(__Dymola_NumberOfIntervals=10),
      __Dymola_experimentSetupOutput);
  end Test_nozzle;

  model Nozzle
    "Model of a nozzle operating in subsonic or supersonic conditions."
  replaceable package Medium = ThermoCycle.Media.DummyFluid;
  Medium.ThermodynamicState outlet;
  Medium.ThermodynamicState inlet;
  Medium.ThermodynamicState throat;
  Medium.ThermodynamicState throat_choked;
  parameter Modelica.SIunits.Area A_leak = 5e-7 "Throat area";
  parameter Boolean Use_gamma=false
      "Use a fictitious gamma (perfect gas model) to compute the critical pressure";

  parameter Medium.AbsolutePressure P_su_start = 17E5
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.Temperature T_su_start = 273.15+150
      "Start value for the inlet pressure"                                                 annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure P_ex_start = 2E5
      "Start value for the inlet pressure"                                                annotation(Dialog(tab="Initialization"));
  parameter Real gamma_start = 1.05
      "Start value of the fictitious expansion factor, used to compute the start value of the critical pressure"
                                                                                                          annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure P_thr_crit_start = P_su_start*(2/(gamma_start+1))^(gamma_start/(gamma_start-1))
      "Critical throat pressure start value"                                                           annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Velocity C_thr_start = Medium.velocityOfSound(Medium.setState_pT(P_thr_crit_start,T_su_start))
      "Throat velocity start value"   annotation (Dialog(tab="Initialization"));
  //Medium.AbsolutePressure P_thr_crit(start = P_thr_crit_start);
  Medium.AbsolutePressure p_thr(start=max(P_ex_start,P_thr_crit_start),stateSelect = StateSelect.prefer);
  Medium.AbsolutePressure p_su(start=P_su_start);
  Medium.AbsolutePressure p_ex(start=P_ex_start);
  Medium.AbsolutePressure p_choked(start = P_thr_crit_start);
  Medium.Density rho_choked;
  Modelica.SIunits.VolumeFlowRate V_dot_leak;
  Modelica.SIunits.Velocity C_choked(start = C_thr_start);
  Modelica.SIunits.Velocity C_thr(start = C_thr_start);
  Real gamma;

    ThermoCycle.Interfaces.Fluid.FlangeA su(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
    ThermoCycle.Interfaces.Fluid.FlangeB ex(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{90,-8},{110,12}})));
  equation
  // Inlet conditions
  inlet = Medium.setState_ph(su.p,inStream(su.h_outflow));
  p_su = su.p;

  V_dot_leak = A_leak*C_thr;
  // Première partie de la tuyère : isentropique
  // Etat au col de la tuyère
  throat = Medium.setState_ps(p_thr, inlet.s);
  // Conservation de l'énergie
  inlet.h = throat.h + 0.5*C_thr^2;

  su.m_flow = V_dot_leak*throat.d;

  // Selecting between subsonic and choked flows:
  p_thr = noEvent(max(p_choked,p_ex));

  // Outlet conditions:
  outlet = Medium.setState_ph(p_ex,inlet.h);
  p_ex = ex.p;

  // Mass flows
  su.m_flow + ex.m_flow = 0;

  // The valve is isenthalpic in both directions:
  su.h_outflow = 1E5;//inStream(ex.h_outflow);
  ex.h_outflow = inStream(su.h_outflow);

  if Use_gamma then
  //Identification of a fictitious gamma value that allows modeling the isentropic expansion as a perfect gas using the equation:
  //     inlet.p/inlet.d^gamma = throat.p/throat.d^gamma;
  //gamma = homotopy(log(inlet.p/throat.p)/log(inlet.d/throat.d), gamma_start);
  gamma = log(inlet.p/throat.p)/log(inlet.d/throat.d);
  //Calculation of the critical pressure using the fictitious gamma value:
  p_choked = inlet.p*(2/(gamma+1))^(gamma/(gamma-1));
  //setting the unused variables to dummy values
  throat_choked = Medium.setState_dT(20,273.15+100);
  rho_choked = 0;
  C_choked = 0;
  else
  rho_choked = su.m_flow/(A_leak * C_choked);
  throat_choked = Medium.setState_ps(p_choked,inlet.s);
  throat_choked.a = C_choked;
  rho_choked = throat_choked.d;
  gamma = 1;
  end if;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-92,84},{90,-74}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-84,32},{-48,30},{0,8},{70,6},{82,6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,0},{-24,0},{32,0},{70,0},{82,0}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,48},{-36,48},{22,14},{78,10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5),
          Line(
            points={{-84,-32},{-48,-30},{0,-8},{70,-6},{82,-6}},
            color={85,170,255},
            smooth=Smooth.Bezier),
          Line(
            points={{-80,-48},{-36,-48},{22,-14},{78,-10}},
            color={0,0,0},
            smooth=Smooth.Bezier,
            thickness=0.5)}));
  end Nozzle;

  model Isothermal_wall
  Modelica.SIunits.TemperatureSlope der_T(start=0);
  parameter Modelica.SIunits.HeatCapacity C = 400;
  parameter Modelica.SIunits.ThermalConductance AU_amb = 10;
  Modelica.SIunits.Power Q_dot_amb;
  Modelica.SIunits.Temperature T_wall(start = 290);
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Compresseur
      annotation (Placement(transformation(extent={{-16,58},{16,90}}),
          iconTransformation(extent={{-8,16},{6,30}})));
    //Pertes venant du compresseur
    Modelica.Blocks.Interfaces.RealInput W_dot_loss annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=90,
          origin={-74,32}), iconTransformation(
          extent={{6,6},{-6,-6}},
          rotation=90,
          origin={-60,18})));
    //Température ambiante en entrée
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Ambient
      annotation (Placement(transformation(extent={{-16,-98},{16,-66}}),
          iconTransformation(extent={{-8,-30},{6,-16}})));
  equation
  Q_dot_amb = AU_amb*(Ambient.T - T_wall);
  Ambient.Q_flow = Q_dot_amb;
  C*der_T = Compresseur.Q_flow + Q_dot_amb + W_dot_loss;
  Compresseur.T = T_wall;
  der_T = der(T_wall);
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={      Rectangle(
            extent={{-100,16},{100,-16}},
            lineColor={0,0,0},
            fillColor={128,128,128},
            fillPattern=FillPattern.Solid), Text(
            extent={{-92,8},{98,-10}},
            lineColor={0,0,0},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid,
            textString="Fictitious isothermal wall")}), Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
  end Isothermal_wall;

  model Volumetric_compression
    "Model of a volumetric compression including swept volume and under and over-expansion losses"
    import ThermoCycle;
  replaceable package Medium = ThermoCycle.Media.DummyFluid;
  Medium.ThermodynamicState inlet(s(start=Medium.specificEntropy_pT(P_su_start,T_su_start)));
  Medium.ThermodynamicState inside;
  Medium.ThermodynamicState outlet;
  Medium.Density rho_su(start=Medium.density_pT(P_su_start,T_su_start));
  Medium.SpecificEnthalpy h_s;
  parameter Medium.Temperature T_su_start = 273.15 + 20
      "Fluid temperature start value, inlet"     annotation (Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure P_su_start = 6e5
      "Fluid pressure start value, inlet"     annotation (Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure P_ex_start = 20e5
      "Fluid pressure start value, outlet"     annotation (Dialog(tab="Initialization"));
  Medium.AbsolutePressure P_ad(start = P_su_start*r_v_in,stateSelect = StateSelect.prefer);
  parameter Real r_v_in = 2.55;
  parameter Modelica.SIunits.Volume V_s=100e-6 "Compressor swept Volume";

  Modelica.SIunits.AngularFrequency N_rot "Compressor rotational speed in Hz";
  Modelica.SIunits.SpecificEnergy w_1;
  Modelica.SIunits.SpecificEnergy w_2;
  Modelica.SIunits.Power W_dot_in;
  Modelica.SIunits.AngularVelocity omega_m
      "Angular velocity of the shaft [rad/s] ";

    ThermoCycle.Interfaces.Fluid.FlangeA su(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22)
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    ThermoCycle.Interfaces.Fluid.FlangeB ex(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22)
                                              annotation (Placement(transformation(
            extent={{90,-10},{110,10}}),
                                       iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc annotation (
        Placement(transformation(extent={{-20,32},{12,64}}),iconTransformation(
            extent={{-10,42},{8,60}})));
  equation
  //Flow rate calculation
  su.m_flow = N_rot * V_s * rho_su;

  //Thermodynamic states
  inlet = Medium.setState_ph(su.p,inStream(su.h_outflow));
  outlet = Medium.setState_ph(ex.p,ex.h_outflow);

  //Using preferably functions for which the derivative is defined:
  rho_su = Medium.density_ph(su.p,inStream(su.h_outflow));

  //Internal thermodynamic state
  inside = Medium.setState_ps(P_ad,inlet.s);

  //After the isentropic expansion
  h_s = Medium.specificEnthalpy_ps(P_ad,inlet.s);
  rho_su*r_v_in = Medium.density_ph(P_ad,h_s);

  //Flow rate:
  su.m_flow + ex.m_flow = 0;

  //Enthalpies
  su.h_outflow = inStream(ex.h_outflow); //by pass in case of flow reversal
  ex.h_outflow = inlet.h + w_1 + w_2;

  //Isentropic compression
  w_1 = (h_s-inlet.h);

  //Constant-volume compression
  w_2 = (ex.p - P_ad) / inside.d;

  //Internal compression power:
  W_dot_in = su.m_flow*(w_1 + w_2);

  //Mechanical port
  omega_m = der(flange_elc.phi);
  omega_m = 2*N_rot*Modelica.Constants.pi;
  flange_elc.tau = W_dot_in/(2*N_rot*Modelica.Constants.pi);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={
          Polygon(
            points={{-100,-80},{20,-40},{100,-40},{100,40},{20,40},{-100,80},{-100,
                -80}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-27,17},{27,-17}},
            lineColor={0,0,255},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid,
            textString="s=Cst",
            origin={-43,-3},
            rotation=0),
          Text(
            extent={{-27,17},{27,-17}},
            lineColor={0,0,255},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid,
            origin={51,-3},
            rotation=0,
            textString="V=Cst")}));
  end Volumetric_compression;

  model Mechanical_losses
    "Computes the Mechanical losses as a sum of different contributions (constant losses, proportional losses, friction torque)"
  parameter Modelica.SIunits.Power W_dot_loss_0 = 0 "Constant losses";
  parameter Real alpha = 0
      "Proportionality factor (Wdot_loss = alpha*Wdot_tot)";
  parameter Modelica.SIunits.Torque T_friction= 0
      "Friction torque (Wdot_loss = 2*pi*N_rot*T_friction)";
  Modelica.SIunits.Power W_dot_loss;
  Modelica.SIunits.Power W_dot_propor;
  Modelica.SIunits.Power W_dot_friction;
  Modelica.SIunits.Power W_dot_A;
  Modelica.SIunits.Power W_dot_B;
  Modelica.SIunits.AngularVelocity omega
      "Angular velocity of the shaft [rad/s] ";

    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_A      annotation (
        Placement(transformation(extent={{-116,-16},{-84,16}}),
                                                            iconTransformation(
            extent={{-112,-10},{-92,10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_B      annotation (
        Placement(transformation(extent={{84,-16},{116,16}}),
                                                            iconTransformation(
            extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealOutput Wdot_loss  annotation (Placement(transformation(
          extent={{-16,-16},{16,16}},
          rotation=0,
          origin={98,-68}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={82,-50})));
  equation
  omega = der(flange_A.phi);

  W_dot_A = omega  * flange_A.tau;
  W_dot_B = -omega  * flange_B.tau;
  flange_A.phi = flange_B.phi;

  W_dot_loss = W_dot_loss_0 + W_dot_propor + W_dot_friction;
  Wdot_loss = W_dot_loss;

  W_dot_propor = alpha* abs(W_dot_A);
  W_dot_friction = abs(omega*T_friction);

  W_dot_B = W_dot_A - W_dot_loss;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-102,10},{98,-10}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(extent={{-62,-10},{58,-60}}, lineColor={0,0,0}),
          Rectangle(
            extent={{-62,-10},{58,-25}},
            lineColor={0,0,0},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-62,-45},{58,-61}},
            lineColor={0,0,0},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,-18},{48,-50}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{58,-60},{58,-70},{73,-70},{73,-80},{-77,-80},{-77,-70},{-62,-70},
                {-62,-60},{58,-60}},
            lineColor={0,0,0},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid),
          Line(points={{-77,-10},{-77,-70}}, color={0,0,0}),
          Line(points={{73,-10},{73,-70}}, color={0,0,0}),
          Rectangle(extent={{-62,60},{58,10}}, lineColor={0,0,0}),
          Rectangle(
            extent={{-62,60},{58,45}},
            lineColor={0,0,0},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-62,25},{58,10}},
            lineColor={0,0,0},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-52,51},{48,19}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-77,70},{-77,10}}, color={0,0,0}),
          Polygon(
            points={{58,60},{58,70},{73,70},{73,80},{-77,80},{-77,70},{-62,70},{-62,
                60},{58,60}},
            lineColor={0,0,0},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid),
          Line(points={{73,70},{73,10}}, color={0,0,0}),
          Text(
            extent={{-152,130},{148,90}},
            textString="%name",
            lineColor={0,0,255})}));
  end Mechanical_losses;

  model ScrollCompressor "Semi-empirical model of hermetic scroll compressor"
    import ThermoCycle;

  parameter Real r_v_in=2.55 "Built-in volume ratio";
  parameter Modelica.SIunits.Volume Vs=97.7e-6 "Swept volume";
  parameter Modelica.SIunits.ThermalConductance AU_amb=5.382
      "Heat transfer conductance for the ambient heat losses";
  parameter Modelica.SIunits.ThermalConductance AU_su=18
      "Heat transfer conductance for the inlet heat exchange";
  parameter Modelica.SIunits.ThermalConductance AU_ex=35
      "Heat transfer conductance for the outlet heat exchange";
  parameter Modelica.SIunits.Area A_leak=4.5e-7
      "Leakage equivalent orifice area";
  parameter Modelica.SIunits.Power Wdot_loss_0=242
      "Constant (electro)mechanical losses";
  parameter Real alpha=0.2 "Proportionality factor for the proportional losses";
  parameter Modelica.SIunits.Length d_ex=0.0075
      "Exhaust pressure drop equivalent orifice diameter";
  parameter Modelica.SIunits.Length d_su=0.1
      "Supply pressure drop equivalent orifice diameter";
  parameter Modelica.SIunits.Mass m=20 "Total mass of the compressor";
  parameter Modelica.SIunits.SpecificHeatCapacity c=466
      "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Inertia J=0.02 "Moment of inertia of the rotor";

  parameter Modelica.SIunits.Temperature T_su_start = 273.15 + 20
      "Fluid temperature start value, inlet"     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_ex_start = 273.15 + 100
      "Fluid temperature start value, inlet"     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.AbsolutePressure p_su_start = 6e5
      "Fluid pressure start value, inlet"     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.AbsolutePressure p_ex_start = 20e5
      "Fluid pressure start value, outlet"     annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate Mdot_nom=0.13
      "Nominal Mass Flow rate"                                                    annotation (Dialog(tab="Initialization"));

    ThermoCycle.Components.Units.PdropAndValves.DP dp_su(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      constinit=false,
      UseNom=false,
      DELTAp_quad_nom=0,
      use_rho_nom=true,
      UseHomotopy=false,
      A=Modelica.Constants.pi*d_su^2/4,
      p_nom=p_su_start,
      T_nom=T_su_start,
      Mdot_nom=Mdot_nom)
      annotation (Placement(transformation(extent={{-138,-50},{-110,-22}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.Isothermal_wall
                    paroi_isotherme(C=m*c, AU_amb=AU_amb)
      annotation (Placement(transformation(extent={{-100,-100},{110,-42}})));
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ElectricDrive electricDrive(fstart=50, Np=1)
      annotation (Placement(transformation(extent={{-106,36},{-140,70}})));
    ThermoCycle.Components.Units.HeatExchangers.Semi_isothermal_HeatExchanger
                                  HX_su(redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
                                                                               AU=
         AU_su)
      annotation (Placement(transformation(extent={{-100,-52},{-66,-20}})));
    ThermoCycle.Components.Units.HeatExchangers.Semi_isothermal_HeatExchanger
                                  HX_ex(redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
                                                                               AU=
         AU_ex)
      annotation (Placement(transformation(extent={{58,-52},{90,-20}})));
    ThermoCycle.Components.Units.PdropAndValves.DP dp_ex(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      constinit=false,
      UseNom=false,
      UseHomotopy=false,
      A=Modelica.Constants.pi*d_ex^2/4,
      p_nom=p_ex_start,
      T_nom=T_ex_start,
      Mdot_nom=Mdot_nom,
      DELTAp_quad_nom=20000)
      annotation (Placement(transformation(extent={{104,-48},{128,-24}})));
    Nozzle         Internal_leakage(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      Use_gamma=false,
      A_leak=A_leak,
      P_su_start=p_ex_start,
      T_su_start=T_ex_start,
      P_ex_start=p_su_start)
      annotation (Placement(transformation(extent={{26,-36},{-12,-10}})));
    Volumetric_compression
                  compression_4_1(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      r_v_in=r_v_in,
      V_s=Vs,
      T_su_start=T_su_start,
      P_su_start=p_su_start,
      P_ex_start=p_ex_start)
      annotation (Placement(transformation(extent={{-24,-12},{36,40}})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(
      phi(start=0),
      w(start=300),
      a(start=0),
      J=J)
      annotation (Placement(transformation(extent={{-62,40},{-88,66}})));
    Mechanical_losses mechanical_losses(                         alpha=alpha,
        W_dot_loss_0=Wdot_loss_0)
      annotation (Placement(transformation(extent={{-12,40},{-42,66}})));
    ThermoCycle.Interfaces.Fluid.FlangeA su(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22)
      annotation (Placement(transformation(extent={{-166,-42},{-154,-30}}),
          iconTransformation(extent={{-74,-26},{-66,-18}})));
    ThermoCycle.Interfaces.Fluid.FlangeB ex(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22)
                                              annotation (Placement(transformation(
            extent={{154,-44},{170,-28}}),
                                       iconTransformation(extent={{66,20},{74,28}})));
    Modelica.Blocks.Interfaces.RealInput frequency annotation (Placement(
          transformation(extent={{-172,64},{-132,104}}), iconTransformation(
            extent={{62,-42},{50,-30}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Ambient
      annotation (Placement(transformation(extent={{-4,-104},{12,-88}}),
          iconTransformation(extent={{-4,-90},{4,-82}})));
  equation

    connect(compression_4_1.flange_elc, mechanical_losses.flange_A) annotation (
        Line(
        points={{5.7,27.26},{5.7,53},{-11.7,53}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(inertia.flange_a, mechanical_losses.flange_B) annotation (Line(
        points={{-62,53},{-42,53}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(compression_4_1.ex, HX_ex.supply)                   annotation (Line(
        points={{36,14},{46,14},{46,-36},{57.68,-36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(Internal_leakage.su, HX_ex.supply)                   annotation (Line(
        points={{26.38,-22.74},{46,-22.74},{46,-36},{57.68,-36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(electricDrive.shaft, inertia.flange_b) annotation (Line(
        points={{-108.38,53},{-88,53}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(dp_su.OutFlow, HX_su.supply)                annotation (Line(
        points={{-111.4,-36},{-100.34,-36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(paroi_isotherme.W_dot_loss, mechanical_losses.Wdot_loss) annotation (
        Line(
        points={{-58,-65.78},{-58,46.5},{-39.3,46.5}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(paroi_isotherme.Compresseur, HX_ex.port_th)
      annotation (Line(
        points={{3.95,-64.33},{3.95,-58},{74,-58},{74,-51.04}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(paroi_isotherme.Compresseur, HX_su.port_th)
      annotation (Line(
        points={{3.95,-64.33},{3.95,-58},{-83,-58},{-83,-51.04}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(HX_su.exhaust, Internal_leakage.ex)                  annotation (
        Line(
        points={{-66.34,-35.68},{-39.17,-35.68},{-39.17,-22.74},{-12,-22.74}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(HX_su.exhaust, compression_4_1.su)                  annotation (
        Line(
        points={{-66.34,-35.68},{-40,-35.68},{-40,14},{-24,14}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(HX_ex.exhaust, dp_ex.InFlow)                   annotation (Line(
        points={{89.68,-35.68},{96.84,-35.68},{96.84,-36},{105.2,-36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(dp_ex.OutFlow, ex) annotation (Line(
        points={{126.8,-36},{162,-36}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(frequency, electricDrive.f) annotation (Line(
        points={{-152,84},{-123.68,84},{-123.68,68.98}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Ambient, paroi_isotherme.Ambient) annotation (Line(
        points={{4,-96},{4,-77.67},{3.95,-77.67}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(su, dp_su.InFlow) annotation (Line(
        points={{-160,-36},{-136.6,-36}},
        color={0,0,255},
        smooth=Smooth.None));
     annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
              -100},{160,100}}),      graphics={
          Text(
            extent={{-4,-32},{28,-38}},
            lineColor={0,0,0},
            lineThickness=0.5,
            textString="Leak"),
          Text(
            extent={{-100,-16},{-68,-22}},
            lineColor={0,0,0},
            lineThickness=0.5,
            textString="HX1"),
          Text(
            extent={{58,-16},{90,-22}},
            lineColor={0,0,0},
            lineThickness=0.5,
            textString="HX2")}),                 Icon(coordinateSystem(extent={{-160,
              -100},{160,100}}, preserveAspectRatio=false), graphics={
          Ellipse(
            extent={{-60,74},{60,-26}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,30},{60,-90}},
            lineColor={0,0,0},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            lineThickness=0.5),
          Rectangle(
            extent={{-76,-16},{-60,-30}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{60,30},{76,16}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{26,-8},{60,-50}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-66,96},{68,74}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p><h4><font color=\"#008000\">Short Description :</font></h4></p>
<p>This model describes a hermetic scroll compressor. The model involves a limited number of parameters physically meaningful. The model accounts for the supply heating-up and exhaust cooling down of the gas, an internal leakage, the internal compression ratio and the electromechanical losses. The model is the one proposed by Winandy et al. (2002). Information used to identify the parameters is extracted from Copeland&apos;s catalogue (ZR72KC-TFD)</p>
<p><br/><h4>Nomenclature :</h4></p>
<p>A                                        Area, m^2</p>
<p>AU                                        Global heat transfer coefficient, W/K</p>
<p>c_p                                        Specific heat, J/kg-K</p>
<p>corr                                        Correction factor for the swept volume, -</p>
<p>d                                        Diameter, m</p>
<p>h                                        Specific enthalpy, J/kg</p>
<p>M_dot                                        Mass flow rate        , kg/s</p>
<p>NTU                                        Number of transfer units,-</p>
<p>N_rot                                        Rotational speed, rpm</p>
<p>p                                        Pressure, Pa</p>
<p>Q_dot                                        Thermal power, W</p>
<p>R                                        Thermal resistance, K/W</p>
<p>r_p                                        Pressure ratio,-</p>
<p>r_v_in                                        Internal built-in volume ratio,-</p>
<p>s                                        Specific entropy, J/kg-K</p>
<p>t                                        Temperature, C</p>
<p>u                                        Specific internal energy, J/kg</p>
<p>v                                        Specific volume, m^3/kg</p>
<p>V_dot_s                                        Swept volume, m^3/s</p>
<p>W_dot                                        Electrical power, W</p>
<p>x                                        quality,-</p>
<p><br/><h4>Greek symbols</h4></p>
<p>alpha                        Proportionality factor for electro-mechanical losses proportional to the internal power</p>
<p>DELTAt                        Temperature difference, K</p>
<p>epsilon                        Efficiency,-</p>
<p>gamma                        Isentropic coefficient,-</p>
<p>m3h                        Cubic meters per hour</p>
<p>rho                        Density, kg m-3</p>
<p><br/><h4>Subscripts</h4></p>
<p>amb                                Ambient</p>
<p>calc                                Calculated</p>
<p>cd                                Condenser</p>
<p>cp                                Compressor</p>
<p>crit                                Critic</p>
<p>ev                                Evaporator</p>
<p>ex                                Exhaust</p>
<p>ex2                                Exhaust before cooling exhaust down</p>
<p>ex1                                Exhaust before exhaust pressure drop</p>
<p>n                                Internal</p>
<p>in*                                Corrected internal</p>
<p>leak                                Leakage</p>
<p>loss                                Electro-mechanical losses</p>
<p>loss0                                Constant electro-mechanical losses</p>
<p>man                                Manufacturer (in Figures)</p>
<p>n                                Nominal</p>
<p>oh                                Over-heating</p>
<p>r                                Refrigerant</p>
<p>s                                Isentropic</p>
<p>s                                Swept volume</p>
<p>sat                                Saturation</p>
<p>sc                                Sub-cooling</p>
<p>su                                Supply</p>
<p>su1                                Supply after supply heating-up</p>
<p>su2                                Supply after mixing with internal mixing</p>
<p>thr                                Throat</p>
<p>w                                Water, enveloppe</p>
<p><br/><h4>References :</h4></p>
<p>[1] Winandy, E., C., Saavedra O., J., Lebrun (2002) Experimental analysis and simplified modelling of a hermetic scrol refrigeration compressor. Applied thermal Engineering 22, 107-120.</p>
<p><br/><h4>Disclaimer</h4></p>
<p>the accuracy or reliability of information presented in this model is not guaranteed or warranted in any way. Every use of this model, for commercial purpose or not, incurs liability of the user only. this model is freely distributed and may not be sold or distributed for commercial purpose. the user is asked to cite his sources and the origin of this model.</p>
<p>!Help us improving this model : any feedback comment is very welcome </p>
<p><br/>Date : January 2014</p>
<p>Authors: Sylvain Quoilin</p>
<p>University of Li&egrave;ge</p>
<p>Faculty of Applied Sciences</p>
<p>thermodynamics Laboratory</p>
<p>Campus of Sart-tilman, B49 (P33)</p>
<p>B-4000 LIEGE (BELGIUM)</p>
<p>Contact: squoilin@ulg.ac.be</p>
<p>website : www.labothap.ulg.ac.be</p>
</html>"));
  end ScrollCompressor;

  model test_ScrollCompressor
    "Semi-empirical model of hermetic scroll compressor"
    import ThermoCycle;

  parameter Real r_v_in=2.55 "Built-in volume ratio";
  parameter Modelica.SIunits.Volume Vs=97.7e-6 "Swept volume";
  parameter Modelica.SIunits.ThermalConductance AU_amb=5.382
      "Heat transfer conductance for the ambient heat losses";
  parameter Modelica.SIunits.ThermalConductance AU_su=18
      "Heat transfer conductance for the inlet heat exchange";
  parameter Modelica.SIunits.ThermalConductance AU_ex=35
      "Heat transfer conductance for the outlet heat exchange";
  parameter Modelica.SIunits.Area A_leak=4.5e-7
      "Leakage equivalent orifice area";
  parameter Modelica.SIunits.Power Wdot_loss_0=242
      "Constant (electro)mechanical losses";
  parameter Real alpha=0.2 "Proportionality factor for the proportional losses";
  parameter Modelica.SIunits.Length d_ex=0.0075
      "Exhaust pressure drop equivalent orifice diameter";
  parameter Modelica.SIunits.Length d_su=0.1
      "Supply pressure drop equivalent orifice diameter";
  parameter Modelica.SIunits.Mass m=20 "Total mass of the compressor";
  parameter Modelica.SIunits.SpecificHeatCapacity c=466
      "Specific heat capacity of the metal";
  parameter Modelica.SIunits.Inertia J=0.02 "Moment of inertia of the rotor";

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP Sink(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      h=490000,
      p0=1730000)
      annotation (Placement(transformation(extent={{30,20},{50,40}})));

    ThermoCycle.Components.FluidFlow.Reservoirs.SinkP Source(
      redeclare package Medium =
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.ScrollCompressor.R22,
      h=445000,
      p0=600000)
      annotation (Placement(transformation(extent={{-108,-30},{-128,-10}})));
    Modelica.Blocks.Sources.Sine sine(
      freqHz=0.02,
      offset=293,
      amplitude=0)
      annotation (Placement(transformation(extent={{-122,-76},{-102,-56}})));
    Modelica.Blocks.Sources.Sine sine1(
      freqHz=0.1,
      offset=50,
      amplitude=0)
      annotation (Placement(transformation(extent={{116,-22},{96,-2}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
      prescribedTemperature
      annotation (Placement(transformation(extent={{-74,-76},{-54,-56}})));
    ScrollCompressor scrollCompressor
      annotation (Placement(transformation(extent={{-50,-40},{34,14}})));
  equation

    connect(sine.y, prescribedTemperature.T) annotation (Line(
        points={{-101,-66},{-76,-66}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(prescribedTemperature.port, scrollCompressor.Ambient) annotation (
        Line(
        points={{-54,-66},{-8,-66},{-8,-36.22}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(Source.flangeB, scrollCompressor.su) annotation (Line(
        points={{-109.6,-20},{-98,-20},{-98,-18.94},{-26.375,-18.94}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sine1.y, scrollCompressor.frequency) annotation (Line(
        points={{95,-12},{64,-12},{64,-22.72},{6.7,-22.72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Sink.flangeB, scrollCompressor.ex) annotation (Line(
        points={{31.6,30},{20,30},{20,-6.52},{10.375,-6.52}},
        color={0,0,255},
        smooth=Smooth.None));
     annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
              -100},{160,100}}),      graphics), Icon(coordinateSystem(extent={{-160,
              -100},{160,100}}, preserveAspectRatio=false), graphics={
          Ellipse(
            extent={{-60,96},{60,-4}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,52},{60,-68}},
            lineColor={0,0,0},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            lineThickness=0.5),
          Rectangle(
            extent={{-76,6},{-60,-8}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{60,52},{76,38}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{8,14},{42,-28}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-66,-74},{68,-96}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="%name")}),
      experiment(StopTime=50),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p><h4><font color=\"#008000\">Short Description :</font></h4></p>
<p>This model describes a hermetic scroll compressor. The model involves a limited number of parameters physically meaningful. The model accounts for the supply heating-up and exhaust cooling down of the gas, an internal leakage, the internal compression ratio and the electromechanical losses. The model is the one proposed by Winandy et al. (2002). Information used to identify the parameters is extracted from Copeland&apos;s catalogue (ZR72KC-TFD)</p>
<p><br/><h4>Nomenclature :</h4></p>
<p>A                                        Area, m^2</p>
<p>AU                                        Global heat transfer coefficient, W/K</p>
<p>c_p                                        Specific heat, J/kg-K</p>
<p>corr                                        Correction factor for the swept volume, -</p>
<p>d                                        Diameter, m</p>
<p>h                                        Specific enthalpy, J/kg</p>
<p>M_dot                                        Mass flow rate        , kg/s</p>
<p>NTU                                        Number of transfer units,-</p>
<p>N_rot                                        Rotational speed, rpm</p>
<p>p                                        Pressure, Pa</p>
<p>Q_dot                                        Thermal power, W</p>
<p>R                                        Thermal resistance, K/W</p>
<p>r_p                                        Pressure ratio,-</p>
<p>r_v_in                                        Internal built-in volume ratio,-</p>
<p>s                                        Specific entropy, J/kg-K</p>
<p>t                                        Temperature, C</p>
<p>u                                        Specific internal energy, J/kg</p>
<p>v                                        Specific volume, m^3/kg</p>
<p>V_dot_s                                        Swept volume, m^3/s</p>
<p>W_dot                                        Electrical power, W</p>
<p>x                                        quality,-</p>
<p><br/><h4>Greek symbols</h4></p>
<p>alpha                        Proportionality factor for electro-mechanical losses proportional to the internal power</p>
<p>DELTAt                        Temperature difference, K</p>
<p>epsilon                        Efficiency,-</p>
<p>gamma                        Isentropic coefficient,-</p>
<p>m3h                        Cubic meters per hour</p>
<p>rho                        Density, kg m-3</p>
<p><br/><h4>Subscripts</h4></p>
<p>amb                                Ambient</p>
<p>calc                                Calculated</p>
<p>cd                                Condenser</p>
<p>cp                                Compressor</p>
<p>crit                                Critic</p>
<p>ev                                Evaporator</p>
<p>ex                                Exhaust</p>
<p>ex2                                Exhaust before cooling exhaust down</p>
<p>ex1                                Exhaust before exhaust pressure drop</p>
<p>n                                Internal</p>
<p>in*                                Corrected internal</p>
<p>leak                                Leakage</p>
<p>loss                                Electro-mechanical losses</p>
<p>loss0                                Constant electro-mechanical losses</p>
<p>man                                Manufacturer (in Figures)</p>
<p>n                                Nominal</p>
<p>oh                                Over-heating</p>
<p>r                                Refrigerant</p>
<p>s                                Isentropic</p>
<p>s                                Swept volume</p>
<p>sat                                Saturation</p>
<p>sc                                Sub-cooling</p>
<p>su                                Supply</p>
<p>su1                                Supply after supply heating-up</p>
<p>su2                                Supply after mixing with internal mixing</p>
<p>thr                                Throat</p>
<p>w                                Water, enveloppe</p>
<p><br/><h4>References :</h4></p>
<p>[1] Winandy, E., C., Saavedra O., J., Lebrun (2002) Experimental analysis and simplified modelling of a hermetic scrol refrigeration compressor. Applied thermal Engineering 22, 107-120.</p>
<p><br/><h4>Disclaimer</h4></p>
<p>the accuracy or reliability of information presented in this model is not guaranteed or warranted in any way. Every use of this model, for commercial purpose or not, incurs liability of the user only. this model is freely distributed and may not be sold or distributed for commercial purpose. the user is asked to cite his sources and the origin of this model.</p>
<p>!Help us improving this model : any feedback comment is very welcome </p>
<p><br/>Date : January 2014</p>
<p>Authors: Sylvain Quoilin</p>
<p>University of Li&egrave;ge</p>
<p>Faculty of Applied Sciences</p>
<p>thermodynamics Laboratory</p>
<p>Campus of Sart-tilman, B49 (P33)</p>
<p>B-4000 LIEGE (BELGIUM)</p>
<p>Contact: squoilin@ulg.ac.be</p>
<p>website : www.labothap.ulg.ac.be</p>
</html>"));
  end test_ScrollCompressor;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-50,84},{70,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,40},{70,-80}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-66,-6},{-50,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{86,26}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,2},{70,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end ScrollCompressor;
