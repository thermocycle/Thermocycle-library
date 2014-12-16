within ThermoCycle.Functions;
function correlation_hermetic_scroll_FF
  input Real rho;
  input Real rp;
  output Real FF;
algorithm
  FF := 7.57680390E-01 + 1.03377082E-01*log(rho) - 9.44421504E-03*log(rho)^
    2 - 9.77306474E-04*log(rho)^3 + 1.21317764E-01*log(rp) - 3.37184749E-02
    *log(rp)^2 + 2.66140555E-03*log(rp)^3 - 4.37896534E-02*log(rho)*log(rp)
     + 9.10515577E-03*log(rho)*log(rp)^2 + 6.54874695E-03*log(rho)^2*log(rp)
     - 1.34144803E-03*log(rho)^2*log(rp)^2;
  FF := min(1.2, FF);
  FF := max(1, FF);
  annotation (smoothOrder=1);
end correlation_hermetic_scroll_FF;
