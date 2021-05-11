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

mv $GENDIR/plotman.yaml $GENDIR/plotman.yaml.default
cp $GENDIR/plotman.yaml.default $CONFDIR

if [[ ! -f "$CONFDIR/plotman.yaml" ]]; then
  cp $GENDIR/plotman.yaml.default $CONFDIR/plotman.yaml
fi
ln -s $CONFDIR/plotman.yaml $GENDIR/plotman.yaml

if [[ ! -d $CONFDIR/logs ]]; then
  mkdir $CONFDIR/logs
fi

if cmp $CONFDIR/plotman.yaml.default $CONFDIR/plotman.yaml; then
  echo "Please edit $CONFDIR/plotman.yaml first".
  echo "Call from docker shell: . ./activate && plotman --help"
else
  echo "Call from docker shell: . ./activate && plotman interactive"
  . ./activate && plotman plot
fi
