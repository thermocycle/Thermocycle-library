within ThermoCycle.Examples.TestFunctions.TestDerivative;
function nonderivable
  input Real x;
  output Real y;
algorithm
 // the if statement impeeds modelica to find the derivatives by itself
     if x < 0.5 then
       y:=x;
     else
       y:=x;
     end if;
end nonderivable;
