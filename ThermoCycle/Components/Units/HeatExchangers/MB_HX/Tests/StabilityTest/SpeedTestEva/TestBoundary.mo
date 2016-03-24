within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Tests.StabilityTest.SpeedTestEva;
model TestBoundary
  parameter Real Amplitude=1.1e5;
  parameter Real Amplitude_h = 0.2E5;
  parameter Real frequency_p = 0.1;
  parameter Real frequency_h = 0.2;
  BoundaryEva boundaryEva( sine(amplitude=Amplitude, freqHz = frequency_p), sine1(amplitude=
          Amplitude_h, freqHz = frequency_h))
    annotation (Placement(transformation(extent={{-12,24},{8,44}})));
end TestBoundary;
