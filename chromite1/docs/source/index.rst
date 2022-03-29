.. _home:

Chromite Core Documentation
###########################

Welcome to Chromite Core Generators documentation version: |version|

For information about the changes and additions for releases, 
please refer to the :ref:`Revisions <revisions>` documentation.

.. raw:: html

   <ul class="grid">
       <li class="grid-item">
	   <a href="overview.html">
          <span class="grid-icon fa fa-info" aria-hidden="true"></span>
	       <h2>Overview</h2>
	   </a>
	   <p>Introducing the Chromite Core Generator: overview, features, and licensing</p>
       </li>
       <li class="grid-item">
	   <a href="getting_started.html">
               <span class="grid-icon fa fa-angle-double-right" aria-hidden="true"></span>
	       <h2>Getting Started Guide</h2>
	   </a>
	   <p>Follow the guide to configure, build and simulate your first Chromite Core</p>
       </li>
       <li class="grid-item">
	   <a href="chromite.html">
               <span class="grid-icon fa fa-puzzle-piece"></span>
	       <h2>Core Microarchitecture</h2>
	   </a>
	   <p>Read about the various micro-architectural features of the Chromite Cores</p>
       </li>
       <li class="grid-item">
	   <a href="benchmarking.html">
               <span class="grid-icon fa fa-line-chart"></span>
	       <h2>Benchmarking</h2>
	   </a>
	   <p>Checkout the various benchmark scores of the Chromite Core</p>
       </li>
       <li class="grid-item">
	   <a href="configure.html">
               <span class="grid-icon fa fa-cogs"></span>
	       <h2>Configure your Core</h2>
	   </a>
	   <p>Learn about the various configuration knobs available for creating your custom Core</p>
       </li>
       <li class="grid-item">
	   <a href="https://gitlab.com/incoresemi/core-generators/chromite">
               <span class="grid-icon fa fa-gitlab"></span>
	       <h2>Code Access</h2>
	   </a>
	   <p>The entire Chromite Core is open and available on GitLab</p>
       </li>
   </ul>

.. include:: <isonum.txt>

.. only:: latex

  .. note::
    
    This document provides detailed information of the IPs generated and maintained by InCore
    Semiconductors Pvt. Ltd. 
    
    **Proprietary Notice**
    
    Copyright (c) 2020, InCore Semiconductors Pvt. Ltd. 
    
    Information in this document is provided "as is" with faults, if any.
    
    InCore expressly disclaims all warranties, representations, and conditions of any kind, whether
    express or implied, including, but not limited to, the implied warranties or conditions of 
    merchantability, fitness for a particular purpose and non-infringement.
    
    InCore does not assume any liability rising out of the application or use of any product or circuit,
    and specifically disclaims any and all liability, including without limitation indirect, incidental, 
    special, exemplary, or consequential damages.
    
    InCore reserves the right to make changes without further notice to any products herein.

.. only:: html

   Sections
   ********

.. toctree::
  :glob:
  :maxdepth: 1
  :numbered:

  overview
  getting_started
  configure
  benchmarking
  chromite
  modes
  custom_csrs
  pmp
  monitors
  cache
  mmu
  interrupts
  debug
  triggers
  revisions
  licensing
