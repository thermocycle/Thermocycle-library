within ThermoCycle.Examples.TestFunctions;
model test_der_regsquare
  Real x;
  parameter Real x_small=0.01 "approximation of function for |x| <= x_small";
  parameter Real k1=1 "y = (if x>=0 then k1 else k2)*x*|x|";
  parameter Real k2=1 "y = (if x>=0 then k1 else k2)*x*|x|";
  parameter Boolean use_yd0 = false "= true, if yd0 shall be used";
  parameter Real yd0=1 "Desired derivative at x=0: dy/dx = yd0";
  Real y "ordinate value";
  Real y_bis;
equation
x = -1+time;
y =Modelica.Fluid.Utilities.regSquare2(x,x_small,k1,k2,use_yd0,yd0);
//y_der = ThermoCycle.functions.weightingfactor_der(t_init,length,time,0,0,t_der);
der(y_bis) = der(y);
initial equation
  y_bis = y;
  annotation (
    experiment(StopTime=3),
    __Dymola_experimentSetupOutput);
end test_der_regsquare;
