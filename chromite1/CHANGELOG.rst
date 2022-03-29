CHANGELOG
=========

This project adheres to `Semantic Versioning <https://semver.org/spec/v2.0.0.html>`_.

[0.9.10] - 2021-09-01
  - wrapping all instances of wr_ext_seip under \`ifdef supervisor
  - bump versions of devices and cache_subsytem
  - filename to load in bram must of type LoadFormat from mem_config

[0.9.9] - 2021-08-27
  - add logs for gshare_branchpredictor and decompressor.

[0.9.8] - 2021-03-30
  - fix external seip behavior

[0.9.7] - 2021-03-25
  - verilator command to use absolute paths instead of relative
  - fix in decoder for illegal frm values
  - condition for choosing nextpc and delayed_redirect in stage0 fixed
  - ignore dumping trap instruction in tracedump

[0.9.6] - 2020-07-03
  - minor doc updates
  - fixed errors in license terms in readthedocs version.

[0.9.5] - 2020-06-18
  - fixed sample configs and added a chromite equivalent config as well.
  - removed obsolete remnants of MTIME and MTIMEH from csrs.
  - adding a docker based ci target on shared runners for running benchmarks

[0.9.4] - 2020-06-17
  - updated UART to latest DCBus
  - bumped devices and common_bsv versions
  - mie is disabled for all configs on reset.
  - removed chromitem.yaml from samples
  - re-arranged docs sections
  - updated block diagram for core-pipeline.

[0.9.3] - 2020-06-04
  - updated docs for correct tabs redering in getting_started guide
  - adding links to different versions of docs
  - using changelog as revisions in docs
  - changed changelog format

[0.9.2] - 2020-06-04
  - removed the concept of extra history bits from gshare_fa.
  - added history_bits as a new parameter to indicate the size of bits used from the ghr for indexing.
  - reduced tick resolution in test_soc.
  - updated the 2 bit counter increment scheme to account for hysterisis bit separately.
  - updated the gshare has function for improved collisions.
  - updated repomanager to 1.2.0.
  - merged usermanual and datahseet into a single doc.
  - added chromite specific device-tree-string.
  - documentation of the pipeline added.
  - made the size of the test-soc BRAM memory configurable through YAML.
  - the core now re-aligns data and write-strobes on the AXI4 write channel for io requests.
  - renamed the everilated binary from "out" to "chromite_core"
  - added a local boot-code and respective build files
  - added missing 'ifdef pmp' in ccore.bsv
  - minor style fixes in TbSoc
  - updated ci for docs build at pre-merge
 


[0.9.1] - 2020-05-01
  - parallel build using bluetcl is enabled
  - remove re-alignment of bytes in ccore for I$ and D$ reads. This now is handled within the caches
  - bumped version of the caches
  - gitignore updated
  - fixed and cleaned up the interrupt and delegation logic
  - adding pre-requisite checks in configure
  - default.yaml is picked up as default if no argument given to -ispec
  - split interface of seip and meip. Both can now be driven by plic independently. Also led to removal of unwanted attributes.
  - snapshot the c-class with changes in mostly the top-level modules and scripts to accommodate for
    incore developed IPs and fabrics.
  - fixed reset logic handling in ccore.bsv to support reset by debugger.
  - updated SoC to decouple debug related logic into a separate module. This now allows for easy reset
    control.
  - datasheet of chromite added
  - added chromiteM profile same yaml file
  - updated usage docs with chromite and removed non-supported items.
  - the debug module in the test-soc is now always enabled irrespective of the debug being enabled or
    not
  - adding steps in the docs on how to reset the debugger
  - updated Soc.defines to relocate debug loop at 0x100
  - updated dtvec_base in both all the sample yamls
  - dtvec_base should be stored without the LSB (alignment constraints)

