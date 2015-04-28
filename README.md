# MicroProcesso

* sources/cores : reusable components
* sources/counter : component example 
* sources/counter/rtl : vhd files
* sources/counter/synthesis : config requirement for fpga
* sources/counter/rules.mk : rules makefile for the component
* xilinx.sh : config xilinx env
* tail.sh : show debug output

## 1. Configuration
You need to edit the `xilinx.sh` file to set up your environment
* `XILINX_BASE=/path/to/xilinx`
* `XILINX_VERSION=`
* `source ${XILINX_BASE}/${XILINX_VERSION}/ISE_DS/settings32.sh` choice between settings32.sh and settings64.sh 

**Note** that you need to run `source xilinx.sh` before making your project

In the rules.mk file, in the counter component, you should specify your fpga board

```
# Board specific definitions
PKG_$(d)                                        := xc6slx16-3-csg324
```

## 2. Compilation
To compile the project run `make`. To print log debug run in another shell `./tail.sh counter/system`.
When the compilation ends, a rapport is generated in `binary/counter/system.ngd.out`

### 2.1 Simulation  
To run ISim and launch the simulation you should run `make binary/counter/system_beh.isim` and `make binary/counter/system_beh.runisim`.
You can re-build (re-launch on the ISim IHM) directly.

**Note**: in `sources/counter/rules.mk`
Top module is corresponding to entity name, here is `system` for the component and `test_bench` for the test component.
So if you want run test : `make binary/counter/test_bench_beh.isim`




