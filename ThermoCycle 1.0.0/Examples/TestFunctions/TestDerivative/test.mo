within ThermoCycle.Examples.TestFunctions.TestDerivative;
model test
R machin;
Real x;
Real y;
Real z;
Real z_bis;
equation
machin.field1 = nonderivable(3);
machin.field2 = 5;
x = time^2;
y = 3;
z = recordFunction(machin,x,y);
der(z_bis) = der(z);
initial equation
  z_bis = z;
end test;
