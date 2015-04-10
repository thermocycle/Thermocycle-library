within ThermoCycle.Components.HeatFlow.HeatTransfer.SinglePhaseCorrelations;
partial model MuleyManglik
  "Heat transfer in plate heat exchangers, Muley and Manglik 1999"
  extends
    ThermoCycle.Components.HeatFlow.HeatTransfer.BaseClasses.PartialSinglePhasePHECorrelation;

//   A special correlation for single phase heat transfer in
// \glspl{phe} has been provided by \citet{Muley1999}.
// Looking at plate angles $\SI{30}{\degree} \leq \gls{phi} \leq \SI{60}{\degree}$,
// they define a polynomial-based correlation for \gls{nusselt}
// \begin{align}
// \gls{nusselt}
//       = & \left( \num{2.668e-1} - \num{6.967e-3}\phi + \num{7.244e-5}\phi^2 \right) \\
//   \cdot & \left( \num{2.078e+1} - \num{5.094e+1}\Phi + \num{4.116e+1}\Phi^2 - \num{1.015e+1}\Phi^3 \right) \\
//   \cdot & \Rey^{\left( 0.728+0.0543\sin\left( \gls{pi} \gls{phi}/\SI{45}{\degree} + 3.7 \right) \right)}
//      \ma \Pra^{1/3} \ma \left( \frac{\gls{mu}}{\glssub[mu]{sub:w}} \right)^{0.14}
//   \text{. } \label{eqn:hxMuleyTur}
// \end{align}
// \cref{eqn:hxMuleyTur} is valid for $\gls{reynolds} \geq 1000$
// and for enlargement factors~\gls{Phi} between \numlist{1;1.5}, which is expected to
// cover all possible plate heat exchanger configurations~\cite{Muley1999}.
// For lower \gls{reynolds} in the range from \numrange{30}{400}, \citet{Palm2006}
// recommend to use
// \begin{equation}
// \gls{nusselt} = 0.44\left(\frac{\phi}{\SI{30}{\degree}}\right)^{0.38}
//                \ma \gls{reynolds}^{1/2}
//                \ma \gls{prandtl}^{1/3}
//                \ma \left( \frac{\gls{mu}}{\glssub[mu]{sub:w}} \right)^{0.14}
//                \text{, } \label{eqn:hxMuleyLam}
// \end{equation}
// which also originates from \citet{Muley1999}. Both equations assume that
// \gls{phi} is given in degrees and not in radians. The final implementation
// used in this work employs the transition function from \cref{eqn:Richter2008}
// to combine the calculated \glspl{nusselt} for laminar and turbulent flow
// in the transition interval $\num{400}<\gls{reynolds}<\num{1000}$.

  annotation (Documentation(info="<html>
<dl><dt>article <a name=\"Muley1999\">(</a>Muley1999)</dt>
<dd>Muley, A. and Manglik, R. M.</dd>
<dd><i>Experimental Study of Turbulent Flow Heat Transfer and Pressure Drop in a Plate Heat Exchanger With Chevron Plates</i></dd>
<dd>Journal of Heat Transfer, <b>1999</b>, Vol. 121(1), pp. 110-117 </dd>
</dl></html>"));
end MuleyManglik;
