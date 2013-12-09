within ThermoCycle.Functions;
package TestRig
extends Modelica.Icons.Package;
extends Icons.Functions;
  function GenericScrewExpander_IsentropicEfficiency
    input Real rp;
    input Real rpm;
    input Real p;
    output Real y;
  protected
  Real a0 = 0;
  Real a1 = 0.8411;
  Real a2 = 0.8345;
  Real a3 = 3;
  Real a4 = 3;
  Real a5 = 0.02383;
  Real a6 = 0.4827;
  Real dydx_0 = 0.7924;
  Real rpm_m = 3547;
  Real shape_0 = 1.213;
  Real x_0_0 = 3.079;
  Real x_m_0 = 10;
  Real y_m_0 = 0.592;
    Real rpm_star;
    Real rpm_star_m;
    Real p_star;
    Real r_star_p;
    Real x_0;
    Real dydx;
    Real shape;
    Real x_m;
    Real y_max;
    Real x;
    Real A;
    Real C;
    Real D;
    Real B;
    Real E;
  algorithm
  rpm_star :=(rpm - 3000)/3000;
  rpm_star_m :=(rpm_m - 3000)/3000;
  p_star :=(p/1e5 - 10)/10;
  r_star_p :=(rp - 4)/4;
  x_0 :=x_0_0 + a0*rpm_star;
  dydx :=dydx_0 + a1*p_star - a2*rpm_star;
  shape :=shape_0;
  x_m :=x_m_0 - a3*p_star + a4*rpm_star;
  y_max :=y_m_0 + a5*p_star - a6*(rpm_star - rpm_star_m)^2;
  x :=rp;
  A :=x_0;
  C :=shape;
  D :=y_max;
  B :=dydx/(C*D);
  E :=(B*(x_m - x_0) - tan(Modelica.Constants.pi/(2*C)))/(B*(x_m - x_0) - atan(B*(
      x_m - x_0)));
  y := D*sin(C*atan(B*(x - A) - E*(B*(x - A) - atan(B*(x - A)))));
    annotation (smoothOrder = 1);
  end GenericScrewExpander_IsentropicEfficiency;

  function GenericScrewExpander_FillingFactor
  input Real p_su_exp;
  input Real rho_su_exp;
  input Real rpm;
  output Real FFVs;
  protected
  Real p_ref = 10;
  Real rpm_ref = 3000;
  Real p_star;
  Real rpm_star;
  Real m_dot_pred;
  algorithm
  rpm_star :=(rpm - rpm_ref)/rpm_ref;
  p_star :=(p_su_exp/1e5 - p_ref)/p_ref;
  m_dot_pred :=4.12755649E-01 + 5.53460859E-01*p_star + 2.02259908E-01*p_star^2 +
      1.77533206E-01*rpm_star - 9.68383257E-02*rpm_star^2 + 1.65849332E-01*p_star*
      rpm_star;

  FFVs :=m_dot_pred/(rpm/60*rho_su_exp);

  end GenericScrewExpander_FillingFactor;

  function GenericCentrifugalPump_IsentropicEfficiency
    input Real f_pp;
    input Real r_p;
    output Real epsilon_s;
  algorithm
    epsilon_s := -6.53917026E-02+7.59307458E-03*f_pp+1.26794211E-04*r_p;
    epsilon_s := min(0.8, epsilon_s);
    epsilon_s := max(0, epsilon_s);
    annotation (smoothOrder=1);
  end GenericCentrifugalPump_IsentropicEfficiency;

  function GenericCentrifugalPump_MassFlowRate
    input Real f_pp;
    output Real Mdot;
  algorithm
    Mdot := -2.95825023E-01+1.79289093E-02*f_pp;
    annotation (smoothOrder=1);
  end GenericCentrifugalPump_MassFlowRate;

  function PressureDropCorrelation_LP
    input Real M_flow;
    output Real DELTAp;
  protected
    Real k1 = 38453.9;
    Real k2 = 23282.7;
  algorithm
    DELTAp :=k1*M_flow + k2*M_flow^2;
    annotation (smoothOrder=1);
  end PressureDropCorrelation_LP;

  function PressureDropCorrelation_HP
    input Real M_flow;
    output Real DELTAp;
  protected
    Real k1 = 11857.8;
    Real k2 = 77609.9;
  algorithm
    DELTAp :=k1*M_flow + k2*M_flow^2;
    annotation (smoothOrder=1);
  end PressureDropCorrelation_HP;
end TestRig;
