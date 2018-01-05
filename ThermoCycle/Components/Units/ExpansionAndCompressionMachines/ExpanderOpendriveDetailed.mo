within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
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
  parameter Modelica.SIunits.MassFlowRate M_dot_n=0.1 "Nominal mass flow rate";
  parameter Modelica.SIunits.ThermalConductance AU_su_n=30
    "Supply heat transfer coefficient";
  parameter Modelica.SIunits.ThermalConductance AU_ex_n=30
    "Exhaust heat transfer coefficient";
  parameter Modelica.SIunits.ThermalConductance AU_amb=3.4
    "Ambient heat transfer coefficient";
  parameter Modelica.SIunits.Area A_leak=2.6e-6 "Leakage area";
  parameter Modelica.SIunits.Power W_dot_loss0=0 "Constant mechanical losses";
  parameter Real alpha=0.1 "Proportionality factor of the mechanical losses";
  parameter Modelica.SIunits.Temperature T_amb=25+273.15 "Ambient temperature";
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
  parameter Real epsilon_ex_start=0.29 "Start value for the exhaust efficiency"
                                                annotation(dialog(tab="Start Values"));
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
