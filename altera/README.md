# Altera board framework

## Overview

This framework is for building a Cyclone based design for
the DE0-Nano (and eventually the SoCKit).

The requirements are just a USB-Blaster connection.

## pll50

Generates a PLL with a 50 MHz input and output clock.  The
`locked` signal is used as a negative edge reset for the
rest of the system.

*Built with `qmegawiz`*

## vjtag_mm

Interface between jtag and the Avalon-MM bus.  Using
`system-console` avalon master bus transactions can be
driven into the core over the USB-Blaster which is also
required to program the FPGA.

This provides a pretty generic way of getting data to
and from the board.  It's very slow though.

*Built as a `qsys-edit` subsystem*

## system-console

Altera Nios2EDS application generally used for 
controlling/debugging the Nios2 processor.  Here it
is used via its TCL console to generate avalon transfers.

## signaltap

`signaltap` is like an onchip oscilloscope.  It also uses
JTAG for communications and the example project uses it
to ensure we can have both the vjtag_mm component and
signaltap in the same design.  It currently monitors
the vjtag_mm avalon bus signals.

# Usage

## system-console

Set up the JTAG connection

```
$ system-console --cli
% set jtag [lindex [get_service_paths master] 0]
/devices/EP3C25|EP4CE22@1#3-1/(link)/JTAG/(110:132 v1 #0)/phy_0/master
% open_service master $jtag
```

Perform transactions

```
% master_write_32 $jtag 0 0x1234
% master_read_32 $jtag 0 1      
0x00001234
```

Close JTAG connection

```
% close_service master $jtag
```

## Using signaltap

To work with signaltap you must also program the FPGA device using
signaltap.  Once programmed you can run `system-console` 
and wait on triggers in signaltap as normal.

## Without signaltap

You can use the general Altera FPGA prgramming tool.

