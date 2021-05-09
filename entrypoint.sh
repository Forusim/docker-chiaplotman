#!/bin/bash

TEMPDIR=/temp
PLOTSDIR=/plots
CONFDIR=/config
GENDIR=/root/.config/plotman
AUTOSTART="no"

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

cd /chia-blockchain
. ./activate
#chia init

if [[ ${AUTOSTART} == 'yes' ]]; then
  if cmp $CONFDIR/plotman.yaml.default $CONFDIR/plotman.yaml; then
    echo "Please edit $CONFDIR/plotman.yaml first".
    echo "Call from docker shell: plotman --help"
  else
    plotman plot
  fi
else
  echo "Call from docker shell: plotman plot"
fi

echo "Call from docker shell: plotman interactive"

while true; do sleep 30; done;
