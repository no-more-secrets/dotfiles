#!/bin/bash

# Run in background if not already running.
run() {
  if ! pgrep -f $1; then
    $@ &
  fi
}

run compton