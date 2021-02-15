---
title: "Motherboard LED"
description: >
  In some cases it it useful to visually display information about the state 
  or programs on your cluster. The LEDs on the board can be used for that.
---


{{% pageinfo %}}

**Learning Objective**

Find out how to use the LEDs on the motherboard.

* Set op Fortan
* Run it on your PI
  
**Topics Covered**

{{< table_of_contents >}}

{{% /pageinfo %}}

## Using Cloudmesh to Control the LEDs

The most convenient way to control the motherboard LEDs is via Cloudmesh. 
It includes a special command that can even be called from a remote Pi using 
ssh once you hve set up the cluster with cloudmesh.

This command switches on and off the LEDs of the specified
PIs. If the hostname is omitted. It is assumed that the
code is executed on a PI and its LED are set. 

The specialty of this program is that it not only can query the current state,
but also allows you to set multiple LEDs on different motherboards at the same 
time with a convenient parameterized syntax.


### Examples

We present a number of examples on how to use this command

```bash
cms pi led list  "red,red[01-03]"
```
> lists the LED status of the given hosts

```bash
cms pi led red off  "red,red[01-03]"
```
> switches off the led of the given PIs

```bash
cms pi led red on  "red,red[01-03]"
```
> switches on the led of the given PIs

```bash
cms pi led red blink  "red,red[01-03]"
```
> switches on and off the led of the given PIs

```bash
cms pi led red sequence  "red,red[01-03]"
```
> goes in sequential order and switches on and off
> the led of the given PIs


### Syntax 

The command syntax is 

```bash
cms pi led reset [NAMES]
cms pi led (red|green) VALUE
cms pi led (red|green) VALUE NAMES [--user=USER]
cmspi led list NAMES [--user=USER]
```




## Using Motherboard LEDs from Shell Scripts

The Raspberry pi contains an LED that can also be used to provide us
with some information as to the status of the PI. It is usually used
for reporting the power status.

The green LED can be made blinking as follows in root

	echo 1 > /sys/class/leds/led0/brightness
	echo 0 > /sys/class/leds/led0/brightness

## Controlling the Motheboard LEDs remotely via ssh

Naturally this ac be done via a remote command if your ssh keys are
uploaded and your originating computer is added to the
authorized_keys. Now you can can control them via ssh

	ssh pi@red03 "echo 1 > led; sudo cp led /sys/class/leds/led0/brightness"
	ssh pi@red03 "echo 0 > led; sudo cp led /sys/class/leds/led0/brightness"

This is extremely useful as it allows us to check if we the OS is
available and we can access the PI.

One strategy is to for example switch the light of, once it is booted,
so we can see which board may be in trouble.
