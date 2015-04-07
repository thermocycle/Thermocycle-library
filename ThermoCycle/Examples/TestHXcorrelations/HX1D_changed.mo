within ThermoCycle.Examples.TestHXcorrelations;
model HX1D_changed
  extends HX1D_modified(hx1DInc(redeclare model Medium1HeatTransferModel =
          ThermoCycle.Components.HeatFlow.HeatTransfer.Smoothed,
      N=9,
      V_sf(displayUnit="l") = 0.000195,
      V_wf(displayUnit="l") = 0.000156,
      A_sf=0.184,
      A_wf=0.184,
      Unom_sf=692,
      Unom_l=692,
      Unom_tp=692,
      Unom_v=692,
      M_wall=1.56,
      Mdotnom_sf=0.08691,
      Mdotnom_wf=0.01926),
    sourceMdot1(Mdot_0=0.087),
    sourceMdot(Mdot_0=0.0193));

end HX1D_changed;
