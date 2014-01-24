within ThermoCycle.Components.Units;
package ExpansionAndCompressionMachines
  extends Modelica.Icons.Package;

  model Expander "Generic expander model"
   /****************************************** FLUID ******************************************/
  replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
   /*Ports */
  public
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc
      "Flange of shaft" annotation (Placement(transformation(extent={{64,-8},{
              100,28}}, rotation=0), iconTransformation(extent={{68,-2},{92,22}})));
    Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-78,36},{-58,56}}),
          iconTransformation(extent={{-78,36},{-58,56}})));
    Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
                 Medium)
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  /****************************************** SELECT TYPE OF EXPANDER ******************************************/
    import ThermoCycle.Functions.Enumerations.ExpTypes;
  parameter ExpTypes ExpType=ExpTypes.UD;
  parameter Real epsilon_s=0.7 "Isentropic Efficiency"
      annotation (Dialog(enable=(ExpType == ExpTypes.UD)));

    /****************************************** PARAMETERES ******************************************/
    parameter Real FF_exp=1 "Filling factor"
      annotation (Dialog(enable=(ExpType == ExpTypes.UD)));
    parameter Modelica.SIunits.Volume V_s "Swept volume";
    parameter Real epsilon_start=0.5782 "Isentropic Efficiency"
      annotation (Dialog(tab="Initialization"));
    parameter Real FF_start=0.00003915 "Filling factor"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_su_start=23.39e5
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_ex_start=1.77175e5
      "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_su_start=423.15
      "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
      "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, T_su_start)
      "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
    parameter Boolean constPinit=false
      "if true, sets the evaporating pressure to a constant value at the beginning of the simulation in order to avoid oscillations"
      annotation (Dialog(group="Intialization options",tab="Initialization"));
    parameter Boolean constinit=false
      "if true, sets the efficiencies to a constant value at the beginning of the simulation"
      annotation (Dialog(group="Intialization options",tab="Initialization"));
    parameter Modelica.SIunits.Time t_init=10
      "if constinit is true, time during which the efficiencies are set to their start values"
      annotation (Dialog(group="Intialization options",tab="Initialization", enable=constinit));

    /****************************************** VARIABLES ******************************************/
    Medium.ThermodynamicState steamIn
      "Thermodynamic state of the fluid at the inlet";
    Medium.ThermodynamicState steamOut
      "Thermodynamic state of the fluid at the outlet - isentropic";
    Real epsilon(start=epsilon_start);
    Real FF( start=FF_start);
    Real rpm;
    Modelica.SIunits.Frequency N_rot(start=48.3);
    Modelica.SIunits.Power W_dot;
    Modelica.SIunits.VolumeFlowRate V_dot_su;
    Modelica.SIunits.MassFlowRate M_dot;
    Medium.Density rho_su(start=40);
    Medium.SpecificEntropy s_su;
    Medium.SpecificEnthalpy h_su(start=h_su_start);
    Medium.SpecificEnthalpy h_ex(start=h_ex_start);
    Medium.AbsolutePressure p_su(
      min=1E5,
      max=28E5,
      start=p_su_start);
    Medium.AbsolutePressure p_ex(
      min=1E5,
      max=10E5,
      start=p_ex_start);
    Medium.SpecificEnthalpy h_ex_s;
  equation
    /* Fluid Properties */
    steamIn = Medium.setState_ph(p_su,h_su);
    rho_su = Medium.density(steamIn);
    s_su = Medium.specificEntropy(steamIn);
    steamOut = Medium.setState_ps(p_ex,s_su);
    h_ex_s = Medium.specificEnthalpy(steamOut);
    /*equations */
    rpm = N_rot*60;
    V_dot_su = FF*V_s*N_rot;
    V_dot_su = M_dot/rho_su;
    h_ex = h_su - (h_su - h_ex_s)*epsilon;
    W_dot = M_dot*(h_su - h_ex) "Power generated";
  if (ExpType == ExpTypes.ODExp) then
      FF = ThermoCycle.Functions.correlation_open_expander_FF(rho=rho_su,
        log_Nrot=log(rpm));
      epsilon = ThermoCycle.Functions.correlation_open_expander_epsilon_s(
            rho=rho_su,
            log_rp=log(p_su/p_ex),
            N_rot=rpm);
  elseif (ExpType == ExpTypes.ORCNext) then
    FF= ThermoCycle.Functions.TestRig.GenericScrewExpander_FillingFactor(
                                                             p_su_exp= p_su,rho_su_exp= rho_su,rpm=N_rot*60);  // V_s has to be set ugual to 1 [m3]
      epsilon = ThermoCycle.Functions.TestRig.GenericScrewExpander_IsentropicEfficiency(
            rp=p_su/p_ex,
            rpm=N_rot*60,
            p=p_su);
  elseif (ExpType == ExpTypes.HermExp) then
      FF = ThermoCycle.Functions.correlation_hermetic_scroll_FF(rho=rho_su,
        rp=p_su/p_ex);
      epsilon = ThermoCycle.Functions.correlation_hermetic_scroll_epsilon_s(
        rho=rho_su, rp=p_su/p_ex);
    else
    FF = FF_exp;
    epsilon = epsilon_s;
  end if;

     //BOUNDARY CONDITIONS //
     /* Enthalpies */
    h_su = if noEvent(InFlow.m_flow <= 0) then h_ex else inStream(InFlow.h_outflow);
    h_su = InFlow.h_outflow;
    OutFlow.h_outflow = if noEvent(OutFlow.m_flow <= 0) then h_ex else inStream(
      OutFlow.h_outflow);

     /*Mass flows */
     M_dot = InFlow.m_flow;
     OutFlow.m_flow = -M_dot;
     /*pressures */
    //flange.p = vapor_su.p;
    InFlow.p = p_su;
    OutFlow.p = p_ex;
  // Mechanical port:
    der(flange_elc.phi) = 2*N_rot*Modelica.Constants.pi;
    flange_elc.tau = W_dot/(2*N_rot*Modelica.Constants.pi)
    annotation (Diagram(graphics));

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false,extent={{-120,-120},{120,120}}), graphics={
            Text(
            extent={{-68,-44},{74,-72}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,0},
            textString="Expander"),
                                Polygon(
            points={{-60,40},{-60,-20},{80,-60},{80,80},{-60,40}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
          
         <p><big>The <b>Expander</b>  model represents the expansion of a fluid in a volumetric machine. It is a lumped model based on performance curves. It is characterized by two flow connector for the fluid inlet and outlet and by a mechanical connector for the connection with the generator.
        <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> Isentropic efficiency based on empirical performance curve
         <li> Filling factor based on empirical performance curve
         </ul>
      <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following option is availabe:
        <ul><li>ExpType: it changes the performance curves for isentropic efficiency and filling factor. </ul> 
        </HTML>"));
  end Expander;

  model ExpanderOpendriveDetailed
    "Detailed expander model (oil free, open-drive)"
  //2. PORTS AND FLUIDS
  //=============================
     Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc
      "Flange of shaft"
      annotation (Placement(transformation(extent={{64,-8},{100,28}},  rotation=0),
          iconTransformation(extent={{68,-2},{92,22}})));
  replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
    Medium.ThermodynamicState  fluid_su(p(start=p_su_start),T(start=T_su_start));
    Medium.ThermodynamicState  fluid_su1(p(start=p_su1_start),T(start=T_su1_start));
    Medium.ThermodynamicState  fluid_su2(p(start=p_su2_start),T(start=T_su2_start));
    Medium.ThermodynamicState  fluid_thr(p(start=p_thr_start),h(start=h_thr_start));
    Medium.ThermodynamicState  fluid_in(p(start=p_in_start),d(start=1/v_in_start));
    Medium.ThermodynamicState  fluid_ex1(p(start=p_ex1_start),h(start=h_ex1_start));
    Medium.ThermodynamicState  fluid_ex2(p(start=p_ex2_start),h(start=h_ex2_start));
    Medium.ThermodynamicState  fluid_ex(p(start=p_ex_start),h(start=h_ex_start));
   //1. PARAMETERS
   //===========================
   //1.1. Model parameters
   //---------------------------
    parameter Modelica.SIunits.Volume V_s=110e-6 "Displacement";
    parameter Real r_v_in=2.85 "Internal built-in volume ratio";
    parameter Modelica.SIunits.Length d_su=6.18e-3
      "inlet pressure drop equivalent diameter";
    parameter Modelica.SIunits.MassFlowRate M_dot_n=0.1
      "Nominal mass flow rate";
    parameter Modelica.SIunits.ThermalConductance AU_su_n=30
      "Supply heat transfer coefficient";
    parameter Modelica.SIunits.ThermalConductance AU_ex_n=30
      "Exhaust heat transfer coefficient";
    parameter Modelica.SIunits.ThermalConductance AU_amb=3.4
      "Ambient heat transfer coefficient";
    parameter Modelica.SIunits.Area A_leak=2.6e-6 "Leakage area";
    parameter Modelica.SIunits.Power W_dot_loss0=0 "Constant mechanical losses";
    parameter Real alpha=0.1 "Proportionality factor of the mechanical losses";
    parameter Modelica.SIunits.Temperature T_amb=25+273.15
      "Ambient temperature";
    parameter Modelica.SIunits.SpecificHeatCapacity c_w=500 annotation(Dialog(enable = HeatCapacity));
    parameter Modelica.SIunits.Mass M_w=20 annotation(Dialog(enable = HeatCapacity));
   //1.2. Start values
   //---------------------------
    parameter Boolean HeatCapacity=false
      "Set to true to consider the thermal mass of the expander walls"  annotation(Dialog(tab = "Initialization"));
    parameter Boolean SteadyState=false
      "Set to true to initialize in steady-state"  annotation(Dialog(tab = "Initialization"));
    parameter Modelica.SIunits.MassFlowRate M_dot_start=0.08
      "Inlet pressure start value"  annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.Pressure p_su_start=10e5
      "Inlet pressure start value"  annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.Temperature T_su_start=423.15
      "Inlet temperature start value"  annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.SpecificEnthalpy h_su_start=Medium.specificEnthalpy_pT(p=p_su_start,T=T_su_start)
      "Inlet specific enthalpy start value"    annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.Pressure p_su1_start=9e5
      "Inlet pressure after pressure loss start value"  annotation(Dialog(tab = "Initialization"));
    parameter Modelica.SIunits.Temperature T_su1_start=423.15
      "Inlet temperature start value"  annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.SpecificEnthalpy h_su1_start=h_su_start
      "Inlet specific enthalpy after pressure loss start value"    annotation(Dialog(tab = "Initialization"));
   parameter Modelica.SIunits.SpecificEntropy s_su_start=2000
      "Inlet specific entropy "    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.SpecificEnthalpy h_ex_start=500000
      "Outlet specific enthalpy "    annotation(Dialog(tab = "Initialization"));
    parameter Modelica.SIunits.SpecificHeatCapacity c_p_su1_start=1170
      "Start value for the supply specific heat capacity after pressure loss"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance C_dot_su1_start=77
      "Start value for the supply heat capacity flow rate after pressure loss"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance AU_su_start=21.49
      "Start value for the supply heat transfer coefficient"    annotation(dialog(tab="Start Values"));
    parameter Real epsilon_su_start=0.243174
      "Start value for the supply efficiency"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_su_start=-369.857
      "Start value for the supply heat transfer rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_w_start=373.6
      "Start value for the wall temperature"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_su2_start=498749
      "Start value for the supply specific enthalpy after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_su2_start=388.5
      "Start value for the supply temperature after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificVolume v_su2_start=0.02
      "Start value for the supply specific volume after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEntropy s_su2_start=1866
      "Start value for the supply specific entropy after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_su2_start=1.01791e6
      "Start value for the pressure after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.MassFlowRate M_dot_in_start=0.054812
      "Start value for the internal mass flow rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_crit_start=634079
      "Start value for the critical pressure"    annotation(dialog(tab="Start Values"));
   parameter Modelica.SIunits.Pressure p_thr_start=634079
      "Start value for the throat pressure"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex3_start=100000
      "Start value for the pressure after expansion"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_thr_start=488984
      "Start value for the specific enthalpy at the throat"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Velocity C_thr_start=139.75
      "Start value for the fluid velocity the throat"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.MassFlowRate M_dot_leak_start=0.0110975
      "Start value for the leakage mass flow rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificVolume v_in_start=0.0617109
      "Start value for the supply specific volume after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_in_start=335196
      "Start value for the internal pressure"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_in_start=475750
      "Start value for the internal specific enthalpy after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy w_1_start=22999
      "Start value for the internal isentropic work"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy w_2_start=14514
      "Start value for the internal constant volume work"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_ex3_start=461236
      "Start value for the internal specific enthalpy after expansion"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_in_start=2056
      "Start value for the internal power"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_loss1_start=183
      "Start value for the mechanical losses"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_sh_start=1873
      "Start value for the shaft power"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_loss2_start=215
      "Start value for the electro-mechanical losses"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_el_start = 1658
      "Start value for the electrical power";
    parameter Modelica.SIunits.SpecificEnthalpy h_ex2_start=467552
      "Start value for the specific enthalpy after mixing with leakages"             annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex2_start=100000
      "Start value for the pressure after mixing with leakage"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_ex2_start=344
      "Start value for the temperature after mixing with lekage"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificHeatCapacity c_p_ex2_start=964
      "Start value for the exhaust specific heat capacity"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance C_dot_ex2_start=64
      "Start value for the exhaust heat capacity flow rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance AU_ex_start=21.49
      "Start value for the exhaust heat transfer coefficient"    annotation(dialog(tab="Start Values"));
    parameter Real epsilon_ex_start=0.29
      "Start value for the exhaust efficiency"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_ex_start=542
      "Start value for the exhaust heat transfer rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_ex1_start=475776
      "Start value for the specific enthalpy after heat transfer" annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex1_start=100000
      "Start value for the pressure after heat transfer"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_amb_start=226
      "Start value for the ambient heat transfer rate"    annotation(dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex_start=3e5
      "Inlet pressure start value"
                               annotation(Dialog(tab = "Initialization"));
   //2. DECLARATIONS OF VARIABLES
   //=============================
   // Important data to show in results
   Modelica.SIunits.Power W_dot;
   Modelica.SIunits.Frequency N_rot(start=50) "Rotating speed in Hz";
   Modelica.SIunits.SpecificEnthalpy h_ex(start=h_ex_start);
   Modelica.SIunits.Pressure p_ex(min=1E5,max=10E5,start=p_ex_start);
    Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start);
    Modelica.SIunits.Density rho_su(start=Medium.density_pT(p=p_su_start,T=T_su_start));
    Modelica.SIunits.SpecificEnthalpy h_su(start=h_su_start);
    Modelica.SIunits.Pressure p_su(min=1E5,max=28E5,start=p_su_start);
    Modelica.SIunits.Temperature T_su;
    Modelica.SIunits.SpecificEntropy s_su;
    Modelica.SIunits.SpecificVolume v_su;
    Modelica.SIunits.Area A_su;
    Modelica.SIunits.Pressure p_su1(min=1E5,max=28E5,start=p_su1_start);
    Modelica.SIunits.SpecificEnthalpy h_su1(start=h_su1_start);
    Modelica.SIunits.Temperature T_su1;
    Modelica.SIunits.SpecificHeatCapacity c_p_su1(start=c_p_su1_start);
     Modelica.SIunits.ThermalConductance C_dot_su1(start=C_dot_su1_start);
     Modelica.SIunits.ThermalConductance AU_su(start=AU_su_start);
     Real epsilon_su(start=epsilon_su_start);
     Modelica.SIunits.HeatFlowRate Q_dot_su(start=Q_dot_su_start);
     Modelica.SIunits.Temperature T_w(start=T_w_start);
     Modelica.SIunits.SpecificEnthalpy h_su2(start=h_su2_start);
     Modelica.SIunits.Temperature T_su2(start=T_su2_start);
     Modelica.SIunits.SpecificVolume v_su2(start=v_su2_start);
     Modelica.SIunits.SpecificEntropy s_su2(start=s_su2_start);
     Modelica.SIunits.Pressure p_su2(start=p_su2_start);
     Real rpm;
     Modelica.SIunits.VolumeFlowRate V_dot_s;
     Modelica.SIunits.MassFlowRate M_dot_in(start=M_dot_in_start);
      Real gamma;
      Modelica.SIunits.Pressure p_crit(start=p_crit_start);
       Modelica.SIunits.Pressure p_thr(start=p_crit_start);
       Modelica.SIunits.Pressure p_ex3(start=p_ex3_start);
       Modelica.SIunits.SpecificEnthalpy h_thr(start=h_thr_start);
       Modelica.SIunits.Velocity C_thr(start=C_thr_start);
       Modelica.SIunits.MassFlowRate M_dot_leak(start=M_dot_leak_start);
       Modelica.SIunits.SpecificVolume v_in(start=v_in_start);
       Modelica.SIunits.Pressure p_in(start=p_in_start);
       Modelica.SIunits.SpecificEnthalpy h_in(start=h_in_start);
       Modelica.SIunits.SpecificEnthalpy w_1(start=w_1_start);
       Modelica.SIunits.SpecificEnthalpy w_2(start=w_1_start);
       Modelica.SIunits.SpecificEnthalpy h_ex3(start=h_ex3_start);
       Modelica.SIunits.Power W_dot_in(start=W_dot_in_start);
       Modelica.SIunits.Power W_dot_loss1(start=W_dot_loss1_start);
       Modelica.SIunits.Power W_dot_sh(start=W_dot_sh_start);
       Real rpm_rel;
       Modelica.SIunits.Power W_dot_loss2(start=W_dot_loss2_start);
       Modelica.SIunits.Power W_dot_el(start=W_dot_el_start);
      Modelica.SIunits.SpecificEnthalpy h_ex2(start=h_ex2_start);
      Modelica.SIunits.Pressure p_ex2(start=p_ex2_start);
      Modelica.SIunits.Temperature T_ex2(start=T_ex2_start);
      Modelica.SIunits.ThermalConductance AU_ex(start=AU_ex_start);
      Modelica.SIunits.SpecificHeatCapacity c_p_ex2(start=c_p_ex2_start);
      Modelica.SIunits.ThermalConductance C_dot_ex2(start=C_dot_ex2_start);
      Real epsilon_ex(start=epsilon_ex_start);
      Modelica.SIunits.HeatFlowRate Q_dot_ex(start=Q_dot_ex_start);
      Modelica.SIunits.Pressure p_ex1(start=p_ex1_start);
      Modelica.SIunits.SpecificEnthalpy h_ex1(start=h_ex1_start);
      Modelica.SIunits.HeatFlowRate Q_dot_amb(start=Q_dot_amb_start);
      Modelica.SIunits.Power U_dot_w(start=100);
       Modelica.SIunits.HeatFlowRate residual(start=0);
       Modelica.SIunits.Efficiency epsilon_s "Isentropic efficiency";
       Real FF;
    Interfaces.Fluid.FlangeA flangeA(redeclare package Medium =
                 Medium)
      annotation (Placement(transformation(extent={{-76,38},{-56,58}}),
          iconTransformation(extent={{-76,38},{-56,58}})));
    Interfaces.Fluid.FlangeB flangeB(redeclare package Medium =
                 Medium)
      annotation (Placement(transformation(extent={{76,-70},{96,-50}})));
  equation
  //3. CONNECTIONS WITH PORTS
  //===========================
    flangeA.h_outflow = 1E5;
    flangeA.p = fluid_su.p;
    flangeA.p = p_su;
    flangeA.m_flow = M_dot;
    h_su = inStream(flangeA.h_outflow);
    flangeB.p = p_ex;
    flangeB.m_flow = -M_dot;
    flangeB.h_outflow = h_ex;
  //2. MODEL
  //===========================
   //3.1 Supply status: su
   //---------------------
   fluid_su = Medium.setState_ph(h=h_su,p=p_su);
  //  fluid_su.h=h_su;
  //  fluid_su.d = rho_su; //calculé avec l'équation du débit, ce qui permet de recalculer la pression
   T_su=fluid_su.T;
   s_su=fluid_su.s;
   v_su=1/rho_su;
   //3.2 Supply pressure drop: su=>su1
   //-----------------------------------
   A_su=Modelica.Constants.pi*d_su^2/4;
   p_su-p_su1=(M_dot/A_su)^2/(2/v_su);
   //p_su1=p_su;
   h_su1=h_su;
  //  fluid_su1.h=h_su1;
  //  fluid_su1.p=p_su1;
   fluid_su1 = Medium.setState_ph(p=p_su1,h=h_su1);
   T_su1=fluid_su1.T;
   //3.3 Supply heat transfer: su1=>su2
   //-----------------------------------
   c_p_su1=fluid_su1.cp;
    C_dot_su1=M_dot*c_p_su1;
    AU_su=AU_su_n*(M_dot/M_dot_n)^0.8;
    epsilon_su=1-exp(-AU_su/C_dot_su1);
    Q_dot_su=epsilon_su*C_dot_su1*(T_w-T_su1);
    //T_w=100+273.15;
    Q_dot_su=M_dot*(h_su2-h_su1);
  //   fluid_su2.h=h_su2;
  //   fluid_su2.p=p_su1;
    fluid_su2 = Medium.setState_ph(h=h_su2,p=p_su1);
    T_su2=fluid_su2.T;
    v_su2=1/fluid_su2.d;
    s_su2=fluid_su2.s;
    p_su2=p_su1;
    //3.4 Mass flow rate: su2
    //-----------------------------------
    rpm=N_rot*60; //3006.98355;+ 0.021731444*W_dot_el + 0.00000205095049*W_dot_el^2;
    V_dot_s=(rpm/60)*V_s;
    M_dot_in=V_dot_s/v_su2;
    //p_su=10e5;
    //N_rot=N;
      //3.5 Leakage mass flow rate: su2
     //-----------------------------------
     gamma=0.93;
     p_crit=p_su2*(2/(gamma+1))^(gamma/(gamma-1));
     p_ex3=p_ex;
     p_thr=p_crit;//max(p_ex3,p_crit);
  //    fluid_thr.p=p_thr;
  //    fluid_thr.s=s_su2;
     fluid_thr = Medium.setState_ps(p=p_thr,s=s_su2);
     h_thr=fluid_thr.h;
     C_thr=sqrt(2*(h_su2-h_thr));
     M_dot_leak=A_leak*C_thr*fluid_thr.d;
    //3.6 Total mass flow rate
    //-----------------------------------
    M_dot=M_dot_in+M_dot_leak;
  //  V_dot_su = M_dot/rho_su;
     //3.7 Isentropic expansion su2=>in
     //-----------------------------------
     v_in=r_v_in*v_su2;
  //    fluid_in.d=1/v_in;
  //    fluid_in.s=s_su2;
     fluid_in = Medium.setState_ps(p=p_in,s=s_su2);
     v_in = 1/fluid_in.d;
     //p_in=fluid_in.p;
     h_in=fluid_in.h;
     w_1=h_su2-h_in;
     //3.8 Constant volume expansion in=>ex3
     //---------------------------------------
     w_2=v_in*(p_in-p_ex);
     h_ex3=h_in-w_2;
     //3.9 Mechanical power
     //---------------------------------------
     W_dot_in=M_dot_in*(w_1+w_2);
     W_dot_loss1=alpha*W_dot_in+W_dot_loss0;
     W_dot_sh=W_dot_in-W_dot_loss1;
     //3.10 Electrical power
     //---------------------------------------
     rpm_rel=3002-rpm;
     W_dot_loss2=212.027229;// + 1.43852687*rpm_rel + 0.0586266258*rpm_rel^2 + 0.000129692208*rpm_rel^3;
     W_dot_el=W_dot_sh-W_dot_loss2;
    //3.11 Mixing with leakage flow ex3=>ex2
     //---------------------------------------
     h_ex2=(M_dot_in*h_ex3+M_dot_leak*h_su2)/M_dot;
  //    fluid_ex2.h=h_ex2;
  //    fluid_ex2.p=p_ex2;
     fluid_ex2 = Medium.setState_ph(p=p_ex2,h=h_ex2);
     p_ex2=p_ex;
     T_ex2=fluid_ex2.T;
     //3.12 Exhaust heat transfer ex2=>ex1
     //---------------------------------------
     c_p_ex2=fluid_ex2.cp;
     C_dot_ex2=M_dot*c_p_ex2;
     AU_ex=AU_ex_n*(M_dot/M_dot_n)^0.8;
     epsilon_ex=1-exp(-AU_ex/C_dot_ex2);
     Q_dot_ex=epsilon_ex*C_dot_ex2*(T_w-T_ex2);
     Q_dot_ex=M_dot*(h_ex1-h_ex2);
  //    fluid_ex1.h=h_ex1;
  //    fluid_ex1.p=p_ex1;
     fluid_ex1 = Medium.setState_ph(p=p_ex1,h=h_ex1);
     p_ex1=p_ex2;
     //3.13 Exhaust pressure drop ex1=>ex
     //---------------------------------------
      h_ex=h_ex1;
  //     p_ex=fluid_ex.p;
  //     h_ex=fluid_ex.h;
      fluid_ex = Medium.setState_ph(p=p_ex,h=h_ex);
      //fluid_ex.s=fluid_su.s*1.04;
     //3.14 Heat balance over the expander
     //---------------------------------------
     Q_dot_amb=AU_amb*(T_w-T_amb);
     W_dot_loss1+W_dot_loss2-Q_dot_amb-Q_dot_su-Q_dot_ex=U_dot_w;
     if HeatCapacity then
       U_dot_w = M_w*c_w*der(T_w);
     else
       U_dot_w=0;
     end if;
     //3.15 Performance indicators
     //---------------------------------------
     residual=M_dot*(h_su-h_ex)-W_dot_el-Q_dot_amb;
       //3.15.1 Isentropic efficiency
  //        fluid_exs.p=p_ex;
  //        fluid_exs.s=s_su;
         epsilon_s=W_dot_el/(M_dot*(h_su-Medium.specificEnthalpy_ps(p=p_ex,s=s_su)));
       //3.15.2 Filling factor
         FF=M_dot*v_su/V_dot_s;
   W_dot = M_dot * (h_su - h_ex) "Power generated";
   // Mechanical port:
   der(flange_elc.phi)=2*N_rot*Modelica.Constants.pi;
   flange_elc.tau=W_dot/(2*N_rot*Modelica.Constants.pi)
      "Mechanical connection with the eletrical generator";
  initial equation
    if SteadyState then
      U_dot_w = 0;
    end if;
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}),     graphics),
      Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}}),
                      graphics={Text(
            extent={{-84,-44},{58,-72}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,0},
            textString="%name"),Polygon(
            points={{-60,40},{-60,-20},{80,-60},{80,80},{-60,40}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),Documentation(info="<HTML> 
                    <p><big> Model <b>ExpanderOpenDriveDetailed</b> represents the expanson of fluid in a volumetric machine. 
                    The evolution of the fluid through the expander is decomposed into six
                    thermodynamic processes, as shown in the figure:
         <ul><li> Supply pressure drop (su --> su,1)
         <li> Supply cooling-down (su,1 --> su,2)
         <li> Isentropic expansion to the internal pressure imposed by the built-in
          volume ratio of the expander (su,2 --> in)
         <li> Expansion at a fixed volume to the exhaust pressure (in --> ex,2)
         <li> Mixing between suction flow and leakage flow (ex,2 --> ex,1)
         <li> Exhaust cooling-down or heating-up (ex,1 --> ex)
         </ul>
        <p>            
      <img src=\"modelica://ThermoCycle/Resources/Images/OpenScrollExpander2.png\">
         </p>     
                    
                    </HTML>"));
  end ExpanderOpendriveDetailed;

  model ExpanderHermeticDetailed "Expander model (oil free, open-drive)"
  /* FLUIDS AND PORTS */
  parameter String fluid = "Refprop.R245FA" "Reference of the working fluid";
  TILMedia.Refrigerant fluid_su(
      refrigerantName=fluid,
      p(start=p_su_start),
      T(start=T_su_start))
      annotation (Placement(transformation(extent={{-30,54},{-10,74}})));
    TILMedia.Refrigerant fluid_su1(
      refrigerantName=fluid,
      p(start=p_su1_start),
      T(start=T_su1_start))
      annotation (Placement(transformation(extent={{-30,24},{-10,44}})));
    TILMedia.Refrigerant fluid_su2(
      refrigerantName=fluid,
      p(start=p_su2_start),
      T(start=T_su2_start))
      annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
    TILMedia.Refrigerant fluid_ex(
      refrigerantName=fluid,
      inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ps,
      p(start=p_ex_start),
      T(start=T_ex2_start))
      annotation (Placement(transformation(extent={{10,-8},{30,12}})));
    TILMedia.Refrigerant fluid_thr(
      refrigerantName=fluid,
      p(start=p_thr_start),
      h(start=h_thr_start))
      annotation (Placement(transformation(extent={{-30,-32},{-10,-12}})));
    TILMedia.Refrigerant fluid_in(
      refrigerantName=fluid,
      p(start=p_in_start),
      d(start=1/v_in_start))
      annotation (Placement(transformation(extent={{-30,-62},{-10,-42}})));
    TILMedia.Refrigerant fluid_ex2(
      refrigerantName=fluid,
      p(start=p_ex2_start),
      h(start=h_ex2_start))
      annotation (Placement(transformation(extent={{12,54},{32,74}})));
    TILMedia.Refrigerant fluid_ex1(
      refrigerantName=fluid,
      p(start=p_ex1_start),
      h(start=h_ex1_start))
      annotation (Placement(transformation(extent={{10,22},{30,42}})));
    TILMedia.Refrigerant fluid_exs(
      refrigerantName=fluid,
      inputChoice=TILMedia.Internals.InputChoicesRefrigerant.ps,
      p(start=p_ex_start),
      T(start=T_ex2_start))
      annotation (Placement(transformation(extent={{10,-38},{30,-18}})));
    Modelica.Blocks.Interfaces.RealInput N annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=180,
          origin={104,0})));
    //1. PARAMETERS
    //===========================
    //1.1. Model parameters
    //---------------------------
    parameter Modelica.SIunits.Volume V_s=22.4e-6 "Displacement";
    parameter Real r_v_in=2.85;
    parameter Modelica.SIunits.Length d_su=6.18e-3;
    parameter Modelica.SIunits.MassFlowRate M_dot_n=0.1;
    parameter Modelica.SIunits.ThermalConductance AU_su_n=30;
    parameter Modelica.SIunits.ThermalConductance AU_ex_n=30;
    parameter Modelica.SIunits.ThermalConductance AU_amb=3.4;
    parameter Modelica.SIunits.Area A_leak=2.6e-6;
    parameter Modelica.SIunits.Power W_dot_loss0=0;
    parameter Real alpha=0.1;
    parameter Modelica.SIunits.Temperature T_amb=25 + 273.15;
    parameter Modelica.SIunits.SpecificHeatCapacity c_w=500;
    parameter Modelica.SIunits.Mass M_w=20;
   // parameter componentsNew.functions.ExpanderType exptype="User defined";
    parameter Boolean constPinit=false
      "if true, sets the evaporating pressure to a constant value at the beginning of the simulation in order to avoid oscillations"
      annotation (Dialog(tab="Initialization"));
    parameter Boolean constinit=false
      "if true, sets the efficiencies to a constant value at the beginning of the simulation"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Time t_init=10
      "if constinit is true, time during which the efficiencies are set to their start values"
      annotation (Dialog(tab="Initialization", enable=constinit));
    //1.2. Start values
    //---------------------------
    parameter Modelica.SIunits.MassFlowRate M_dot_start=0.08
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_su_start=10e5
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_su_start=423.15
      "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificEnthalpy h_su_start=
        TILMedia.FunctionBasedMedia.Refrigerant.specificEnthalpy_pT(
          p=p_su_start,
          T=T_su_start,
          refrigerantName="Refprop.R245FA")
      "Inlet specific enthalpy start value"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_su1_start=9e5
      "Inlet pressure after pressure loss start value"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_su1_start=423.15
      "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificEnthalpy h_su1_start=h_su_start
      "Inlet specific enthalpy after pressure loss start value"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.SpecificHeatCapacity c_p_su1_start=1170
      "Start value for the supply specific heat capacity after pressure loss"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance C_dot_su1_start=77
      "Start value for the supply heat capacity flow rate after pressure loss"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance AU_su_start=21.49
      "Start value for the supply heat transfer coefficient"
      annotation (dialog(tab="Start Values"));
    parameter Real epsilon_su_start=0.243174
      "Start value for the supply efficiency"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_su_start=-369.857
      "Start value for the supply heat transfer rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_w_start=373.6
      "Start value for the wall temperature"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_su2_start=498749
      "Start value for the supply specific enthalpy after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_su2_start=388.5
      "Start value for the supply temperature after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificVolume v_su2_start=0.02
      "Start value for the supply specific volume after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEntropy s_su2_start=1866
      "Start value for the supply specific entropy after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_su2_start=1.01791e6
      "Start value for the pressure after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.MassFlowRate M_dot_in_start=0.054812
      "Start value for the internal mass flow rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_crit_start=634079
      "Start value for the critical pressure"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_thr_start=634079
      "Start value for the throat pressure"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex3_start=100000
      "Start value for the pressure after expansion"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_thr_start=488984
      "Start value for the specific enthalpy at the throat"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Velocity C_thr_start=139.75
      "Start value for the fluid velocity the throat"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.MassFlowRate M_dot_leak_start=0.0110975
      "Start value for the leakage mass flow rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificVolume v_in_start=0.0617109
      "Start value for the supply specific volume after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_in_start=335196
      "Start value for the internal pressure"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_in_start=475750
      "Start value for the internal specific enthalpy after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy w_1_start=22999
      "Start value for the internal isentropic work"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy w_2_start=14514
      "Start value for the internal constant volume work"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_ex3_start=461236
      "Start value for the internal specific enthalpy after expansion"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_in_start=2056
      "Start value for the internal power"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_loss1_start=183
      "Start value for the mechanical losses"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_sh_start=1873
      "Start value for the shaft power" annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_loss2_start=215
      "Start value for the electro-mechanical losses"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Power W_dot_el_start=1658
      "Start value for the electrical power";
    parameter Modelica.SIunits.SpecificEnthalpy h_ex2_start=467552
      "Start value for the specific enthalpy after mixing with leakages"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex2_start=100000
      "Start value for the pressure after mixing with leakage"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Temperature T_ex2_start=344
      "Start value for the temperature after mixing with lekage"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificHeatCapacity c_p_ex2_start=964
      "Start value for the exhaust specific heat capacity"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance C_dot_ex2_start=64
      "Start value for the exhaust heat capacity flow rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.ThermalConductance AU_ex_start=21.49
      "Start value for the exhaust heat transfer coefficient"
      annotation (dialog(tab="Start Values"));
    parameter Real epsilon_ex_start=0.29
      "Start value for the exhaust efficiency"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_ex_start=542
      "Start value for the exhaust heat transfer rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.SpecificEnthalpy h_ex1_start=475776
      "Start value for the specific enthalpy after heat transfer";
    parameter Modelica.SIunits.Pressure p_ex1_start=100000
      "Start value for the pressure after heat transfer"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.HeatFlowRate Q_dot_amb_start=226
      "Start value for the ambient heat transfer rate"
      annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Frequency N_rot_start=50 "Rotating speed in Hz" annotation (dialog(tab="Start Values"));
    parameter Modelica.SIunits.Pressure p_ex_start=3e5
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    //   parameter Boolean constinit=false
    //     "if true, sets the efficiencies to a constant value at the beginning of the simulation"
    //                                                                                                annotation(Dialog(tab = "Initialization"));
    //   parameter Modelica.SIunits.Time t_init=10
    //     "if constinit is true, time during which the efficiencies are set to their start values"
    //     annotation(Dialog(tab = "Initialization", enable=constinit));
    //2. DECLARATIONS OF VARIABLES
    //=============================
    // Important data to show in results
    // Modelica.SIunits.Power W_dot;
    // Modelica.SIunits.VolumeFlowRate V_dot_su;
    Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start);
    Modelica.SIunits.Density rho_su(start=
          TILMedia.FunctionBasedMedia.Refrigerant.density_pT(
            p=p_su_start,
            T=T_su_start,
            refrigerantName="Refprop.R245FA"));
    Modelica.SIunits.SpecificEnthalpy h_su(start=h_su_start);
    Modelica.SIunits.Pressure p_su(
      min=1E5,
      max=28E5,
      start=p_su_start);
    Modelica.SIunits.Temperature T_su;
    Modelica.SIunits.SpecificEntropy s_su;
    Modelica.SIunits.Temperature DELTAT_su;
    Modelica.SIunits.SpecificVolume v_su;
    Modelica.SIunits.Area A_su;
    Modelica.SIunits.Pressure p_su1(
      min=1E5,
      max=28E5,
      start=p_su1_start);
    Modelica.SIunits.SpecificEnthalpy h_su1(start=h_su1_start);
    Modelica.SIunits.Temperature T_su1;
    Modelica.SIunits.SpecificHeatCapacity c_p_su1(start=c_p_su1_start);
    Modelica.SIunits.ThermalConductance C_dot_su1(start=C_dot_su1_start);
    Modelica.SIunits.ThermalConductance AU_su(start=AU_su_start);
    Real epsilon_su(start=epsilon_su_start);
    Modelica.SIunits.HeatFlowRate Q_dot_su(start=Q_dot_su_start);
    Modelica.SIunits.Temperature T_w(start=T_w_start);
    Modelica.SIunits.SpecificEnthalpy h_su2(start=h_su2_start);
    Modelica.SIunits.Temperature T_su2(start=T_su2_start);
    Modelica.SIunits.SpecificVolume v_su2(start=v_su2_start);
    Modelica.SIunits.SpecificEntropy s_su2(start=s_su2_start);
    Modelica.SIunits.Pressure p_su2(start=p_su2_start);
    Real rpm;
    Modelica.SIunits.VolumeFlowRate V_dot_s;
    Modelica.SIunits.MassFlowRate M_dot_in(start=M_dot_in_start);
    Real gamma;
    Modelica.SIunits.Pressure p_crit(start=p_crit_start);
    Modelica.SIunits.Pressure p_thr(start=p_thr_start);
    Modelica.SIunits.Pressure p_ex3(start=p_ex3_start);
    Modelica.SIunits.SpecificEnthalpy h_thr(start=h_thr_start);
    Modelica.SIunits.Velocity C_thr(start=C_thr_start);
    Modelica.SIunits.MassFlowRate M_dot_leak(start=M_dot_leak_start);
    Modelica.SIunits.SpecificVolume v_in(start=v_in_start);
    Modelica.SIunits.Pressure p_in(start=p_in_start);
    Modelica.SIunits.SpecificEnthalpy h_in(start=h_in_start);
    Modelica.SIunits.SpecificEnthalpy w_1(start=w_1_start);
    Modelica.SIunits.SpecificEnthalpy w_2(start=w_1_start);
    Modelica.SIunits.SpecificEnthalpy h_ex3(start=h_ex3_start);
    Modelica.SIunits.Power W_dot_in(start=W_dot_in_start);
    Modelica.SIunits.Power W_dot_loss1(start=W_dot_loss1_start);
    Modelica.SIunits.Power W_dot_sh(start=W_dot_sh_start);
    Real rpm_rel;
    Modelica.SIunits.Power W_dot_loss2(start=W_dot_loss2_start);
    Modelica.SIunits.Power W_dot_el(start=W_dot_el_start);
    Modelica.SIunits.SpecificEnthalpy h_ex2(start=h_ex2_start);
    Modelica.SIunits.Pressure p_ex2(start=p_ex2_start);
    Modelica.SIunits.Temperature T_ex2(start=T_ex2_start);
    Modelica.SIunits.ThermalConductance AU_ex(start=AU_ex_start);
    Modelica.SIunits.SpecificHeatCapacity c_p_ex2(start=c_p_ex2_start);
    Modelica.SIunits.ThermalConductance C_dot_ex2(start=C_dot_ex2_start);
    Real epsilon_ex(start=epsilon_ex_start);
    Modelica.SIunits.HeatFlowRate Q_dot_ex(start=Q_dot_ex_start);
    Modelica.SIunits.Pressure p_ex1(start=p_ex1_start);
    Modelica.SIunits.SpecificEnthalpy h_ex1(start=h_ex1_start);
    Modelica.SIunits.HeatFlowRate Q_dot_amb(start=Q_dot_amb_start);
    Modelica.SIunits.HeatFlowRate res(start=0);
    Modelica.SIunits.Power U_dot_w(start=100);
    Modelica.SIunits.HeatFlowRate residual(start=0);
    Modelica.SIunits.Efficiency epsilon_s "Isentropic efficiency";
    Real FF;
    Modelica.SIunits.SpecificEnthalpy h_ex(start=
          TILMedia.FunctionBasedMedia.Refrigerant.specificEnthalpy_pT(
            p=p_ex_start,
            T=T_su_start,
            refrigerantName="Refprop.R245FA"));
    Modelica.SIunits.Pressure p_ex(
      min=1E5,
      max=10E5,
      start=p_ex_start);
    //Modelica.SIunits.SpecificEnthalpy h_ex_s;
    Modelica.SIunits.Frequency N_rot(start=N_rot_start) "Rotating speed in Hz";
    Interfaces.Fluid.FlangeA flangeA
      annotation (Placement(transformation(extent={{-78,36},{-58,56}}),
          iconTransformation(extent={{-78,36},{-58,56}})));
    Interfaces.Fluid.FlangeB flangeB
      annotation (Placement(transformation(extent={{70,-80},{90,-60}}),
          iconTransformation(extent={{70,-80},{90,-60}})));
  equation
    //3. CONNECTIONS WITH PORTS
    //===========================
    flangeA.h_outflow = 1E5;
    //dummy value for the reversed flow
    flangeA.p = fluid_su.p;
    //cette équation impose la pression dans le port
    flangeA.p = p_su;
    M_dot = flangeA.m_flow;
    //p_su=10e5;
    h_su = inStream(flangeA.h_outflow);
    //le modèle d'expanseur reçoit l'enthalpie du port
    flangeB.p = p_ex;
    flangeB.m_flow = -M_dot;
    flangeB.h_outflow = h_ex;
    //2. MODEL
    //===========================
    //3.1 Supply status: su
    //---------------------
    fluid_su.h = h_su;
    fluid_su.d = rho_su;
    //calculé avec l'équation du débit, ce qui permet de recalculer la pression
    T_su = fluid_su.T;
    s_su = fluid_su.s;
    v_su = 1/rho_su;
    DELTAT_su = T_su - fluid_su.sat.Tv;
    //3.2 Supply pressure drop: su=>su1
    //-----------------------------------
    A_su = Modelica.Constants.pi*d_su^2/4;
    //p_su-p_su1=(M_dot/A_su)^2/(2/v_su);
    p_su1 = p_su;
    h_su1 = h_su;
    fluid_su1.h = h_su1;
    fluid_su1.p = p_su1;
    T_su1 = fluid_su1.T;
    //3.3 Supply heat transfer: su1=>su2
    //-----------------------------------
    c_p_su1 = fluid_su1.cp;
    C_dot_su1 = M_dot*c_p_su1;
    AU_su = AU_su_n*(M_dot/M_dot_n)^0.8;
    epsilon_su = 1 - exp(-AU_su/C_dot_su1);
    Q_dot_su = epsilon_su*C_dot_su1*(T_w - T_su1);
    T_w = 100 + 273.15;
    Q_dot_su = M_dot*(h_su2 - h_su1);
    fluid_su2.h = h_su2;
    fluid_su2.p = p_su1;
    T_su2 = fluid_su2.T;
    v_su2 = 1/fluid_su2.d;
    s_su2 = fluid_su2.s;
    p_su2 = p_su1;
    //3.4 Mass flow rate: su2
    //-----------------------------------
    rpm = N_rot*60;
    //3006.98355;+ 0.021731444*W_dot_el + 0.00000205095049*W_dot_el^2;
    V_dot_s = (rpm/60)*V_s;
    //  M_dot_in=V_dot_s/v_su2;
    p_su = 10e5;
    N_rot = N;
    //3.5 Leakage mass flow rate: su2
    //-----------------------------------
    gamma = 0.93;
    p_crit = p_su2*(2/(gamma + 1))^(gamma/(gamma - 1));
    p_ex3 = p_ex;
    p_thr = max(p_ex3, p_crit);
    fluid_thr.p = p_thr;
    fluid_thr.s = s_su2;
    h_thr = fluid_thr.h;
    C_thr = sqrt(2*(h_su2 - h_thr));
    M_dot_leak = 0;
    //A_leak*C_thr*fluid_thr.d;
    //3.6 Total mass flow rate
    //-----------------------------------
    M_dot = M_dot_in + M_dot_leak;
    //3.7 Isentropic expansion su2=>in
    //-----------------------------------
    v_in = r_v_in*v_su2;
    fluid_in.d = 1/v_in;
    fluid_in.s = s_su2;
    p_in = fluid_in.p;
    h_in = fluid_in.h;
    w_1 = h_su2 - h_in;
    //3.8 Constant volume expansion in=>ex3
    //---------------------------------------
    w_2 = v_in*(p_in - p_ex);
    h_ex3 = h_in - w_2;
    //3.9 Mechanical power
    //---------------------------------------
    W_dot_in = M_dot_in*(w_1 + w_2);
    W_dot_loss1 = alpha*W_dot_in + W_dot_loss0;
    W_dot_sh = W_dot_in - W_dot_loss1;
    //3.10 Electrical power
    //---------------------------------------
    rpm_rel = 3002 - rpm;
    W_dot_loss2 = 212.027229;
    // + 1.43852687*rpm_rel + 0.0586266258*rpm_rel^2 + 0.000129692208*rpm_rel^3;
    W_dot_el = W_dot_sh - W_dot_loss2;
    //3.11 Mixing with leakage flow ex3=>ex2
    //---------------------------------------
    h_ex2 = (M_dot_in*h_ex3 + M_dot_leak*h_su2)/M_dot;
    fluid_ex2.h = h_ex2;
    fluid_ex2.p = p_ex2;
    p_ex2 = p_ex;
    T_ex2 = fluid_ex2.T;
    //3.12 Exhaust heat transfer ex2=>ex1
    //---------------------------------------
    c_p_ex2 = fluid_ex2.cp;
    C_dot_ex2 = M_dot*c_p_ex2;
    AU_ex = AU_ex_n*(M_dot/M_dot_n)^0.8;
    epsilon_ex = 1 - exp(-AU_ex/C_dot_ex2);
    Q_dot_ex = epsilon_ex*C_dot_ex2*(T_w - T_ex2);
    Q_dot_ex = M_dot*(h_ex1 - h_ex2);
    fluid_ex1.h = h_ex1;
    fluid_ex1.p = p_ex1;
    p_ex1 = p_ex2;
    //3.13 Exhaust pressure drop ex1=>ex
    //---------------------------------------
    h_ex = h_ex1;
    p_ex = fluid_ex.p;
    h_ex = fluid_ex.h;
    //3.14 Heat balance over the expander
    //---------------------------------------
    Q_dot_amb = AU_amb*(T_w - T_amb);
    W_dot_loss1 + W_dot_loss2 - Q_dot_amb - Q_dot_su - Q_dot_ex = U_dot_w + res;
    U_dot_w = 0;
    //M_w*c_w*der(T_w);
    //  res=0;
    //3.15 Performance indicators
    //---------------------------------------
    residual = M_dot*(h_su - h_ex) - W_dot_el - Q_dot_amb;
    //3.15.1 Isentropic efficiency
    fluid_exs.p = p_ex;
    fluid_exs.s = s_su;
    epsilon_s = W_dot_el/(M_dot*(h_su - fluid_exs.h));
    //3.15.2 Filling factor
    FF = M_dot*v_su/V_dot_s;
    //  // Mechanical port:
    //  der(flange_elc.phi)=2*N_rot*Modelica.Constants.pi;
    //  flange_elc.tau=W_dot_sh/(2*N_rot*Modelica.Constants.pi)
    //     "Mechanical connection with the eletrical generator";
    // if constinit then
    //
    //
    // else
    //
    // end if
  initial equation
    if constPinit then
      p_su = p_su_start;
      //   M_dot=M_dot_start;
    end if;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {100,100}}),       graphics), Icon(coordinateSystem(
            preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
            Text(
            extent={{-84,-44},{58,-72}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,0},
            textString="%name"),Polygon(
            points={{-60,40},{-60,-20},{80,-60},{80,80},{-60,40}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),Documentation(info="<HTML> 
                    <p><big> Model <b>ExpanderHermeticDetailed</b> represents the expanson of fluid in a volumetric machine. The evolution of the refrigerant through the expander is decomposed into six
                    thermodynamic processes:
                    
                    
                    
                    </HTML>"));
  end ExpanderHermeticDetailed;

  model ElectricDrive
    "Motor/Generator model with prescribed rotational speed (Active power only)"
    import Modelica.SIunits.Conversions.NonSIunits.*;
    parameter Real eta=1 "Conversion efficiency";
    parameter Modelica.SIunits.MomentOfInertia J=0 "Moment of inertia";
    parameter Integer Np=2 "Number of electrical poles";
    parameter Modelica.SIunits.Frequency fstart=50
      "Start value of the electrical frequency"
      annotation (Dialog(tab="Initialization"));
    Modelica.SIunits.Power Pe "Electrical Power";
  protected
    Modelica.SIunits.Power Pm "Mechanical power";
    Modelica.SIunits.Power Ploss "Inertial power Loss";
    Modelica.SIunits.Torque tau "Torque at shaft";
    Modelica.SIunits.AngularVelocity omega_m(start=2*Modelica.Constants.pi*
          fstart/Np) "Angular velocity of the shaft [rad/s] ";
    Modelica.SIunits.AngularVelocity omega_e
      "Angular velocity of the e.m.f. rotating frame [rad/s]";
    AngularVelocity_rpm n "Rotational speed [rpm]";
  public
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (
        Placement(transformation(extent={{-100,-14},{-72,14}}, rotation=0)));
    Modelica.Blocks.Interfaces.RealInput f(start=50) "Electrical frequency"
      annotation (Placement(transformation(
          extent={{16,16},{-16,-16}},
          rotation=90,
          origin={4,94})));
  equation
    omega_m = der(shaft.phi) "Mechanical boundary condition";
    omega_e = omega_m*Np;
    f = omega_e/(2*Modelica.Constants.pi) "Electrical frequency";
    n = Modelica.SIunits.Conversions.to_rpm(omega_m) "Rotational speed in rpm";
    Pm = omega_m*tau;
    if J > 0 then
      Ploss = J*der(omega_m)*omega_m;
    else
      Ploss = 0;
    end if annotation (Diagram);
    Pm = Pe/eta + Ploss "Energy balance";
    tau = shaft.tau;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{-72,6},{-48,-8}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={160,160,164}),
          Ellipse(
            extent={{50,-50},{-50,50}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-34,18},{0,-18}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            lineThickness=0.5),
          Ellipse(
            extent={{0,20},{34,-16}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            lineThickness=0.5),
          Rectangle(
            extent={{-36,0},{0,-30}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{0,26},{34,4}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{34,20},{38,2}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(extent={{-100,-50},{100,-84}}, textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics),
      Documentation(info="<html>
<p>This model describes the conversion between mechanical power and electrical power in an ideal synchronous generator. 
The frequency in the electrical connector is the e.m.f. of generator.
<p>It is possible to consider the generator inertia in the model, by setting the parameter <tt>J > 0</tt>. 
</html>"));
  end ElectricDrive;

  model Pump "Pump model useful for ORCNext"
    /***************************************** FLUID *****************************************/
    replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);

    /****************************************** Define type of pump ******************************************/
    import ThermoCycle.Functions.Enumerations.PumpTypes;
    import ThermoCycle.Functions.Enumerations.PumpInputs;
    parameter PumpTypes PumpType=PumpTypes.UD;
    parameter PumpInputs PumpInput=PumpInputs.freq
      "Choose between f_pp or X_pp as input";
    extends ThermoCycle.Icons.Water.Pump;

    /***************************************** PARAMETERS *****************************************/
    parameter Real f_pp0=30 "Pump frequency if not connected" annotation (Dialog(enable= (PumpInputs == "Frequency")));
    parameter Real X_pp0=0.7 "Pump Flow fraction if not connected"
                                                                  annotation (Dialog(enable= (PumpInputs == "Flow Fraction")));
    Real f_pp "Pump Frequency";
    Real X_pp "Pump Flow fraction";
    parameter Modelica.SIunits.SpecificEnthalpy hstart=2.22e5
      "Fluid specific enthalpy" annotation (Dialog(tab="Initialization"));
    parameter Real eta_em=1 "Electro-mechanical efficiency of the pump";
    parameter Real eta_is=1 "Internal Isentropic efficiency of the pump" annotation (Dialog(enable= (PumpType == "User Defined")));
    parameter Real epsilon_v=1 "Volumetric effectiveness of the pump" annotation (Dialog(enable= (PumpType == "User Defined")));
    parameter Modelica.SIunits.VolumeFlowRate V_dot_max=2e-4
      "Maximum pump flow rate" annotation (Dialog(enable= not (PumpType == "ORCnext")));
    parameter Modelica.SIunits.MassFlowRate M_dot_start=0.25
      "Start value for the Mass flow rate"                                                        annotation (Dialog(tab="Initialization"));

    /***************************************** VARIABLES *****************************************/
    Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start) "Mass flow rate";
    /*Fluid Variables */
    Medium.ThermodynamicState fluidState;
    Modelica.SIunits.SpecificEnthalpy h_su(start=hstart)
      "Fluid specific enthalpy";
    Modelica.SIunits.SpecificEnthalpy h_ex(start=hstart)
      "Fluid specific enthalpy";
    Modelica.SIunits.Pressure p_su "Supply pressure";
    Modelica.SIunits.Pressure p_ex "Exhaust pressure";
    Modelica.SIunits.Density rho_su "Liquid density";
    Modelica.SIunits.Power W_dot "Power Consumption (single pump)";
    Real eta "Pump overall effectiveness";
    Real eta_in "Pump internal effectiveness";
    Modelica.SIunits.VolumeFlowRate V_dot "Pump flow rate";
  public
    Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium)
                              annotation (Placement(transformation(extent={{-92,-14},
              {-52,24}}),        iconTransformation(extent={{-92,-14},{-52,24}})));
    Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium)
                               annotation (Placement(transformation(extent={
              {36,54},{76,94}}), iconTransformation(extent={{36,54},{76,94}})));
    Modelica.Blocks.Interfaces.RealInput flow_in
                                              annotation (Placement(
          transformation(extent={{-96,30},{-56,70}}), iconTransformation(
          extent={{-12,-12},{12,12}},
          rotation=-90,
          origin={-32,80})));

  equation
     if cardinality(flow_in) == 0 then
       if PumpInput == PumpInputs.freq then
         f_pp = f_pp0;
       else
         X_pp = X_pp0;
       end if;

      //flow_in = 0;
     else
       if PumpInput == PumpInputs.freq then
         f_pp = flow_in;
       else
         X_pp = flow_in;
       end if;
     end if;

     X_pp = f_pp/50;   // imposed to avoid calculation issues for some combinations of inputs
    /*Fluid properties*/
    fluidState = Medium.setState_ph(p_su,h_su);
    rho_su = Medium.density(fluidState);
    h_ex = h_su + (p_ex - p_su)/(eta*rho_su);
    W_dot = M_dot*(h_ex - h_su);
    eta = eta_in*eta_em;
    if (PumpType == PumpTypes.ORCNext) then
      eta_in = ThermoCycle.Functions.TestRig.GenericCentrifugalPump_IsentropicEfficiency(
                                                                     f_pp=
        f_pp, r_p=p_ex/p_su);
    M_dot = ThermoCycle.Functions.TestRig.GenericCentrifugalPump_MassFlowRate(
                                                                  f_pp=f_pp);
    V_dot = 1;
      //end if;
    elseif (PumpType == PumpTypes.SQThesis) then
      eta_in = 0.931 - 0.108*log10(X_pp) - 0.204*log10(X_pp)^2 - 0.05954*log10(
      X_pp)^3;
      M_dot = V_dot*rho_su;
      V_dot = V_dot_max*min(X_pp, 1);
    else
      eta_in = eta_is;
      M_dot = V_dot*rho_su;
      V_dot = epsilon_v * V_dot_max *min(X_pp, 1);
    end if;
    /*BOUNDARY CONDITIONS */
    /* Enthalpies */
    h_su = if noEvent(InFlow.m_flow <= 0) then h_ex else inStream(InFlow.h_outflow);
    h_su = InFlow.h_outflow;
    OutFlow.h_outflow = if noEvent(OutFlow.m_flow <= 0) then h_ex else inStream(
      OutFlow.h_outflow);
    /* Mass flow */
    InFlow.m_flow = M_dot;
    OutFlow.m_flow = -M_dot "Flow rate is negative when leaving a component!";
    /*pressures*/
    p_su = InFlow.p;
    p_ex = OutFlow.p;
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}),
                           graphics), Diagram(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),Documentation(info="<HTML>
          
         <p><big>The <b>Pump</b>  model represents the compression of a fluid in a turbo or volumetric machine. It is a lumped model based on performance curves where pump speed is set as an input.
        <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> Isentropic efficiency based on empirical performance curve
         <li> Mass flow rate based on empirical performance curve
         </ul>
      <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are availabe:
        <ul><li>PumpType: it changes the performance curves for isentropic efficiency and mass flow rate.
         <li> PumpInput: it allows to switch the input between frequency and flow fraction
         </ul> 
        </HTML>"));
  end Pump;

  package Reciprocating "A reciprocating machine with different connectors"
    extends Modelica.Icons.Package;

    package BaseClasses
      extends Modelica.Icons.BasesPackage;
      partial record BaseGeometry
        "Base class to define the geometry of a reciprocating machine"
        parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
          "Length of connection rod";
        parameter Modelica.SIunits.Length d_ppin(displayUnit="mm")
          "piston pin offset";
        parameter Modelica.SIunits.Length r_crank(displayUnit="mm")
          "Radius of crank shaft";
        parameter Modelica.SIunits.Length r_piston(displayUnit="mm")
          "Outer radius of piston";
        parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
          "ml=cm^3 - clearance volume";
        parameter Modelica.SIunits.Length h_piston(displayUnit="mm")
          "Height of piston";
        annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Partial Geometry</font></h4></p>
<p>Definition of basic geometry for reciprocating machines. All lengths and volumes are calculate</p>
</html>"));
      end BaseGeometry;

      partial model PartialCylinderHeatTransfer
        extends
          Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer;

        input Modelica.SIunits.Angle crankshaftAngle;
        input Modelica.SIunits.Area pistonCrossArea;
        input Modelica.SIunits.Length strokeLength;

        parameter Integer initialize = 2 "0: None, 1: High HTC, 2: Low HTC";

        import Modelica.Constants.pi;
        Modelica.SIunits.CoefficientOfHeatTransfer[n] h;
        Modelica.SIunits.HeatFlux[n] q_w "Heat flux from wall";

        // Some convenience variables
        Modelica.SIunits.Velocity        c_c "Current piston speed";
        Modelica.SIunits.Velocity        c_m "Mean piston speed";
        Modelica.SIunits.Angle           theta "Crankshaft angle";
        Modelica.SIunits.AngularVelocity omega_c
          "Current angular crank velocity";
        Modelica.SIunits.AngularVelocity omega_m "Mean angular crank velocity";
        Modelica.SIunits.Length          bore;
        Modelica.SIunits.Length          stroke;
        Modelica.SIunits.Length[n]       position "Clearance from cyl. head";
        Modelica.SIunits.Length          position_m
          "Mean clearance from cyl. head";
        Real                             HTC_gain "Amplifier for h[i]";

      equation
        pistonCrossArea = pi*bore*bore/4 "Defines bore";
        strokeLength    = stroke "Defines stroke";
        theta           = mod(crankshaftAngle,2*pi);
        omega_c         = der(crankshaftAngle)
          "Use continuous input for derivative";
        assert(noEvent(omega_c > 1e-6), "Very low rotational speed, make sure connected the crank angle input properly.", level=  AssertionLevel.warning);
        assert(noEvent(strokeLength > 1e-6), "Very short stroke length, make sure you set the parameter in your cylinder model.", level=  AssertionLevel.warning);
        if time>0 then
          omega_m       = crankshaftAngle/time
            "Use continuous input for derivative";
        else
          omega_m       = omega_c;
        end if;
        c_c             = omega_c/2/pi*stroke;
        c_m             = omega_m/2/pi*stroke;
        position_m      = sum(position)/size(position,1);

         if noEvent(initialize==0) then
           // no initialization
           HTC_gain = 1.;
         elseif noEvent(initialize==1) then
           // High heat transfer coefficient
           HTC_gain = 1.0 + (1 - ThermoCycle.Functions.transition_factor(start=0.05,stop=0.1,position=time)) * 100000.0;
         elseif noEvent(initialize==2) then
           // Low heat transfer coefficient
           HTC_gain =            ThermoCycle.Functions.transition_factor(start=0.05,stop=0.1,position=time);
         else
           assert(false, "Please define initialization as 0, 1 or 2.", level=AssertionLevel.error);
           HTC_gain = 1.;
         end if;

        for i in 1:n loop
          surfaceAreas[i] = pistonCrossArea + 2 * sqrt(pistonCrossArea*pi)*position[i]
            "Defines position";
          -q_w[i] = HTC_gain * h[i] * (Ts[i] - heatPorts[i].T);
          Q_flows[i] = surfaceAreas[i]*q_w[i];
        end for;

        annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Heat Transfer Models</font></h4></p>
<p>Base class for heat transfer correlations. The information available inside the subclasses are:</p>
<p>Integer <b>n</b>: The number of entries in the follwoing arrays. Gets defined as 1 in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>PartialMedium <b>Medium</b>: The fluid model used to obtain properties. Redeclared in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>ThermodynamicState <b>states[]:</b> States of working fluid in the cylinder. Also defined in Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel.</p>
<p>Area <b>surfaceAreas[]</b>: Array with areas used for heat exchange. Note that there is probably only one element in this array. The actual area gets calculated from cylinder geometry and does NOT include the piston. Hence it expresses the area of the wall-to-fluid interface. Value from Modelica.Fluid.Machines.SweptVolume.</p>
<p>Angle <b>crankshaftAngle</b>: Angle information from the crankshaft. Can be supplied via an input connector, set to 0 otherwise. Note that all heat transfer models assume 0 to be the top dead centre (TDC).</p>
<p>Area <b>pistonCrossArea</b>: The surface area of the piston. Can be used to obtain the volume from surfaceAreas variable.</p>
<p>Length <b>strokeLength</b>: The stroke of the machine. Can be used to obtain mean piston speed and alike.</p>
<p>Integer <b>initialize</b>: Give 0 for no initialization, 1 for an initialization with a very high heat transfer coefficient, 2 for a very low heat transfer coefficient. </p>
</html>"));
      end PartialCylinderHeatTransfer;

      partial model PartialRecipMachine
        "Model of a one cylinder engine with crank and slider mechanism"
        import SI = Modelica.SIunits;
        parameter Boolean animate=true;
        replaceable parameter
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
          geometry constrainedby
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
          "Define geometry here or replace with approriate record."
                          annotation (choicesAllMatching=true,Placement(transformation(extent={{58,-123},
                  {103,-78}})));
        final parameter SI.Length s_TDC=sqrt((geometry.r_crank + geometry.l_conrod)
            ^2 - geometry.d_ppin^2) "Crank shaft to TDC";
        final parameter SI.Length s_BDC=sqrt((geometry.r_crank - geometry.l_conrod)
            ^2 - geometry.d_ppin^2) "Crank shaft to BDC";
        final parameter SI.Length z_cra=geometry.d_ppin/(geometry.r_crank +
            geometry.l_conrod)*geometry.r_crank "Crank pin z at TDC";
        final parameter SI.Length y_cra=s_TDC/(geometry.r_crank + geometry.l_conrod)
            *geometry.r_crank "Crank pin y at TDC";
        final parameter SI.Length z_rod=geometry.d_ppin/(geometry.r_crank +
            geometry.l_conrod)*geometry.l_conrod "Rod pin z at TDC";
        final parameter SI.Length y_rod=s_TDC/(geometry.r_crank + geometry.l_conrod)
            *geometry.l_conrod "Rod pin y at TDC";
        final parameter SI.Length h_TDC=geometry.V_tdc/(Modelica.Constants.pi
            *geometry.r_piston^2) "equivalent height at TDC";
        final parameter SI.Length h_top=s_TDC + geometry.h_piston + h_TDC
          "Height of cylinder";
        final parameter SI.Length stroke=s_TDC - s_BDC;
        final parameter SI.Length bore=geometry.r_piston*2;
        Modelica.Mechanics.MultiBody.Parts.BodyCylinder piston(
          diameter=2*geometry.r_piston,
          color={155,155,155},
          length=geometry.h_piston,
          r={0,-geometry.h_piston,0})
          annotation (Placement(transformation(
              origin={0,95},
              extent={{-15,15},{15,-15}},
              rotation=270)));
        Modelica.Mechanics.MultiBody.Parts.BodyBox conrod(
          widthDirection={1,0,0},
          r={0,y_rod,z_rod},
          width=crank.width)
                           annotation (Placement(transformation(
              origin={0,15},
              extent={{-15,-15},{15,15}},
              rotation=90)));
        Modelica.Mechanics.MultiBody.Joints.Revolute mainCrankBearing(
          useAxisFlange=true,
          n={1,0,0},
          cylinderColor={100,100,100},
          cylinderLength=0.04,
          cylinderDiameter=0.04) annotation (Placement(transformation(extent={{-95,-80},
                  {-65,-110}},      rotation=0)));
        inner Modelica.Mechanics.MultiBody.World world(nominalLength=0.5,
            enableAnimation=animate)                   annotation (Placement(
              transformation(extent={{-140,-10},{-120,10}}, rotation=0)));
        Modelica.Mechanics.Rotational.Components.Inertia internalInertia(
          phi(displayUnit="rad", start=0),
          w(start=0),
          J=1e-8)                            annotation (Placement(transformation(
                extent={{-15,-15},{15,15}},     rotation=90,
              origin={-80,-135})));
        Modelica.Mechanics.MultiBody.Parts.BodyCylinder crankshaft(
          color={100,100,100},
          diameter=0.02,
          r={0.1,0,0})
          annotation (Placement(transformation(extent={{-45,-110},{-15,-80}},
                rotation=0)));
        Modelica.Mechanics.MultiBody.Parts.BodyBox crank(
          widthDirection={1,0,0},
          r={0,y_cra,z_cra},
          width=0.3*geometry.r_crank)
                      annotation (Placement(transformation(
              origin={0,-65},
              extent={{-15,-15},{15,15}},
              rotation=90)));
        Modelica.Mechanics.MultiBody.Parts.FixedTranslation jacketPosition(
            animation=false, r={crankshaft.r[1],h_top,geometry.d_ppin})
          annotation (Placement(transformation(extent={{-75.5,149},{-55.5,169}},
                rotation=0)));
        Modelica.Mechanics.MultiBody.Joints.Revolute crankPin(
          n={1,0,0},
          cylinderLength=0.03,
          cylinderDiameter=0.03)
          "This is the connection between conrod and crank arm. "
          annotation (Placement(transformation(extent={{-10,-35},{10,-15}})));
        Modelica.Mechanics.MultiBody.Joints.RevolutePlanarLoopConstraint pistonPin(
          n={1,0,0},
          cylinderLength=0.03,
          cylinderDiameter=0.03,
          frame_b(r_0(start={0,0,0})))
          "This is the connection between piston and conrod."
                      annotation (Placement(transformation(extent={{10,45},{-10,65}})));
        Modelica.Mechanics.MultiBody.Joints.Prismatic slider(
          useAxisFlange=true,
          n={0,-1,0},
          boxHeight(displayUnit="mm") = slider.boxWidth,
          boxWidth(displayUnit="mm") = 0.5*crank.width,
          s(start=h_TDC))     annotation (Placement(transformation(
              extent={{-15,-15},{15,15}},
              rotation=-90,
              origin={0,135})));
        Modelica.Mechanics.Rotational.Interfaces.Flange_b crankShaft_b
                                                                    annotation (
            Placement(transformation(extent={{-190,-165},{-170,-145}}),
              iconTransformation(extent={{-200,-110},{-160,-70}})));
        Modelica.Mechanics.Rotational.Interfaces.Flange_a crankShaft_a
                                                                    annotation (
            Placement(transformation(extent={{173,-165},{193,-145}}),
              iconTransformation(extent={{160,-110},{200,-70}})));
      equation
        connect(world.frame_b, mainCrankBearing.frame_a)
          annotation (Line(
            points={{-120,0},{-120,1},{-110,1},{-110,-95},{-103,-95},{-95,-95}},
            color={95,95,95},
            thickness=0.5));
        connect(world.frame_b, jacketPosition.frame_a)
                                                    annotation (Line(
            points={{-120,0},{-120,0},{-110,0},{-110,159},{-75.5,159}},
            color={95,95,95},
            thickness=0.5));
        connect(jacketPosition.frame_b, slider.frame_a) annotation (Line(
            points={{-55.5,159},{2.75546e-015,159},{2.75546e-015,150}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(mainCrankBearing.frame_b, crankshaft.frame_a)
                                                     annotation (Line(
            points={{-65,-95},{-45,-95}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(crank.frame_a, crankshaft.frame_b) annotation (Line(
            points={{-9.18485e-016,-80},{-9.18485e-016,-95},{-15,-95}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(slider.frame_b, piston.frame_a)    annotation (Line(
            points={{-2.75546e-015,120},{0,118},{-1.11023e-015,115},{
                2.75546e-015,115},{2.75546e-015,110}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(piston.frame_b, pistonPin.frame_b) annotation (Line(
            points={{-2.75546e-015,80},{-2.75546e-015,70},{-15,70},{-15,55},{
                -10,55}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(pistonPin.frame_a, conrod.frame_b) annotation (Line(
            points={{10,55},{15,55},{15,40},{9.18485e-016,40},{9.18485e-016,30}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(conrod.frame_a, crankPin.frame_b) annotation (Line(
            points={{-9.18485e-016,-1.77636e-015},{-9.18485e-016,-10},{15,-10},
                {15,-25},{10,-25}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(crankPin.frame_a, crank.frame_b) annotation (Line(
            points={{-10,-25},{-15,-25},{-15,-40},{9.18485e-016,-40},{
                9.18485e-016,-50}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(mainCrankBearing.axis, internalInertia.flange_b) annotation (Line(
            points={{-80,-110},{-80,-120}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(crankShaft_b, internalInertia.flange_a) annotation (Line(
            points={{-180,-155},{-80,-155},{-80,-150}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(internalInertia.flange_a, crankShaft_a) annotation (Line(
            points={{-80,-150},{-80,-155},{183,-155}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-180,-180},{180,180}},
              grid={1,1}), graphics),
          Documentation(info="<html>
<p>
This is a model of the mechanical part of one cylinder of an expander.
You need to add an external calculation of the pressure in the cylinder.
This can be done with respect to the crank angle, the expander starts at
top dead center (TDC) with 0 degrees.
</p>

</html>"),experiment,
          __Dymola_experimentSetupOutput,
          Icon(coordinateSystem(extent={{-180,-180},{180,180}},
                preserveAspectRatio=true), graphics={
              Rectangle(
                extent={{-48,99},{68,23}},
                lineColor={0,0,0},
                fillPattern=FillPattern.VerticalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-50,91},{70,85}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-50,79},{70,73}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-50,65},{70,59}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-48,21},{-30,33},{50,33},{68,21},{-48,21}},
                pattern=LinePattern.None,
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Ellipse(
                extent={{4,51},{12,43}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(extent={{-40,-129},{40,-49}}, lineColor={150,150,150}),
              Line(
                points={{0,-90},{36,-58},{8,46}},
                color={0,0,0},
                thickness=1),
              Text(
                extent={{-180,-120},{180,-180}},
                textString="%name",
                lineColor={0,0,255}),
              Line(
                points={{-160,-90},{180,-90}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{0,128},{0,-110}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.DashDot),
              Line(
                points={{8,128},{8,-110}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.DashDot)}));
      end PartialRecipMachine;

      partial record SimpleGeometry "Simple geometry"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry(
          final d_ppin=0,
          final r_crank=0.5*stroke,
          final r_piston=0.5*bore,
          final h_piston=bore);
        parameter Modelica.SIunits.Length l_conrod(displayUnit="mm")
          "Length of connection rod";
        parameter Modelica.SIunits.Length stroke(displayUnit="mm")
          "Stroke length";
        parameter Modelica.SIunits.Length bore(displayUnit="mm")
          "Cylinder bore";
        parameter Modelica.SIunits.Volume V_tdc(displayUnit="ml")
          "ml=cm^3 - clearance volume";
      end SimpleGeometry;

      model VolumeForces
        "Converts pressure into forces on both ends of a cylinder"
        import SI = Modelica.SIunits;
        extends Modelica.Mechanics.Translational.Interfaces.PartialCompliant;
        parameter SI.Length bore;
        SI.AbsolutePressure p(min=10);
        constant Real pi=Modelica.Constants.pi;
        Modelica.Blocks.Interfaces.RealInput pressure annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=-90,
              origin={0,70})));
      equation
        //s_rel contains the distance between the two flanges...
        p = pressure;
        f = -pi * bore^2/4 * p;
        annotation (Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Rectangle(
                extent={{-90,50},{90,-50}},
                lineColor={0,0,0},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-13,4},{-16,4},{-65,4},{-65,15},{-90,0},{-65,-15},{-65,-4},
                    {-13,-4},{-13,4}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-135,44},{-99,19}},
                lineColor={128,128,128},
                textString="a"),
              Text(
                extent={{97,40},{133,15}},
                lineColor={128,128,128},
                textString="b"),
              Polygon(
                points={{12,4},{70,4},{65,4},{65,15},{90,0},{65,-15},{65,-4},{12,-4},
                    {12,4}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,-50},{150,-100}},
                textString="%name",
                lineColor={0,0,255})}),                         Diagram(
              coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Rectangle(
                extent={{-90,50},{90,-50}},
                lineColor={0,0,0},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{12,5},{70,5},{65,5},{65,16},{90,1},{65,-14},{65,-3},{12,-3},
                    {12,5}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-13,5},{-16,5},{-65,5},{-65,16},{-90,1},{-65,-14},{-65,-3},
                    {-13,-3},{-13,5}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<p>
The gas force in a cylinder is computed as function of the relative
distance of the two flanges. It is required that s_rel = flange_b.s - flange_a.s
is in the range
</p>
<pre>
    0 &le; s_rel &le; L
</pre>
<p>
where the parameter L is the length
of the cylinder. If this assumption is not fulfilled, an error occurs.
</p>
</html>"));
      end VolumeForces;
    end BaseClasses;

    package TestCases "Some models to test basic features"
      extends Modelica.Icons.BasesPackage;

      model Cylinder_tester
        "A combination of Cylinder model and a reciprocating machine"

        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        inner Modelica.Fluid.System system(p_start=40*system.p_ambient, T_start=1273.15)
          annotation (Placement(transformation(extent={{40,40},{60,60}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
        Cylinder cylinder(
          pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
          p_start=system.p_start,
          T_start=system.T_start,
          redeclare package Medium = Modelica.Media.Air.DryAirNasa,
          use_portsData=false,
          use_HeatTransfer=false,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.IdealHeatTransfer)
          annotation (Placement(transformation(extent={{-10,40},{10,20}})));
      equation
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
            points={{6.10623e-16,20},{-1.04854e-15,20},{-1.04854e-15,-1.11022e-15}},
            color={0,127,0},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-80,-80},
                  {80,80}})));
      end Cylinder_tester;

      model Flange_tester
        "A combination of a flange and a reciprocating machine"

        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        inner Modelica.Fluid.System system
          annotation (Placement(transformation(extent={{40,40},{60,60}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
        Modelica.Mechanics.Translational.Sources.Force force(useSupport=false)
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={0,30})));
        Modelica.Blocks.Sources.Ramp ramp(
          height=-20,
          duration=1,
          offset=30,
          startTime=0)
          annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
      equation
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(force.flange, recipFlange.flange_a) annotation (Line(
            points={{-1.22629e-15,20},{-1.04854e-15,20},{-1.04854e-15,
                -1.11022e-15}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(ramp.y, force.f) annotation (Line(
            points={{-29,60},{2.87043e-15,60},{2.87043e-15,42}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-80,-80},
                  {80,80}})));
      end Flange_tester;

      model Fs_tester "Test model for Fs connectors"

        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        inner Modelica.Fluid.System system
          annotation (Placement(transformation(extent={{40,40},{60,60}})));
        RecipMachine_Fs recipFs(redeclare StrokeBoreGeometry
            geometry)
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
        Modelica.Blocks.Sources.Ramp ramp(
          height=-20,
          duration=1,
          offset=30,
          startTime=0)
          annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      equation
        connect(inertia.flange_b, recipFs.crankShaft_b) annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(recipFs.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(ramp.y, recipFs.forces) annotation (Line(
            points={{-39,10},{-26,10},{-26,-6.66667},{-11.1111,-6.66667}},
            color={0,0,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-80,-80},
                  {80,80}})));
      end Fs_tester;

      model PV_tester "Test model"

        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.RecipMachine_PV
          recipPV(redeclare StrokeBoreGeometry geometry, pressure(start=
                closedVolume.p_start))
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
        inner Modelica.Fluid.System system
          annotation (Placement(transformation(extent={{40,40},{60,60}})));
        ClosedVolume closedVolume
          annotation (Placement(transformation(extent={{-10,16},{10,40}})));
      equation
        connect(inertia.flange_b, recipPV.crankShaft_b)             annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(recipPV.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(closedVolume.pressure, recipPV.pressure) annotation (Line(
            points={{-11.25,28},{-20,28},{-20,-6.66667},{-11.1111,-6.66667}},
            color={0,0,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(recipPV.volume, closedVolume.volume) annotation (Line(
            points={{12.2222,-6.66667},{20,-6.66667},{20,28},{12.5,28}},
            color={0,0,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}}),
                            graphics), Icon(coordinateSystem(extent={{-80,-80},
                  {80,80}})),
          experiment(StopTime=15));
      end PV_tester;

      model ValveTimerTester

        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.ValveTimer
          valveTimer annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
        Modelica.Blocks.Sources.Sine sine(
          freqHz=2,
          amplitude=250,
          offset=750)
          annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
        Modelica.Blocks.Continuous.Integrator fakeCrankShaft
          annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
      equation
        connect(sine.y, fakeCrankShaft.u) annotation (Line(
            points={{-59,50},{-50,50},{-50,10},{-42,10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(fakeCrankShaft.y, valveTimer.angle_in) annotation (Line(
            points={{-19,10},{-10,10},{-10,-30},{-2,-30}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end ValveTimerTester;
    end TestCases;

    package Examples "Basic applications of the reciprocating models"
    extends Modelica.Icons.ExamplesPackage;
      model Expander
        "A combination of Cylinder model and a reciprocating machine and valves"
        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
        inner Modelica.Fluid.System system(p_start=system.p_ambient, T_start=573.15)
          annotation (Placement(transformation(extent={{-50,-74},{-30,-54}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
        Cylinder cylinder(
          pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
          p_start=system.p_start,
          T_start=system.T_start,
          use_portsData=false,
          nPorts=2,
          use_HeatTransfer=true,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972,
          use_angle_in=true,
          redeclare package Medium = Modelica.Media.Water.WaterIF97_ph)
          annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

        Modelica.Fluid.Sources.Boundary_pT inlet(
          nPorts=1,
          redeclare package Medium = Modelica.Media.Water.WaterIF97_pT,
          p=2000000,
          T=573.15) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
        Modelica.Fluid.Sources.Boundary_pT outlet(
          nPorts=1,
          p=system.p_ambient,
          T=system.T_ambient,
          redeclare package Medium = Modelica.Media.Water.WaterIF97_pT)
          annotation (Placement(transformation(extent={{40,40},{20,60}})));
        Modelica.Fluid.Valves.ValveCompressible injectionValve(
          m_flow_nominal=1,
          redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
          dp_nominal=100000,
          p_nominal=2000000)
          annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
        Modelica.Fluid.Valves.ValveCompressible exhaustValve(
          m_flow_nominal=1,
          redeclare package Medium = Modelica.Media.Water.WaterIF97_ph,
          dp_nominal=10000,
          p_nominal=100000)
          annotation (Placement(transformation(extent={{-10,40},{10,60}})));
        ValveTimer exhaustTimer(
          input_in_rad=true,
          open=3.0543261909901,
          close=3.6651914291881,
          switch=0.17453292519943)
          annotation (Placement(transformation(extent={{40,-20},{60,0}})));
        Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
          annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
        ValveTimer injectionTimer(
          input_in_rad=true,
          open=-0.087266462599716,
          close=0.34906585039887,
          switch=0.17453292519943)
          annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
        Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque load(
            tau_nominal=-20, w_nominal(displayUnit="rpm") = 52.35987755983)
          annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
        Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*25, T(start=
                773.15))
          annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      equation
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-50,-30},{-40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
            points={{-20,20},{-20,0}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
            points={{0,-30},{10,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(angleSensor.phi, exhaustTimer.angle_in) annotation (Line(
            points={{31,-30},{34,-30},{34,-10},{38,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(angleSensor.phi, injectionTimer.angle_in) annotation (Line(
            points={{31,-30},{34,-30},{34,-50},{38,-50}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(exhaustTimer.y, exhaustValve.opening) annotation (Line(
            points={{61,-10},{66,-10},{66,70},{0,70},{0,58}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(injectionTimer.y, injectionValve.opening) annotation (Line(
            points={{61,-50},{74,-50},{74,76},{-40,76},{-40,58}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(inlet.ports[1], injectionValve.port_a) annotation (Line(
            points={{-60,50},{-50,50}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(injectionValve.port_b, cylinder.ports[1]) annotation (Line(
            points={{-30,50},{-22,50},{-22,40}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(exhaustValve.port_a, cylinder.ports[2]) annotation (Line(
            points={{-10,50},{-18,50},{-18,40}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(exhaustValve.port_b, outlet.ports[1]) annotation (Line(
            points={{10,50},{20,50}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(load.flange, inertia.flange_a) annotation (Line(
            points={{-80,-30},{-70,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
            points={{31,-30},{34,-30},{34,30},{-10,30}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cylinder.heatPort, wall.port) annotation (Line(
            points={{-30,30},{-40,30},{-40,0},{-70,0},{-70,10}},
            color={191,0,0},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                  100}})));
      end Expander;

      model Compressor
        "A combination of Cylinder model, a reciprocating machine and check valves"
        replaceable package WorkingFluid = ThermoCycle.Media.R134a_CP constrainedby
          Modelica.Media.Interfaces.PartialMedium;

        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=104.71975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
        inner Modelica.Fluid.System system(
          p_start(displayUnit="Pa") = ThermoCycle.Media.R134a_CP.saturationPressure(
            system.T_start) - 5,
          dp_small(displayUnit="Pa"),
          T_start=373.15)
          annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-20,-80},{20,-40}})));
        Cylinder cylinder(
          pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
          use_portsData=false,
          nPorts=2,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          use_HeatTransfer=true,
          p_start=inlet.p,
          redeclare package Medium = WorkingFluid,
          T_start=system.T_start - 1,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972)
          annotation (Placement(transformation(extent={{-10,-10},{10,-30}})));

        Modelica.Fluid.Sources.Boundary_pT inlet(
          nPorts=1,
          redeclare package Medium = WorkingFluid,
          p=125000,
          T=333.15) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
        Modelica.Fluid.Sources.Boundary_pT outlet(
          nPorts=1,
          redeclare package Medium = WorkingFluid,
          p=1000000,
          T=473.15)           annotation (Placement(transformation(extent={{70,-10},{50,
                  10}})));

        Modelica.Fluid.Valves.ValveCompressible suctionValve(
          m_flow_nominal=0.1,
          filteredOpening=true,
          leakageOpening=1e-7,
          redeclare package Medium = WorkingFluid,
          dp_nominal=50000,
          riseTime(displayUnit="ms") = 1e-05,
          p_nominal=100000)
          annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
        Modelica.Fluid.Valves.ValveCompressible exhaustValve(
          m_flow_nominal=0.1,
          filteredOpening=true,
          riseTime=suctionValve.riseTime,
          leakageOpening=suctionValve.leakageOpening,
          redeclare package Medium = WorkingFluid,
          dp_nominal=50000,
          p_nominal=1000000)
          annotation (Placement(transformation(extent={{10,-10},{30,10}})));
        Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
          annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
        Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*2500, T(start=
                system.T_start, fixed=true))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Blocks.Nonlinear.Limiter limitIn(uMin=0, uMax=1) annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={-20,30})));
        Modelica.Fluid.Sensors.RelativePressure dpInlet(redeclare package
            Medium =
              WorkingFluid)
          annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
        Modelica.Blocks.Nonlinear.Limiter limitOut(uMin=0, uMax=1) annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={20,30})));
        Modelica.Fluid.Sensors.RelativePressure dpOutlet(redeclare package
            Medium =
              WorkingFluid)
          annotation (Placement(transformation(extent={{10,80},{30,100}})));
        Modelica.Blocks.Math.Gain gainIn(k=0.01) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={-20,60})));
        Modelica.Blocks.Math.Gain gainOut(k=0.01) annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=-90,
              origin={20,60})));
        Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(
            tau_constant=50)
          annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
      equation
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-30,-70},{-20,-70}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
            points={{0,-30},{0,-40}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
            points={{20,-70},{30,-70}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(inlet.ports[1], suctionValve.port_a)   annotation (Line(
            points={{-50,0},{-30,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(suctionValve.port_b, cylinder.ports[1])   annotation (Line(
            points={{-10,0},{0,0},{0,-10},{-2,-10}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(exhaustValve.port_a, cylinder.ports[2]) annotation (Line(
            points={{10,0},{0,0},{0,-10},{2,-10}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
            points={{51,-70},{54,-70},{54,-20},{10,-20}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cylinder.heatPort, wall.port) annotation (Line(
            points={{-10,-20},{-20,-20},{-20,-40},{-50,-40}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(dpInlet.port_a, suctionValve.port_a) annotation (Line(
            points={{-30,90},{-40,90},{-40,0},{-30,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(dpInlet.port_b, suctionValve.port_b) annotation (Line(
            points={{-10,90},{0,90},{0,0},{-10,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(dpInlet.port_b, dpOutlet.port_a) annotation (Line(
            points={{-10,90},{10,90}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(exhaustValve.port_b, dpOutlet.port_b) annotation (Line(
            points={{30,0},{40,0},{40,90},{30,90}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(exhaustValve.port_b, outlet.ports[1]) annotation (Line(
            points={{30,0},{50,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(dpInlet.p_rel, gainIn.u) annotation (Line(
            points={{-20,81},{-20,76.5},{-20,72},{-20,72}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gainIn.y, limitIn.u) annotation (Line(
            points={{-20,49},{-20,47.25},{-20,47.25},{-20,45.5},{-20,42},{-20,
                42}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(dpOutlet.p_rel, gainOut.u) annotation (Line(
            points={{20,81},{20,76.5},{20,72},{20,72}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gainOut.y, limitOut.u) annotation (Line(
            points={{20,49},{20,47.25},{20,47.25},{20,45.5},{20,42},{20,42}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(constantTorque.flange, inertia.flange_a) annotation (Line(
            points={{-60,-70},{-50,-70}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(limitIn.y, suctionValve.opening) annotation (Line(
            points={{-20,19},{-20,13.5},{-20,13.5},{-20,8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(limitOut.y, exhaustValve.opening) annotation (Line(
            points={{20,19},{20,13.5},{20,13.5},{20,8}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                preserveAspectRatio=false),
                            graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                  100}})));
      end Compressor;
    end Examples;

    model ClosedVolume "Model of a confined volume without mass transfer"

      Modelica.Blocks.Interfaces.RealInput volume
        annotation (Placement(transformation(extent={{120,-20},{80,20}}),
            iconTransformation(extent={{120,-20},{80,20}})));
      Modelica.Blocks.Interfaces.RealOutput pressure
        annotation (Placement(transformation(extent={{-58,-10},{-78,10}}),
            iconTransformation(extent={{-80,-10},{-100,10}})));
        outer Modelica.Fluid.System system;
      replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby
        Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
      Medium.BaseProperties props;
      //parameter Medium.Density rho_start = 1.2;
      parameter Medium.Temperature T_start = 1500 "Initial temperature";
      parameter Medium.AbsolutePressure p_start = 40*system.p_ambient
        "Initial pressure";
      parameter Modelica.SIunits.HeatFlowRate Q_dot = -10 "Constant heat flux";
      Modelica.SIunits.Mass m;
      Modelica.SIunits.InternalEnergy U;
      Modelica.SIunits.Power W_dot;
    // initial algorithm
    //    Medium.setState_pTX(p_start,T_start,{1});
    initial algorithm
        m := Medium.density_pTX(p_start,T_start,{1})*volume;
        U := m*(Medium.specificEnthalpy_pTX(p_start,T_start,{1}) - p_start / Medium.density_pTX(p_start,T_start,{1}));
    //    props.T =T_start;
    //    props.p =p_start;
    equation
        props.p = pressure;
        U    = m*props.u;
        der(m) = 0;
        props.d * volume = m;
        der(U) = W_dot + Q_dot;
        W_dot = -der(volume) * pressure;
      annotation (Icon(coordinateSystem(extent={{-80,-100},{80,100}},
              preserveAspectRatio=true),
                       graphics={
            Polygon(
              points={{-48,60},{-48,-60},{-40,-60},{-40,50},{40,50},{40,-60},
                  {48,-60},{48,60},{-48,60}},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Backward,
              lineColor={0,0,0}),Text(
              extent={{60,40},{100,20}},
              lineColor={0,0,255},
              textString="V",
              textStyle={TextStyle.Italic}),
                               Text(
              extent={{-100,40},{-60,20}},
              lineColor={0,0,255},
              textStyle={TextStyle.Italic},
              textString="p"),
            Polygon(
              points={{-40,0},{40,0},{40,-20},{6,-20},{6,-80},{-6,-80},{-6,
                  -20},{-40,-20},{-40,0}},
              lineColor={0,0,0},
              smooth=Smooth.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Forward),
            Text(
              extent={{-60,100},{60,60}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Forward,
              textString="closed")}),
                                 Diagram(coordinateSystem(extent={{-80,-100},
                {80,100}}),              graphics));
    end ClosedVolume;

    package HeatTransfer "A collection of heat transfer correlations"
      extends Modelica.Icons.VariantsPackage;

      model Annand1963 "Recip ICE correlation of Annand 1963"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
          final a=0.575,
          final b=0.700,
          final c=0.000);

      equation
        for i in 1:n loop
          Lambda[i] = c_m;
          Gamma[i]  = bore;
        end for;

        annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Annand1963\">(Annand1963)</a></dt>
<dd>Annand, W.</dd>
<dd><i>Heat transfer in cylinders of reciprocating internal combustion engines</i></dd>
<dd>Proceedings of the Institution of Mechanical Engineers, <b>1963</b>, Vol. 177(36), pp. 973-996</dd>
</dl>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
      end Annand1963;

      model Woschni1967 "Recip ICE correlation of Woschni 1967"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
          final a=0.035,
          final b=0.800,
          final c=0.000);

      equation
        for i in 1:n loop
          //Use compression phase only, neglect scavenging and combustion terms.
          Lambda[i] = 2.28*c_m;
          Gamma[i]  = bore;

        end for;

        annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Woschni1967\">(Woschni1967)</a></dt>
<dd>Woschni, G.</dd>
<dd><i>A Universally Applicable Equation for the Instantaneous Heat Transfer Coefficient in the Internal Combustion Engine</i></dd>
<dd>SAE Preprints, Society of Automotive Engineers (SAE), <b>1967</b>(670931)</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://papers.sae.org/670931/\">http://papers.sae.org/670931/</a> </p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>


"));
      end Woschni1967;

      model Adair1972 "Recip compressor correlation of Adair 1972"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
          final a=0.053,
          final b=0.800,
          final c=0.600);

         parameter Boolean inletTDC = true
          "admission at TDC (expander) or BDC (compressor)";

        import Modelica.Constants.pi;
        Modelica.SIunits.Length[n]          De "Equivalent diameter 6V/A";
        Modelica.SIunits.AngularVelocity[n] omega_g "Swirl velocity";
        Modelica.SIunits.Volume[n]          volume "Cylinder volume";
        Real tFactor[n];
        Real tFactor1[n];
        Real tFactor2[n] "Transition factor";
        Real deltaTheta "Transition interval";

      protected
        Real thetaCorr;

      algorithm
        if inletTDC then
          thetaCorr := 0;
        else
          thetaCorr := pi;
        end if;

      equation
        deltaTheta = 0.05*pi "9 degrees crankshaft angle";
        for i in 1:n loop
          // Equation 15 from Adair et al.
          //omega_g1[i] = 2*omega[i]*(1.04+cos(2*theta[i]));
          //omega_g2[i] = 2*omega[i]*1/2*(1.04+cos(2*theta[i]));
          // Removed the switch from the paper and replaced
          // it with a smooth transition.
          //if (3/2*pi<theta[i] or theta[i]<1/2*pi) then
          //  omega_g[i] = omega_g1[i];
          //else
          //  omega_g[i] = omega_g2[i];
          //end if;
          tFactor1[i] = ThermoCycle.Functions.transition_factor(
             start=1/2*pi-0.5*deltaTheta,stop=1/2*pi+0.5*deltaTheta,position=theta)
            "Switch from omega_g1 to omega_g2";
          tFactor2[i] = ThermoCycle.Functions.transition_factor(
             start=3/2*pi-0.5*deltaTheta,stop=3/2*pi+0.5*deltaTheta,position=theta)
            "Switch back from omega_g2 to omega_g1";
          tFactor[i] = tFactor1[i] - tFactor2[i];
          omega_g[i] = (1-(tFactor[i]*0.5))*2*omega_c/2/pi*(1.04+cos(2*theta));
          volume[i] = pistonCrossArea * position[i] "Get volumes";
          De[i] = 6 / pistonCrossArea * volume[i];

          Gamma[i]  = De[i];
          Lambda[i] = 0.5 * De[i] * omega_g[i];

        end for;

        annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Adair1972\">(Adair1972)</a></dt>
<dd>Adair, R.P., Qvale, E.B. &amp; Pearson, J.T.</dd>
<dd><i>Instantaneous Heat Transfer to the Cylinder Wall in Reciprocating Compressors</i></dd>
<dd>Proceedings of the International Compressor Engineering Conference</dd>
<dd><b>1972</b>(Paper 86), pp. 521-526</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://docs.lib.purdue.edu/icec/45/\">http://docs.lib.purdue.edu/icec/45</a></p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>

"));
      end Adair1972;

      model Destoop1986 "Recip compressor correlation of Destoop 1986"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
          final a=0.6,
          final b=0.8,
          final c=0.6);

      equation
        for i in 1:n loop
          Lambda[i] = c_m;
          Gamma[i]  = bore;
        end for;

        annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Annand1963\">(Annand1963)</a></dt>
<dd>Annand, W.</dd>
<dd><i>Heat transfer in cylinders of reciprocating internal combustion engines</i></dd>
<dd>Proceedings of the Institution of Mechanical Engineers, <b>1963</b>, Vol. 177(36), pp. 973-996</dd>
</dl>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
      end Destoop1986;

      model Kornhauser1994 "Recip compressor correlation of Kornhauser 1994"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

        parameter Real a = 0.56 "Factor";
        parameter Real b = 0.69 "Peclet exponent";

        import Modelica.Constants.pi;

        Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
        Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

        Modelica.SIunits.PecletNumber[n] Pe(min=0);
        Modelica.SIunits.SpecificHeatCapacityAtConstantPressure[n] cp;
        Modelica.SIunits.Volume[n] volume "Cylinder volume";
        Modelica.SIunits.Length[n] D_h "Hydraulic diameter";
        Modelica.SIunits.ThermalDiffusivity[n] alpha_f "Thermal diffusivity";

        Modelica.SIunits.NusseltNumber[n] Nu(min=0);
        Modelica.SIunits.ThermalConductivity[n] lambda;
        Modelica.SIunits.DynamicViscosity[n] eta;
      equation
        for i in 1:n loop
          // Get transport properties from Medium model
          eta[i] = Medium.dynamicViscosity(states[i]);
          assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
          lambda[i] = Medium.thermalConductivity(states[i]);
          assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
          cp[i] = Medium.specificHeatCapacityCp(states[i]);
          assert(cp[i] > 0, "Invalid heat capacity, make sure that your are not in the two-phase region.");
          // Find characteristic values
          volume[i] = pistonCrossArea * position[i] "Get volumes";
          D_h[i] =  4 * volume[i] / pistonCrossArea "Hydraulic diameter";
          Gamma[i] = D_h[i];
          Lambda[i] = omega_c/2/pi "Angular velocity";
          // Use transport properties to determine dimensionless numbers
          alpha_f[i]  = lambda[i] / (Medium.density(states[i]) * cp[i]);
          Pe[i] = (Lambda[i] * Gamma[i] * Gamma[i]) / (4*alpha_f[i]);
          assert(Pe[i] > 0, "Invalid Peclet number, make sure transport properties are calculated.");
          Nu[i] =  a * Pe[i]^b;
          h[i]  = Nu[i] * lambda[i] / Gamma[i];
        end for;
        annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Kornhauser1994\">(Kornhauser1994)</a></dt>
<dd>Kornhauser, A. &amp; Smith, J.</dd>
<dd><i>Application of a complex Nusselt number to heat transfer during compression and expansion</i></dd>
<dd>Transactions of the ASME. Journal of Heat Transfer, <b>1994</b>, Vol. 116(3), pp. 536-542</dd>
</dl>
<p>You can find the paper describing the correlation here: <a href=\"http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736\">http://heattransfer.asmedigitalcollection.asme.org/article.aspx?articleid=1441736</a></p>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
      end Kornhauser1994;

      model Irimescu2013 "Recip ICE correlation of Irimescu 2013"
        extends GnielinskiHeatTransfer;

        import Modelica.Constants.pi;
        Medium.ThermodynamicState[n] states_w "Thermodynamic states at wall";
        Modelica.SIunits.DynamicViscosity[n] eta_w "At wall temperature";

      equation
        for i in 1:n loop
          states_w[i] = Medium.setState_pTX(Medium.pressure(states[i]),heatPorts[i].T,{1});//,states[i].X);
          assert(false, "Concentration is neglected heat transfer model Irimescu2013", AssertionLevel.warning);

          eta_w[i]    = Medium.dynamicViscosity(states_w[i]);
          assert(eta_w[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");

          Gamma[i]    = bore "Characteristic length";
          Lambda[i]   = c_c "Characteristic velocity";
          zeta[i]     = (1.82 * log10(Re[i])-1.64)^(-2);
          xtra[i]     = 1000.;
          K[i]        = (eta[i]/eta_w[i])^(0.14);
        end for;

        annotation (Documentation(info="<html>
<p><h4>Reference: </h4></p>
<p>In 2013, Irimescu adapted an older equation by Gnielinski for SI and CI engines. Note that this implementation contains a simplified version using only the piston speed as characteristic velocity whereas the paper by Irimescu proposes a turbulence-based approach for this purpose.</p>
<dl><dt><a name=\"Irimescu2013\">(</a>Irimescu2013)</dt>
<dd>Irimescu, A.</dd>
<dd><i>Convective heat transfer equation for turbulent flow in tubes applied to internal combustion engines operated under motored conditions</i></dd>
<dd>Applied Thermal Engineering, <b>2013</b>, Vol. 50(1), pp. 536-545</dd>
<dl><dt><a name=\"Gnielinski1976\">(</a>Gnielinski1976)</dt>
<dd>Gnielinski, V.</dd>
<dd><i>New Equations For Heat And Mass-transfer In Turbulent Pipe And Channel Flow</i></dd>
<dd>International Chemical Engineering, <b>1976</b>, Vol. 16(2), pp. 359-368</dd>
</dl><p><h4>Implementation: </h4></p>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</html>"));
      end Irimescu2013;

      model Gnielinski2010 "Pipe correlation of Gnielinski 2010"
        extends GnielinskiHeatTransfer;

        parameter Real sigma = 0.14 "Correction exponent";

      equation
        for i in 1:n loop
          Gamma[i]    = bore "Characteristic length";
          Lambda[i]   = c_m "Characteristic velocity";
          zeta[i]     = (1.80 * log10(Re[i])-1.50)^(-2);
          xtra[i]     = 0.;
          K[i]        = 1.;//(Medium.temperature(states[i])/heatPorts[i].T)^(sigma);
        end for;

        annotation (Documentation(info="<html>
<p><h4>Reference: </h4></p>
<p>In 2013, Irimescu adapted an older equation by Gnielinski for SI and CI engines. Note that this implementation contains a simplified version using only the piston speed as characteristic velocity whereas the paper by Irimescu proposes a turbulence-based approach for this purpose.</p>
<dl><dt><a name=\"Irimescu2013\">(</a>Irimescu2013)</dt>
<dd>Irimescu, A.</dd>
<dd><i>Convective heat transfer equation for turbulent flow in tubes applied to internal combustion engines operated under motored conditions</i></dd>
<dd>Applied Thermal Engineering, <b>2013</b>, Vol. 50(1), pp. 536-545</dd>
<dl><dt><a name=\"Gnielinski1976\">(</a>Gnielinski1976)</dt>
<dd>Gnielinski, V.</dd>
<dd><i>New Equations For Heat And Mass-transfer In Turbulent Pipe And Channel Flow</i></dd>
<dd>International Chemical Engineering, <b>1976</b>, Vol. 16(2), pp. 359-368</dd>
</dl><p><h4>Implementation: </h4></p>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</html>"));
      end Gnielinski2010;

      partial model RePrHeatTransfer
        "Recip heat transfer based on Reynolds and Prandl number"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

        parameter Real a = 0.500 "Factor";
        parameter Real b = 0.800 "Reynolds exponent";
        parameter Real c = 0.600 "Prandl exponent";

        Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
        Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

        Modelica.SIunits.ReynoldsNumber[n] Re(min=0);
        Modelica.SIunits.PrandtlNumber[n] Pr(min=0);
        Modelica.SIunits.NusseltNumber[n] Nu(min=0);

        Modelica.SIunits.ThermalConductivity[n] lambda;
        Modelica.SIunits.DynamicViscosity[n] eta;

      equation
        for i in 1:n loop
          // Get transport properties from Medium model
          Pr[i] = Medium.prandtlNumber(states[i]);
          assert(Pr[i] > 0, "Invalid Prandtl number, make sure transport properties are calculated.");
          eta[i] = Medium.dynamicViscosity(states[i]);
          assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
          lambda[i] = Medium.thermalConductivity(states[i]);
          assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
          // Use transport properties to determine dimensionless numbers
          Re[i] = (Medium.density(states[i]) * Lambda[i] * Gamma[i]) / eta[i];
          Nu[i] =  a * Re[i]^b * Pr[i]^c;
          h[i]  = Nu[i] * lambda[i] / Gamma[i];
        end for;
        annotation(Documentation(info="<html>
<p>Base class from Python code. </p>
</html>"));
      end RePrHeatTransfer;

      model ConstantHeatTransfer
        "Recip heat transfer with constant heat transfer coefficient"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
        parameter Modelica.SIunits.CoefficientOfHeatTransfer alpha0
          "constant heat transfer coefficient";
      equation
        Q_flows = {(alpha0+k)*surfaceAreas[i]*(heatPorts[i].T - Ts[i]) for i in 1:n};
        annotation(Documentation(info="<html>
<p>Simple heat transfer correlation with constant heat transfer coefficient. </p>
<p>Taken from: Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.ConstantHeatTransfer</p>
</html>"));
      end ConstantHeatTransfer;

      model IdealHeatTransfer "Recip heat transfer without thermal resistance"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;
      equation
        Ts = heatPorts.T;
        annotation(Documentation(info="<html>
<p>Ideal heat transfer without thermal resistance. </p>
<p><br/>This is taken from: Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer</p>
</html>"));
      end IdealHeatTransfer;

      model HX_base
        "A combination of Cylinder model and a reciprocating machine"
        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          J=2,
          w(start=10.471975511966,
            fixed=true,
            displayUnit="rpm"))
          annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        inner Modelica.Fluid.System system(p_start=40*system.p_ambient, T_start=1273.15)
          annotation (Placement(transformation(extent={{40,40},{60,60}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));
        Cylinder cylinder(
          pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
          p_start=system.p_start,
          T_start=system.T_start,
          redeclare package Medium = Modelica.Media.Air.DryAirNasa,
          use_portsData=false)
          annotation (Placement(transformation(extent={{-10,40},{10,20}})));
        Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(C=0.5*25, T(start=
                773.15))
          annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
        Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
          annotation (Placement(transformation(extent={{40,-20},{60,0}})));
      equation
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
            points={{6.10623e-16,20},{-1.04854e-15,20},{-1.04854e-15,-1.11022e-15}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
            points={{20,-30},{20,-10},{40,-10}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-80,-80},{80,80}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-80,-80},
                  {80,80}})));
      end HX_base;

      model HX_full
        "A combination of Cylinder model and a reciprocating machine"
        replaceable package WorkingFluid = ThermoCycle.Media.R134a_CP;
        //ThermoCycle.Media.R134aCP;
        //ThermoCycle.Media.AirCP;
        //CoolProp2Modelica.Media.R601_CP;
        //Modelica.Media.Air.DryAirNasa;
        //constrainedby Modelica.Media.Interfaces.PartialMedium;

        Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed
          annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
        inner Modelica.Fluid.System system(p_start=2000000, T_start=473.15)
          annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
        RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
          annotation (Placement(transformation(extent={{-20,-40},{20,0}})));

        Modelica.Thermal.HeatTransfer.Components.HeatCapacitor wall(T(start=system.T_start),
            C=0.5*2500)
          annotation (Placement(transformation(extent={{-10,60},{10,80}})));
        Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
          annotation (Placement(transformation(extent={{10,-10},{-10,10}},
              rotation=-90,
              origin={-32,0})));

        Cylinder cylinder(
          redeclare package Medium = WorkingFluid,
          pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start)
          annotation (Placement(transformation(extent={{-120,40},{-100,20}})));
        Cylinder annand(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Annand1963,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          use_HeatTransfer=true)
          annotation (Placement(transformation(extent={{-90,40},{-70,20}})));

        Cylinder woschni(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Woschni1967,
          use_HeatTransfer=true)
          annotation (Placement(transformation(extent={{-60,40},{-40,20}})));

        Cylinder adair(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_HeatTransfer=true,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Adair1972)
          annotation (Placement(transformation(extent={{-30,40},{-10,20}})));
        Cylinder destoop(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Destoop1986,
          use_HeatTransfer=true)
          annotation (Placement(transformation(extent={{0,40},{20,20}})));

        Cylinder kornhauser(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_HeatTransfer=true,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Kornhauser1994)
          annotation (Placement(transformation(extent={{30,40},{50,20}})));
        Modelica.Mechanics.Rotational.Components.Inertia inertia(
          phi(fixed=true, start=0),
          w(start=10, fixed=true),
          J=2000)
                 annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
        Cylinder irimescu(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_HeatTransfer=true,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Irimescu2013)
          annotation (Placement(transformation(extent={{60,40},{80,20}})));
        Cylinder gnielinski(
          redeclare package Medium = WorkingFluid,
          use_portsData=false,
          p_start=system.p_start,
          T_start=system.T_start,
          pistonCrossArea=cylinder.pistonCrossArea,
          use_HeatTransfer=true,
          use_angle_in=true,
          stroke=recipFlange.stroke,
          redeclare model HeatTransfer =
              ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.Gnielinski2010)
          annotation (Placement(transformation(extent={{90,40},{110,20}})));
      equation
        connect(recipFlange.crankShaft_a, speed.flange) annotation (Line(
            points={{20,-30},{40,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(cylinder.flange, annand.flange) annotation (Line(
            points={{-110,20},{-80,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(annand.flange, woschni.flange) annotation (Line(
            points={{-80,20},{-50,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(woschni.flange, adair.flange) annotation (Line(
            points={{-50,20},{-20,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(adair.flange, destoop.flange) annotation (Line(
            points={{-20,20},{10,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(destoop.flange, kornhauser.flange) annotation (Line(
            points={{10,20},{40,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(annand.heatPort, wall.port) annotation (Line(
            points={{-90,30},{-90,60},{4.44089e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(woschni.heatPort, wall.port) annotation (Line(
            points={{-60,30},{-60,60},{4.44089e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(adair.heatPort, wall.port) annotation (Line(
            points={{-30,30},{-30,60},{4.44089e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(destoop.heatPort, wall.port) annotation (Line(
            points={{0,30},{0,60},{4.44089e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(kornhauser.heatPort, wall.port) annotation (Line(
            points={{30,30},{30,60},{4.44089e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(destoop.flange, recipFlange.flange_a) annotation (Line(
            points={{10,20},{10,0},{-8.88178e-16,0}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(inertia.flange_b, recipFlange.crankShaft_b) annotation (Line(
            points={{-40,-30},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(irimescu.heatPort, wall.port) annotation (Line(
            points={{60,30},{60,60},{5.55112e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(angleSensor.flange, recipFlange.crankShaft_b) annotation (Line(
            points={{-32,-10},{-20,-10},{-20,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(annand.angle_in, angleSensor.phi) annotation (Line(
            points={{-70,30},{-70,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(woschni.angle_in, angleSensor.phi) annotation (Line(
            points={{-40,30},{-40,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(adair.angle_in, angleSensor.phi) annotation (Line(
            points={{-10,30},{-12,30},{-12,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(destoop.angle_in, angleSensor.phi) annotation (Line(
            points={{20,30},{20,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(kornhauser.angle_in, angleSensor.phi) annotation (Line(
            points={{50,30},{50,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(irimescu.angle_in, angleSensor.phi) annotation (Line(
            points={{80,30},{80,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(irimescu.flange, kornhauser.flange) annotation (Line(
            points={{70,20},{40,20}},
            color={0,127,0},
            smooth=Smooth.None));
        connect(gnielinski.heatPort, wall.port) annotation (Line(
            points={{90,30},{90,60},{5.55112e-16,60}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(gnielinski.angle_in, angleSensor.phi) annotation (Line(
            points={{110,30},{110,11},{-32,11}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gnielinski.flange, irimescu.flange) annotation (Line(
            points={{100,20},{70,20}},
            color={0,127,0},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-120,-80},{120,80}},
                preserveAspectRatio=false),
                            graphics), Icon(coordinateSystem(extent={{-120,-80},{120,
                  80}})));
      end HX_full;

      partial model GnielinskiHeatTransfer
        "Recip heat transfer based on Gnielinski pipe equation"
        extends
          ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer;

        import Modelica.Constants.pi;
        Modelica.SIunits.Length[n] Gamma(min=0) "Characteristic length";
        Modelica.SIunits.Velocity[n] Lambda(min=0) "Characteristic velocity";

        // Other things to define
        Real[n] xtra "Reynolds correction factor";
        Real[n] zeta "Friction factor";
        Real[n] K "Correction term";

        Modelica.SIunits.Length[n] D(min=0) "Pipe diameter";
        Modelica.SIunits.Length[n] L(min=0) "Pipe length";

        Modelica.SIunits.ReynoldsNumber[n] Re(min=0);
        Modelica.SIunits.PrandtlNumber[n] Pr(min=0);
        Modelica.SIunits.NusseltNumber[n] Nu(min=0);

        Modelica.SIunits.ThermalConductivity[n] lambda;
        Modelica.SIunits.DynamicViscosity[n] eta;
        Modelica.SIunits.SpecificHeatCapacityAtConstantPressure[n] cp;

        Real[n] numerator;
        Real[n] denominator;

      equation
        for i in 1:n loop
          // Get transport properties from Medium model
          eta[i] = Medium.dynamicViscosity(states[i]);
          assert(eta[i] > 0, "Invalid viscosity, make sure transport properties are calculated.");
          lambda[i] = Medium.thermalConductivity(states[i]);
          assert(lambda[i] > 0, "Invalid thermal conductivity, make sure transport properties are calculated.");
          cp[i] = Medium.specificHeatCapacityCp(states[i]);
          assert(cp[i] > 0, "Invalid heat capacity, make sure that your are not in the two-phase region.");
          // Use transport properties to determine dimensionless numbers
          Pr[i]          = cp[i] * eta[i] / lambda[i];
          Re[i]          = (Medium.density(states[i]) * Lambda[i] * Gamma[i]) / eta[i];
          numerator[i]   = (zeta[i]/8.) * (Re[i]-xtra[i]) * Pr[i];
          denominator[i] = 1 + 12.7 * sqrt(zeta[i]/8.) *( Pr[i]^(2./3.) - 1.);
          surfaceAreas[i] = pistonCrossArea + 2 * sqrt(pistonCrossArea*pi)*L[i]
            "Defines clearance length";
          D[i]           = Gamma[i];
          Nu[i]          = numerator[i] / denominator[i] *( 1 + (D[i]/L[i])^(2./3.))*
            K[i];
          h[i]           = Nu[i] * lambda[i] / Gamma[i];

        end for;
        annotation(Documentation(info="<html>
<p>Base class from Python code. </p>
</html>"));
      end GnielinskiHeatTransfer;
      annotation (Icon(graphics={        Ellipse(
                extent={{-80,60},{-20,0}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={232,0,0})}));
    end HeatTransfer;

    model Cylinder
      "SweptVolume from Modelica.Fluid with initialisation algorihtm and default Medium"
      extends Modelica.Fluid.Machines.SweptVolume(final clearance=0,HeatTransfer(crankshaftAngle=angle_in_internal,pistonCrossArea = pistonCrossArea,strokeLength=stroke));
      parameter Boolean use_angle_in = false
        "Enable input connector for crankshaft angle"
        annotation (Dialog(tab="Assumptions", group="Heat transfer"));
      parameter Modelica.SIunits.Length stroke = 0 "Input for max. stroke"
        annotation (Dialog(tab="Assumptions", group="Heat transfer"));
    //     parameter Real stroke = 0
    //     "Assume a sine-like piston movement"
    //     annotation (Evaluate = true,
    //                 Dialog(tab="Assumptions", group="Heat transfer",enable = not use_angle_in));
      Modelica.Blocks.Interfaces.RealInput angle_in if use_angle_in annotation (Placement(
            transformation(extent={{120,-20},{80,20}}), iconTransformation(extent={{
                120,-20},{80,20}})));
    protected
        Modelica.Blocks.Interfaces.RealInput angle_in_internal;
    initial algorithm
    //   if use_T_start then
    //   medium.state :=Medium.setState_pTX(
    //       p_start,
    //       T_start,
    //       X_start);
    //   else
    //     medium.state :=Medium.setState_phX(
    //       p_start,
    //       h_start,
    //       X_start);
    //   end if;
      m := medium.d*V;
      U := m*(medium.h - p_start / medium.d);
    // equation
    //   test = heatTransfer(crankshaftAngle=5);
    equation
        connect(angle_in, angle_in_internal);
      if noEvent(not use_angle_in) then
        angle_in_internal = 0;
      end if;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                       graphics), Diagram(graphics));
    end Cylinder;

    record ExpanderGeometry =
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
        (
        l_conrod=0.15,
        d_ppin=0.001,
        r_crank=0.05,
        r_piston=0.05,
        V_tdc=50e-6,
        h_piston=0.05) "Small scale ORC expander";
    model RecipMachine_Flange
      "Model of single cylinder with a flange connector"
      extends
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
    public
      Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a
        annotation (Placement(transformation(extent={{-10,170},{10,190}})));
    equation
      connect(flange_a, slider.axis) annotation (Line(
          points={{0,180},{0,180},{0,168},{40,168},{40,123},{9,123}},
          color={0,127,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-180},
                {180,180}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-180,-180},{180,180}}), graphics));
    end RecipMachine_Flange;

    model RecipMachine_Fs
      "Model of one cylinder with force and piston position connectors"
      extends
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
      Modelica.Mechanics.Translational.Sources.Force forceJacket annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={106,146})));
      Modelica.Mechanics.Translational.Sensors.RelPositionSensor positionSensor
        annotation (Placement(transformation(
            extent={{15,-15},{-15,15}},
            rotation=90,
            origin={71,121})));
      Modelica.Mechanics.Translational.Sources.Force forcePiston annotation (
          Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=90,
            origin={106,96})));
      output Modelica.Blocks.Interfaces.RealOutput position       annotation (
          Placement(transformation(extent={{100,110},{120,130}}),iconTransformation(
              extent={{100,110},{120,130}})));
      input Modelica.Blocks.Interfaces.RealInput forces
        annotation (Placement(transformation(extent={{-120,100},{-80,140}}),
            iconTransformation(extent={{-120,100},{-80,140}})));
    equation
      connect(positionSensor.flange_b,forcePiston. flange) annotation (Line(
          points={{71,106},{71,81},{106,81},{106,86}},
          color={0,127,0},
          smooth=Smooth.None));
      connect(positionSensor.flange_a,forceJacket. flange) annotation (Line(
          points={{71,136},{71,161},{106,161},{106,156}},
          color={0,127,0},
          smooth=Smooth.None));
      connect(positionSensor.s_rel, position)       annotation (Line(
          points={{87.5,121},{96,121},{96,122},{134,122},{134,120},{110,120}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(forces, forceJacket.f) annotation (Line(
          points={{-100,120},{-100,0},{-164,0},{-164,170},{120,170},{120,130},
              {106,130},{106,134}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(forces, forcePiston.f) annotation (Line(
          points={{-100,120},{-164,120},{-164,170},{120,170},{120,112},{106,
              112},{106,108}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(positionSensor.flange_a, slider.support) annotation (Line(
          points={{71,136},{71,141},{9,141}},
          color={0,127,0},
          smooth=Smooth.None));
      connect(slider.axis, positionSensor.flange_b) annotation (Line(
          points={{9,123},{34,123},{34,104},{71,104},{71,106}},
          color={0,127,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-180,-180},{180,180}},
              preserveAspectRatio=true), graphics), Icon(coordinateSystem(extent={{-180,
                -180},{180,180}},      preserveAspectRatio=true), graphics={Text(
              extent={{-120,78},{-80,42}},
              pattern=LinePattern.None,
              textString="F",
              lineColor={0,0,255},
              textStyle={TextStyle.Italic}), Text(
              extent={{100,80},{140,40}},
              pattern=LinePattern.None,
              textString="s",
              lineColor={0,0,255},
              textStyle={TextStyle.Italic})}));
    end RecipMachine_Fs;

    model RecipMachine_PV
      "Model of single cylinder with pressure and volume connectors"
      extends
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
      ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.VolumeForces
        volumeForces(bore=bore) annotation (Placement(transformation(
            extent={{-15,-15},{15,15}},
            rotation=-90,
            origin={73,135})));
      Modelica.Blocks.Interfaces.RealOutput volume( displayUnit="cm3")
        annotation (Placement(transformation(extent={{100,110},{120,130}}),
            iconTransformation(extent={{100,110},{120,130}})));
      Modelica.Blocks.Interfaces.RealInput pressure
        annotation (Placement(transformation(extent={{-120,100},{-80,140}}),
            iconTransformation(extent={{-120,100},{-80,140}})));
      outer Modelica.Fluid.System system;
      parameter Boolean use_p_crank = false
        "Use non-ambient crankcase pressure?";
      parameter Modelica.SIunits.AbsolutePressure p_crank(min=10,displayUnit="bar") = 101325
        "Custom crankcase pressure, counteracts chamber pressure forces"
      annotation (Evaluate = true,
                    Dialog(enable = use_p_crank));
    protected
    Modelica.SIunits.Volume tmp;
    Modelica.SIunits.AbsolutePressure p_crank_internal;
    equation
      if use_p_crank then
        p_crank_internal = p_crank;
      else
        p_crank_internal = system.p_ambient;
      end if;
      tmp = volumeForces.s_rel * Modelica.Constants.pi * bore^2/4;
      volume = tmp;
      volumeForces.pressure = pressure - p_crank_internal;
      connect(slider.axis, volumeForces.flange_b) annotation (Line(
          points={{9,123},{52,123},{52,108},{74,108},{74,120},{73,120}},
          color={0,127,0},
          smooth=Smooth.None));
      connect(slider.support, volumeForces.flange_a) annotation (Line(
          points={{9,141},{52,141},{52,160},{74,160},{74,150},{73,150}},
          color={0,127,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-180},
                {180,180}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
              extent={{-180,-180},{180,180}}), graphics={Text(
              extent={{-120,80},{-80,40}},
              lineColor={0,0,255},
              textString="p",
              textStyle={TextStyle.Italic}), Text(
              extent={{100,80},{140,40}},
              lineColor={0,0,255},
              textString="V",
              textStyle={TextStyle.Italic}),
            Polygon(
              points={{-52,-32},{-52,150},{72,150},{72,-32},{80,-32},{80,160},
                  {-60,160},{-60,-32},{-52,-32}},
              lineColor={0,0,0},
              fillColor={150,150,150},
              fillPattern=FillPattern.Solid)}));
    end RecipMachine_PV;

    record StrokeBoreGeometry "Geometry defined by stroke and bore"
      extends BaseClasses.SimpleGeometry(
        l_conrod=0.15,
        stroke=0.10,
        bore=0.06,
        V_tdc=40e-6);
    end StrokeBoreGeometry;

    block ValveTimer "Open and close valves according to degree or time input."
      extends Modelica.Blocks.Interfaces.SO;

      parameter Boolean use_angle_in=true "Enable input connector";
      parameter Modelica.SIunits.AngularVelocity rpm=
          Modelica.SIunits.Conversions.from_rpm(60)
        annotation (Evaluate = true,
                    Dialog(enable = not use_angle_in));
      parameter Boolean input_in_rad=false "Input in radians, else degrees"
        annotation (Evaluate = true,
                    Dialog(enable = use_angle_in));

        Modelica.Blocks.Interfaces.RealInput angle_in if use_angle_in
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
              rotation=0), iconTransformation(extent={{-140,-20},{-100,20}})));

                    parameter Modelica.SIunits.Angle open = Modelica.SIunits.Conversions.from_deg(170)
        "Half opened";

        parameter Modelica.SIunits.Angle close = Modelica.SIunits.Conversions.from_deg(190)
        "Half closed";

        parameter Modelica.SIunits.Angle switch = Modelica.SIunits.Conversions.from_deg(5)
        "Length for valve operation.";

    protected
      Real value1;
      Real value2;
      Modelica.SIunits.Angle closeTmp;
      Modelica.SIunits.Angle openTmp;
      Modelica.SIunits.Angle angleTmp;
      Modelica.SIunits.Angle deltaOpen;
      Modelica.SIunits.Angle deltaClose;
      Modelica.Blocks.Interfaces.RealInput angle_in_internal;
    algorithm

      openTmp  := noEvent(mod(open, 2*Modelica.Constants.pi));
      closeTmp := noEvent(mod(close,2*Modelica.Constants.pi));

      if noEvent(input_in_rad) then
        angleTmp := noEvent(mod(angle_in_internal,2*Modelica.Constants.pi));
      else
        angleTmp := noEvent(mod(Modelica.SIunits.Conversions.from_deg(angle_in_internal),2*Modelica.Constants.pi));
      end if;

      deltaOpen := angleTmp-openTmp;

      if noEvent((deltaOpen)<(-Modelica.Constants.pi)) then
        // use last revolution's values
        openTmp := openTmp - 2*Modelica.Constants.pi;
      elseif noEvent((deltaOpen)>(Modelica.Constants.pi)) then
        // use next revolution's values
        openTmp := openTmp + 2*Modelica.Constants.pi;
      end if;

      deltaClose := angleTmp-closeTmp;

      if noEvent((deltaClose)<(-Modelica.Constants.pi)) then
        // use last revolution's values
        closeTmp := closeTmp - 2*Modelica.Constants.pi;
      elseif noEvent((deltaClose)>(Modelica.Constants.pi)) then
        // use next revolution's values
        closeTmp := closeTmp + 2*Modelica.Constants.pi;
      end if;

      value1 := ThermoCycle.Functions.transition_factor(start=openTmp-switch/2,stop=openTmp+switch/2,position=angleTmp);
      value2 := ThermoCycle.Functions.transition_factor(start=closeTmp-switch/2,stop=closeTmp+switch/2,position=angleTmp);

      y := noEvent(max(0,value1-value2));

    equation
      connect(angle_in, angle_in_internal);
      if noEvent(not use_angle_in) then
        angle_in_internal = Modelica.SIunits.Conversions.to_deg(time*rpm);
      end if;

      annotation (Icon(graphics={
            Text(
              extent={{100,60},{-100,100}},
              lineColor={175,175,175},
              textString="valve"),
        Line(points={{-82,60},{-82,-88}}, color={192,192,192}),
        Polygon(
          points={{-82,82},{-90,60},{-74,60},{-82,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-92,-78},{80,-78}}, color={192,192,192}),
        Polygon(
          points={{88,-78},{66,-70},{66,-86},{88,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-83,-78},{-62,-78},{-32,32},{7,32},{37,-78},{59,-78},{88,32}},
                       color={0,0,0})}), Diagram(graphics));
    end ValveTimer;

    model StiffSpeedDependentLoad "High order dependency of load on speed"
      extends Modelica.Mechanics.Rotational.Interfaces.PartialTorque;
      parameter Modelica.SIunits.Power P_nominal(displayUnit="kW") = 1000
        "Nominal load (if positive, load is acting as drive)";
      parameter Boolean LoadDirection=true
        "Same direction of load in both directions of rotation";
      parameter Modelica.SIunits.AngularVelocity w_nominal(displayUnit="rpm",min=Modelica.Constants.eps) = 20
        "Nominal speed";
      parameter Integer order(min=2) = 10 "Order of dependency";
      Modelica.SIunits.AngularVelocity w
        "Angular velocity of flange with respect to support (= der(phi))";
      Modelica.SIunits.Torque tau
        "Accelerating torque acting at flange (= -flange.tau)";
    protected
      Modelica.SIunits.Torque tau_nominal
        "Accelerating torque acting at flange (= -flange.tau)";
    equation
      w = der(phi);
      tau_nominal = P_nominal / w_nominal;
      tau = -flange.tau;
      if LoadDirection then
        tau = tau_nominal*(w/w_nominal)^order;
      else
        tau = tau_nominal*smooth(1,if w >= 0 then (w/w_nominal)^order else -abs((w/w_nominal)^order));
      end if;
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                {100,100}}),
                graphics),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}), graphics={Line(points={{-100,-100},{-80,-98},{-60,-92},
                  {-40,-82},{-20,-68},{0,-50},{20,-28},{40,-2},{60,28},{80,62},
                  {100,100}}, color={0,0,255})}),
        Documentation(info="<HTML>
<p>
Model of torque, quadratic dependent on angular velocity of flange.<br>
Parameter TorqueDirection chooses whether direction of torque is the same in both directions of rotation or not.
</p>
</HTML>"));
    end StiffSpeedDependentLoad;

    block VariableValveTimer
      "Open and close valves according to degree or time input."
      extends Modelica.Blocks.Interfaces.SO;

      parameter Boolean use_angle_in=true "Enable input connector";
      parameter Modelica.SIunits.AngularVelocity rpm=
          Modelica.SIunits.Conversions.from_rpm(60)
        annotation (Evaluate = true,
                    Dialog(enable = not use_angle_in));
      parameter Boolean input_in_rad=false "Input in radians, else degrees"
        annotation (Evaluate = true,
                    Dialog(enable = use_angle_in));

        Modelica.Blocks.Interfaces.RealInput angle_in if use_angle_in
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
              rotation=0), iconTransformation(extent={{-140,-20},{-100,20}})));

                    input Modelica.SIunits.Angle open = Modelica.SIunits.Conversions.from_deg(170)
        "Half opened";

        input Modelica.SIunits.Angle close = Modelica.SIunits.Conversions.from_deg(190)
        "Half closed";

        input Modelica.SIunits.Angle switch = Modelica.SIunits.Conversions.from_deg(5)
        "Length for valve operation.";

    protected
      Real value1;
      Real value2;
      Modelica.SIunits.Angle closeTmp;
      Modelica.SIunits.Angle openTmp;
      Modelica.SIunits.Angle angleTmp;
      Modelica.SIunits.Angle deltaOpen;
      Modelica.SIunits.Angle deltaClose;
      Modelica.Blocks.Interfaces.RealInput angle_in_internal;
    algorithm

      openTmp  := noEvent(mod(open, 2*Modelica.Constants.pi));
      closeTmp := noEvent(mod(close,2*Modelica.Constants.pi));

      if noEvent(input_in_rad) then
        angleTmp := noEvent(mod(angle_in_internal,2*Modelica.Constants.pi));
      else
        angleTmp := noEvent(mod(Modelica.SIunits.Conversions.from_deg(angle_in_internal),2*Modelica.Constants.pi));
      end if;

      deltaOpen := angleTmp-openTmp;

      if noEvent((deltaOpen)<(-Modelica.Constants.pi)) then
        // use last revolution's values
        openTmp := openTmp - 2*Modelica.Constants.pi;
      elseif noEvent((deltaOpen)>(Modelica.Constants.pi)) then
        // use next revolution's values
        openTmp := openTmp + 2*Modelica.Constants.pi;
      end if;

      deltaClose := angleTmp-closeTmp;

      if noEvent((deltaClose)<(-Modelica.Constants.pi)) then
        // use last revolution's values
        closeTmp := closeTmp - 2*Modelica.Constants.pi;
      elseif noEvent((deltaClose)>(Modelica.Constants.pi)) then
        // use next revolution's values
        closeTmp := closeTmp + 2*Modelica.Constants.pi;
      end if;

      value1 := ThermoCycle.Functions.transition_factor(start=openTmp-switch/2,stop=openTmp+switch/2,position=angleTmp);
      value2 := ThermoCycle.Functions.transition_factor(start=closeTmp-switch/2,stop=closeTmp+switch/2,position=angleTmp);

      y := noEvent(max(0,value1-value2));

    equation
      connect(angle_in, angle_in_internal);
      if noEvent(not use_angle_in) then
        angle_in_internal = Modelica.SIunits.Conversions.to_deg(time*rpm);
      end if;

      annotation (Icon(graphics={
            Text(
              extent={{100,60},{-100,100}},
              lineColor={175,175,175},
              textString="valve"),
        Line(points={{-82,60},{-82,-88}}, color={192,192,192}),
        Polygon(
          points={{-82,82},{-90,60},{-74,60},{-82,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-92,-78},{80,-78}}, color={192,192,192}),
        Polygon(
          points={{88,-78},{66,-70},{66,-86},{88,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-83,-78},{-62,-78},{-32,32},{7,32},{37,-78},{59,-78},{88,32}},
                       color={0,0,0})}), Diagram(graphics));
    end VariableValveTimer;

    model RecipMachine
      "A combination of cylinder model and a reciprocating mechanism."

      RecipMachine_Flange recipFlange(redeclare StrokeBoreGeometry geometry)
        annotation (Placement(transformation(extent={{-40,-40},{0,0}})));
      Cylinder cylinder(
        pistonCrossArea=Modelica.Constants.pi*recipFlange.geometry.r_piston^2,
        p_start=system.p_start,
        T_start=system.T_start,
        use_portsData=false,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            HeatTransfer,
        use_angle_in=true,
        stroke=recipFlange.stroke,
        nPorts=2,
        redeclare package Medium = Medium)
        annotation (Placement(transformation(extent={{-30,40},{-10,20}})));

      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
        annotation (Placement(transformation(extent={{20,-20},{40,0}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{-190,80},{-170,100}}),
            iconTransformation(extent={{-190,80},{-170,100}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{170,80},{190,100}}),
            iconTransformation(extent={{170,80},{190,100}})));
    inner outer Modelica.Fluid.System system;
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby
        Modelica.Media.Interfaces.PartialMedium "Working fluid" annotation (choicesAllMatching=true);
    replaceable model HeatTransfer =
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.ConstantHeatTransfer
          (alpha0=30) constrainedby
        ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialCylinderHeatTransfer
        "Wall heat transfer"
        annotation (choicesAllMatching=true);

      Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation (
          Placement(transformation(extent={{-190,-100},{-170,-80}}),
            iconTransformation(extent={{-190,-100},{-170,-80}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation (
          Placement(transformation(extent={{170,-100},{190,-80}}),
            iconTransformation(extent={{170,-100},{190,-80}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
        annotation (Placement(transformation(extent={{-10,170},{10,190}})));
    equation
      connect(cylinder.flange, recipFlange.flange_a)    annotation (Line(
          points={{-20,20},{-20,0}},
          color={0,127,0},
          smooth=Smooth.None));
      connect(recipFlange.crankShaft_a, angleSensor.flange) annotation (Line(
          points={{0,-30},{12,-30},{12,-10},{20,-10}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(angleSensor.phi, cylinder.angle_in) annotation (Line(
          points={{41,-10},{50,-10},{50,30},{-10,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(port_a, cylinder.ports[1]) annotation (Line(
          points={{-180,90},{-22,90},{-22,40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(port_b, cylinder.ports[2]) annotation (Line(
          points={{180,90},{-18,90},{-18,40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(recipFlange.crankShaft_a, flange_b) annotation (Line(
          points={{0,-30},{90,-30},{90,-90},{180,-90}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(recipFlange.crankShaft_b, flange_a) annotation (Line(
          points={{-40,-30},{-110,-30},{-110,-90},{-180,-90}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(flange_a, flange_a) annotation (Line(
          points={{-180,-90},{-177,-90},{-177,-90},{-180,-90}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(cylinder.heatPort, port_a1) annotation (Line(
          points={{-30,30},{-36,30},{-36,180},{0,180}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-180,-180},{180,180}},
              preserveAspectRatio=false),
                          graphics), Icon(coordinateSystem(extent={{-180,-180},{180,
                180}}, preserveAspectRatio=false), graphics={
            Rectangle(
              extent={{-56,99},{60,23}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={192,192,192}),
            Rectangle(
              extent={{-58,91},{62,85}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-58,79},{62,73}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-58,65},{62,59}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{-56,21},{-38,33},{42,33},{60,21},{-56,21}},
              pattern=LinePattern.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}),
            Ellipse(
              extent={{-4,51},{4,43}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Ellipse(extent={{-48,-129},{32,-49}}, lineColor={150,150,150}),
            Line(
              points={{-8,-90},{28,-58},{0,46}},
              color={0,0,0},
              thickness=1),
            Text(
              extent={{-170,-130},{190,-190}},
              textString="%name",
              lineColor={0,0,255}),
            Line(
              points={{-170,-90},{170,-90}},
              color={0,0,0},
              thickness=0.5),
            Line(
              points={{-8,128},{-8,-110}},
              color={0,0,0},
              smooth=Smooth.None,
              pattern=LinePattern.DashDot),
            Line(
              points={{0,128},{0,-110}},
              color={0,0,0},
              smooth=Smooth.None,
              pattern=LinePattern.DashDot),
            Polygon(
              points={{-60,150},{64,150},{64,-12},{72,-12},{72,158},{-68,158},{-68,
                  -12},{-60,-12},{-60,150}},
              lineColor={95,95,95},
              smooth=Smooth.None,
              fillColor={135,135,135},
              fillPattern=FillPattern.Backward),
            Line(
              points={{-170,90},{-160,90},{-160,140},{-60,140}},
              color={0,127,255},
              thickness=0.5,
              smooth=Smooth.None),
            Line(
              points={{170,90},{160,90},{160,140},{64,140}},
              color={0,127,255},
              thickness=0.5,
              smooth=Smooth.None)}));
    end RecipMachine;
    annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Reciprocating Machines</font></h4></p>
<p>A package that provides some basic models for dynamic modelling of reciprocating machines. 
A base class (BaseClasses.PartialRecipMachine) takes care of the internal slider-crank-mechanism and also provides 
an animation thanks to the Modelica.Mechanics.Multibody package. Interaction with other parts of your model is possible via rotational flange connectors (Modelica.Mechanics.Rotational.Interfaces.Flange_xxx) that convey torque and can be connected to other components. Please have a look at the examples to see how to use the connectors.</p>
<p>In order to create your own components from the units in this package, you should redefine geometry and initial conditions. Please note that there are two base classes that can be used for your own geometry, BaseClasses.BaseGeometry and BaseClasses.SimpleGeometry both provide all the necessary inputs. As the name suggests, BaseClasses.SimpleGeometry should be easier to use, but does not provide all the flexibility, e.g. no piston pin offset from crankshaft centre. </p>
<p>This work uses many components from the Modelica standard library and adds only a few things, please be aware that there are many devoted people behind the development of Modelica libraries and their implementations.</p>
<p>Licensed by the Modelica Association under the Modelica License 2</p>
<p>Copyright &copy; 2011-2013 Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark</p>
<p>Main contributor: Jorrit Wronski (jowr@mek.dtu.dk)</p>
</html>"),
         Icon(graphics={Bitmap(
            extent={{-80,60},{60,-80}},
            imageSource=
                "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",
            fileName=
                "modelica://ComponentsExtMedia2/ComponentsExtMedia/pkg_reciprocating.jpg")}));
  end Reciprocating;

  model Compressor "Generic volumetric compressor model"
   /****************************************** FLUID ******************************************/
  replaceable package Medium =
        ThermoCycle.Media.DummyFluid                                                                      constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
   /*Ports */
  public
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_elc
      "Flange of shaft" annotation (Placement(transformation(extent={{64,-8},{
              100,28}}, rotation=0), iconTransformation(extent={{68,-12},{92,12}})));
    Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-78,68},{-58,88}}),
          iconTransformation(extent={{-78,68},{-58,88}})));
    Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
                 Medium)
      annotation (Placement(transformation(extent={{76,-50},{96,-30}}),
          iconTransformation(extent={{76,-50},{96,-30}})));
  /****************************************** SELECT TYPE OF EXPANDER ******************************************/
  parameter Real epsilon_s=0.7 "Isentropic Efficiency"
      annotation (Dialog(enable=(ExpType == ExpTypes.UD)));

    /****************************************** PARAMETERES ******************************************/
    parameter Real epsilon_v=1 "Volumetric efficiency"
      annotation (Dialog(enable=(ExpType == ExpTypes.UD)));
    parameter Modelica.SIunits.Volume V_s=1e-4 "Swept volume";
    parameter Real epsilon_start=0.5782 "Isentropic Efficiency"
      annotation (Dialog(tab="Initialization"));
    parameter Real epsilon_v_start=1 "Volumetric Efficiency"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_su_start=2.339e5
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_ex_start=1.77175e6
      "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_su_start=293.15
      "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
      "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, T_su_start)
      "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
    //parameter Boolean constinit=false
    //  "if true, sets the efficiencies to a constant value at the beginning of the simulation"
   //   annotation (Dialog(group="Intialization options",tab="Initialization"));
   // parameter Modelica.SIunits.Time t_init=10
   //   "if constinit is true, time during which the efficiencies are set to their start values"
  //    annotation (Dialog(group="Intialization options",tab="Initialization", enable=constinit));

    /****************************************** VARIABLES ******************************************/
    Medium.ThermodynamicState vaporIn
      "Thermodynamic state of the fluid at the inlet";
    Medium.ThermodynamicState vaporOut
      "Thermodynamic state of the fluid at the outlet - isentropic";
    Real rpm;
    Modelica.SIunits.Frequency N_rot;
    Modelica.SIunits.Power W_dot;
    Modelica.SIunits.VolumeFlowRate V_dot_su;
    Modelica.SIunits.MassFlowRate M_dot;
    Medium.Density rho_su(start=Medium.density_pT(p_su_start,T_su_start));
    Medium.SpecificEntropy s_su;
    Medium.SpecificEnthalpy h_su(start=h_su_start);
    Medium.SpecificEnthalpy h_ex(start=h_ex_start);
    Medium.AbsolutePressure p_su(start=p_su_start);
    Medium.AbsolutePressure p_ex(start=p_ex_start);
    Medium.SpecificEnthalpy h_ex_s;
  equation
    /* Fluid Properties */
    vaporIn = Medium.setState_ph(p_su,h_su);
    rho_su = Medium.density(vaporIn);
    s_su = Medium.specificEntropy(vaporIn);
    vaporOut = Medium.setState_ps(p_ex,s_su);
    h_ex_s = Medium.specificEnthalpy(vaporOut);
    /*equations */
    rpm = N_rot*60;
    V_dot_su = epsilon_v*V_s*N_rot;
    V_dot_su = M_dot/rho_su;
    h_ex = h_su + (h_ex_s - h_su)/epsilon_s;
    W_dot = M_dot*(h_ex - h_su) "Consumed Power";

     //BOUNDARY CONDITIONS //
     /* Enthalpies */
    h_su = if noEvent(InFlow.m_flow <= 0) then h_ex else inStream(InFlow.h_outflow);
    h_su = InFlow.h_outflow;
    OutFlow.h_outflow = if noEvent(OutFlow.m_flow <= 0) then h_ex else inStream(
      OutFlow.h_outflow);

     /*Mass flows */
     M_dot = InFlow.m_flow;
     OutFlow.m_flow = -M_dot;
     /*pressures */
    //flange.p = vapor_su.p;
    InFlow.p = p_su;
    OutFlow.p = p_ex;
  // Mechanical port:
    der(flange_elc.phi) = 2*N_rot*Modelica.Constants.pi;
    flange_elc.tau = W_dot/(2*N_rot*Modelica.Constants.pi)
    annotation (Diagram(graphics));

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false,extent={{-120,-120},{120,120}}), graphics={
            Text(
            extent={{-62,-56},{80,-84}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,0},
            textString="Compressor"),
                                Polygon(
            points={{-60,80},{-60,-60},{80,-40},{80,40},{-60,80}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
          
         <p><big>The <b>Compressor</b>  model represents the compression of a fluid. It is a lumped model based considering a constant isentropic efficiency. It is characterized by two flow connector for the fluid inlet and outlet 
         and by a mechanical connector for the connection with the electric driver.
        <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> Constant isentropic efficiency
         </ul>
      <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following option is availabe:
        <ul><li>ExpType: it changes the performance curves for isentropic efficiency and filling factor. </ul> 
        </HTML>"));
  end Compressor;

  model Compressor_EN12900 "Compressor model according to standard EN12900"
   /****************************************** FLUID ******************************************/
  replaceable package Medium =
        ThermoCycle.Media.DummyFluid                                                                      constrainedby
      Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
   /*Ports */
    Interfaces.Fluid.FlangeA InFlow(redeclare package Medium =
          Medium)
      annotation (Placement(transformation(extent={{-78,68},{-58,88}}),
          iconTransformation(extent={{-78,68},{-58,88}})));
    Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
                 Medium)
      annotation (Placement(transformation(extent={{76,-50},{96,-30}}),
          iconTransformation(extent={{76,-50},{96,-30}})));

    replaceable function CPmodel =
        ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits
      constrainedby ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits
      "Compressor Model - only valid for one particular working fluid!"
      annotation (choicesAllMatching=true);

  /****************************************** SELECT TYPE OF EXPANDER ******************************************/

    /****************************************** PARAMETERES ******************************************/

    parameter Modelica.SIunits.Frequency N_rot=50 "Compressor frequency";
    parameter Modelica.SIunits.MassFlowRate M_dot_start=0.02
      "Nominal Mass flow rate"
      annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_su_start=2.339e5
      "Inlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Pressure p_ex_start=1.77175e6
      "Outlet pressure start value" annotation (Dialog(tab="Initialization"));
    parameter Modelica.SIunits.Temperature T_su_start=293.15
      "Inlet temperature start value" annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pT(p_su_start, T_su_start)
      "Inlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));
    parameter Medium.SpecificEnthalpy h_ex_start= Medium.specificEnthalpy_pT(p_ex_start, Medium.saturationTemperature(p_ex_start)+50)
      "Outlet enthalpy start value"                                                                                                annotation (Dialog(tab="Initialization"));

    /****************************************** VARIABLES ******************************************/
    Medium.ThermodynamicState vaporIn
      "Thermodynamic state of the fluid at the inlet";
    Medium.ThermodynamicState vaporOut
      "Thermodynamic state of the fluid at the outlet - isentropic";
    Real epsilon_s "Isentropic Efficiency";
    Real epsilon_v "Volumetric efficiency";
    Modelica.SIunits.Volume Vs "Swept Volume";
    Real rpm;
    Modelica.SIunits.Power W_dot;
    Modelica.SIunits.VolumeFlowRate V_dot_su;
    Modelica.SIunits.MassFlowRate M_dot(start=M_dot_start);
    Medium.Density rho_su(start=Medium.density_pT(p_su_start,T_su_start));
    Medium.SpecificEntropy s_su;
    Medium.SpecificEnthalpy h_su(start=h_su_start);
    Medium.SpecificEnthalpy h_ex(start=h_ex_start);
    Medium.AbsolutePressure p_su(start=p_su_start);
    Medium.AbsolutePressure p_ex(start=p_ex_start);
    Medium.SpecificEnthalpy h_ex_s;
    Medium.Temperature T_cd(start=Medium.saturationTemperature(p_ex_start));
    Medium.Temperature T_ev(start=Medium.saturationTemperature(p_su_start));
    Real results[3];
  equation
    /* Fluid Properties */
    vaporIn = Medium.setState_ph(p_su,h_su);
    rho_su = Medium.density(vaporIn);
    s_su = Medium.specificEntropy(vaporIn);
    vaporOut = Medium.setState_ps(p_ex,s_su);
    h_ex_s = Medium.specificEnthalpy(vaporOut);
    T_cd = Medium.saturationTemperature(p_ex);
    T_ev = Medium.saturationTemperature(p_su);
    results=CPmodel(T_cd,T_ev);
    M_dot = results[1];
    W_dot = results[2];
    Vs = results[3];

    /*equations */
    rpm = N_rot*60;
    V_dot_su = epsilon_v*Vs*N_rot;
    V_dot_su = M_dot/rho_su;
    h_ex = h_su + (h_ex_s - h_su)/epsilon_s;
    W_dot = M_dot*(h_ex - h_su) "Consumed Power";

     //BOUNDARY CONDITIONS //
     /* Enthalpies */
    h_su = if noEvent(InFlow.m_flow <= 0) then h_ex else inStream(InFlow.h_outflow);
    h_su = InFlow.h_outflow;
    OutFlow.h_outflow = if noEvent(OutFlow.m_flow <= 0) then h_ex else inStream(
      OutFlow.h_outflow);

     /*Mass flows */
     M_dot = InFlow.m_flow;
     OutFlow.m_flow = -M_dot;
     /*pressures */
    InFlow.p = p_su;
    OutFlow.p = p_ex;

    annotation (Diagram(graphics),
                Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false,extent={{-120,-120},{120,120}}), graphics={
            Text(
            extent={{-62,-56},{80,-84}},
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={0,0,0},
            textString="Compressor"),
                                Polygon(
            points={{-60,80},{-60,-60},{80,-40},{80,40},{-60,80}},
            lineColor={0,0,255},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
          
         <p><big>The <b>Compressor_EN12900</b>  model represents the compression of a fluid in a scroll compressor according to standard EN12900. It is a lumped model.
          It is characterized by two flow connector for the fluid inlet and outlet 
         and by a mechanical connector for the connection with the electric driver.
        <p><big>The assumptions for this model are:
         <ul><li> No dynamics ( it is considered negligible when compared to the one characterizing the heat exchanger).
         <li> No thermal energy losses to the environment
         <li> Mass flow and consumed power are calculated with a polynoms as a function of the saturation temperature of the corresponding inlet and outlet temperature
         </ul>
         <p><b><big>Modelling options</b></p>
         <p><big> In the <b>General</b> tab the following option is availabe:
        <ul><li><p><big> CPmodel: it allows to select one of the different available scroll compressor characteristics.
         </ul>
          </HTML>"));
  end Compressor_EN12900;
end ExpansionAndCompressionMachines;
