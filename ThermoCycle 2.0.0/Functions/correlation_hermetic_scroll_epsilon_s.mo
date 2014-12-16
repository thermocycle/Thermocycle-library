within ThermoCycle.Functions;
function correlation_hermetic_scroll_epsilon_s
  input Real rho;
  input Real rp;
  output Real epsilon_s;
algorithm
  epsilon_s := -6.64245265E+01 + 4.76955293E+01*log(rho) - 1.35858904E+01*
    log(rho)^2 + 1.77003970E+00*log(rho)^3 - 1.02953583E-01*log(rho)^4 +
    2.39566357E-03*log(rho)^5 + 1.13504981E+02*log(rp) - 8.33543737E+01*log(
    rp)^2 + 2.88988540E+01*log(rp)^3 - 4.38850733E+00*log(rp)^4 +
    1.91516689E-01*log(rp)^5 - 7.18843549E+01*log(rho)*log(rp) +
    4.65090842E+01*log(rho)*log(rp)^2 - 1.32188184E+01*log(rho)*log(rp)^3
     + 1.35479342E+00*log(rho)*log(rp)^4 + 1.74244753E+01*log(rho)^2*log(rp)
     - 9.46485860E+00*log(rho)^2*log(rp)^2 + 1.96681732E+00*log(rho)^2*log(
    rp)^3 - 9.18290140E-02*log(rho)^2*log(rp)^4 - 1.59497299E+00*log(rho)^3
    *log(rp) + 4.72814319E-01*log(rho)^3*log(rp)^2 + 8.68612468E-02*log(rho)
    ^3*log(rp)^3 - 4.23519754E-02*log(rho)^3*log(rp)^4 + 3.27301261E-02*log(
    rho)^4*log(rp) + 2.62330241E-02*log(rho)^4*log(rp)^2 - 2.60988688E-02*
    log(rho)^4*log(rp)^3 + 5.48900609E-03*log(rho)^4*log(rp)^4;
  epsilon_s := min(0.65, epsilon_s);
  epsilon_s := max(0, epsilon_s);
  annotation (smoothOrder=1);
end correlation_hermetic_scroll_epsilon_s;
