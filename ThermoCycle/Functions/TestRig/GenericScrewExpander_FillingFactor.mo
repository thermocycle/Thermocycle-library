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
m_dot_pred :=4.12755649E-01 + 5.53460859E-01*p_star + 2.02259908E-01*p_star^2 +
    1.77533206E-01*rpm_star - 9.68383257E-02*rpm_star^2 + 1.65849332E-01*p_star*
    rpm_star;

FFVs :=m_dot_pred/(rpm/60*rho_su_exp);

end GenericScrewExpander_FillingFactor;
