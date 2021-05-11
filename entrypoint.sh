#!/bin/bash

TEMPDIR=/temp
PLOTSDIR=/plots
CONFDIR=/config
GENDIR=/root/.config/plotman

if [[ ! -d $TEMPDIR ]]; then
  echo "Temp directory does not exist. Please bind mount a volume with the docker '-v' option to '$TEMPDIR'."
  exit 1
fi
if [[ ! -d $PLOTSDIR ]]; then
  echo "Plots directory does not exist. Please bind mount a volume with the docker '-v' option to '$PLOTSDIR'."
  exit 1
fi
if [[ ! -d $CONFDIR ]]; then
  echo "Config directory does not exist. Please bind mount a volume with the docker '-v' option to '$CONFDIR'."
  exit 1
fi

if [[ ! -f "$CONFDIR/plotman.yaml" ]]; then
  plotman config generate
  cp $GENDIR/plotman.yaml $GENDIR/plotman.yaml.default
  cp $GENDIR/plotman.yaml.default $CONFDIR
  mv $GENDIR/plotman.yaml $CONFDIR
fi
ln -s $CONFDIR/plotman.yaml $GENDIR/plotman.yaml

if [[ ! -d $CONFDIR/logs ]]; then
  makedir $CONFDIR/logs
fi

if cmp $CONFDIR/plotman.yaml.default $CONFDIR/plotman.yaml; then
  echo "Please edit $CONFDIR/plotman.yaml first".
  echo "Call from docker shell: plotman --help"
else
  cd /chia-blockchain
  . ./activate && plotman plot
fi

echo "Call from docker shell: plotman interactive"
