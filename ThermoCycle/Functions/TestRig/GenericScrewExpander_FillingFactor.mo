within ThermoCycle.Functions.TestRig;
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
m_dot_pred :=4.00774818E-01+5.33125918E-01*p_star+1.49433502E-01*p_star^2-2.76390528E-01*rpm_star-1.44346740E+00*rpm_star^2+2.42971080E-01*p_star*rpm_star;

FFVs :=m_dot_pred/(rpm/60*rho_su_exp);

end GenericScrewExpander_FillingFactor;
