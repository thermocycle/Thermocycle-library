.. ThermoCycle documentation master file, created by
   sphinx-quickstart on Wed Sep 12 16:12:26 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

About ThermoCycle
=================

The ThermoCycle library is an open-source library for dynamic modelling of thermal
systems developed in the Modelica language. The library aims at providing a robust framework to model thermal systems, including thermodynamic cycles. A number of libraries are available to model steam or gas cycles (e.g. ThermoSysPro, Power Plants, etc.), but few are able to handle the non-conventional working fluids (refrigerants, ammonia, siloxanes, etc.) used in some thermal systems such as heat pumps, Organic Rankine Cycles, absorption chillers, etc.

Thermodynamic properties of organic fluids require complex equations of state available only in external libraries such as FluidProp, Refprop or CoolProp. Thermodynamic properties in the ThermoCycle library are computed using the open-source library CoolProp. From version 2.0 onwards, the interface between ThermoCycle and CoolProp is ensured by the ExternalMedia library (formerly ensured by the Coolprop2Modelica library).

The ThermoCycle package is free software licensed under the Modelica License 2. It can be redistributed and/or modified under the terms of this license.

.. toctree::
   :maxdepth: 1

   howtos
   numerical
   components


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
