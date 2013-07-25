within ThermoCycle.Examples.TestFunctions.TestDerivative;
function recordFunction
  input R machin;
  input Real x;
  input Real y;
  output Real z;
algorithm
 // the if statement impeeds modelica to find the derivatives by itself and forces the use of the derivative function
     if x < 0.5 then
       z := machin.field1*x^2 + machin.field2*y^2 + x*y;
     else
       z := machin.field1*x^2 + machin.field2*y^2 + x*y;
     end if;
//     z := machin.field1*x^2 + machin.field2*y^2 + x*y;
  annotation (derivative=recordFunction_d);
end recordFunction;
