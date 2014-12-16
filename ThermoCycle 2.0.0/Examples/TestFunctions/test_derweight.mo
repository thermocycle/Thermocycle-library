within ThermoCycle.Examples.TestFunctions;
model test_derweight
Real t_init;
Real length;
Real t_der;
Real y;
Real y_bis;
Real y_der;
equation
t_der = 1;
t_init = 1;
length = 1;
  y = ThermoCycle.Functions.weightingfactor(
        t_init,
        length,
        time);
  y_der = ThermoCycle.Functions.weightingfactor_der(
        t_init,
        length,
        time,
        0,
        0,
        t_der);
der(y_bis) = der(y);
initial equation
  y_bis = y;
  annotation (
    experiment(StopTime=3),
    __Dymola_experimentSetupOutput);
end test_derweight;
