within ThermoCycle.Functions;
function RLMTD
  "Computes LMTD without numerical issue in case of negative pinch"
  input Real DELTAT1;
  input Real DELTAT2;
  output Real LMTD;
  constant Real xi=10
    "Proportionality factor: sets the speed with which LMTD decreases below epsilon";
  constant Real epsilon = 1
    "Minimum pinch below which a linear model is used instead of the log";
algorithm

  if DELTAT1 > epsilon then
    if DELTAT2 > epsilon then
      if DELTAT1 <> DELTAT2 then
        LMTD := (DELTAT1 - DELTAT2)/(log(DELTAT1) - log(DELTAT2));
      else
        LMTD := (DELTAT1 + DELTAT2)/2;
      end if;
    else
      LMTD := (DELTAT1 - epsilon)/(log(DELTAT1/epsilon)*(1 - xi*(DELTAT2 - epsilon)));
    end if;
  else
    if DELTAT2 > epsilon then
      LMTD := (DELTAT2 - epsilon)/(log(DELTAT2/epsilon)*(1 - xi*(DELTAT1 - epsilon)));
    else
      LMTD := epsilon/((1 - xi*(DELTAT1 - epsilon))*(1 - xi*(DELTAT2 - epsilon)));
    end if;
  end if;

  annotation (smoothOrder=1);
end RLMTD;
