.. _configure_core_label:

Configure the Core
==================

The Chromite core is highly parameterized and configurable. By changing a single
configuration the user can generate a core instance ranging in size from
embedded micro-controllers to Linux capable high-performance cores.

The configuration should be specified by the user in a YAML file. Sample YAML
files are available in the ``sample_config/`` directory of the Chromite
repository. At times it is possible that the user specifies conflicting
configurations which are illegal and can be detected only at during compile or
simulation time. To detect them early, the configurator maintains a schema of
valid configurations and alerts the user when an illegal configuration is
provided. The source code is compiled only when a legal configuration is
detected.

The output of the configurator is a ``makefile.inc`` file, which contains
necessary variables, to be used in the master Makefile, for bluespec 
compilation, verilator linking, simulation, verification and other collateral
information.

To configure the core using a YAML file use the following command from the
root-folder:

.. code-block:: bash
  
  $ python -m configure.main -ispec myconfig.yaml  
  $ make

The various features of the input YAML spec are described below.

.. include:: schema_doc.rst

