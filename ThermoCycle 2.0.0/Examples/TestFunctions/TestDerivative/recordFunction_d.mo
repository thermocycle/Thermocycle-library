within ThermoCycle.Examples.TestFunctions.TestDerivative;
function recordFunction_d
  input R machin;          // The record is considered as a variable, it derivative must be an input of the function, although is is not used
  input Real x;
  input Real y;
  //input R dummymachin;    // Dummy derivative of the record
  input Real der_x;
  input Real der_y;
  output Real der_z;
algorithm
  der_z := machin.field1*2*x*der_x + machin.field2*2*y*der_y + x*der_y + y*der_x;
end recordFunction_d;
