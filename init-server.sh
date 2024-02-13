#!/bin/bash
# Based on server manager from https://github.com/jammsen/docker-palworld-dedicated-server

# Setting UID and GID based on https://github.com/thijsvanloef/palworld-server-docker/blob/main/scripts/init.sh
if [[ ! "${PUID}" -eq 0 ]] && [[ ! "${PGID}" -eq 0 ]]; then
    printf "\e[0;32m*****EXECUTING USERMOD*****\e[0m\n"
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
else
    printf "\033[31m%s\n" "Running as root is not supported, please fix your PUID and PGID!"
    exit 1
fi

function installServer() {
  FEXBash './steamcmd.sh +force_install_dir "/palworld" +login anonymous +app_update 2394010 validate +quit'
}

function main() {
  # TODO: Add auto backup script
  
  # Check if we have proper read/write permissions to /palworld
  if [ ! -r "/palworld" ] || [ ! -w "/palworld" ]; then
      echo "ERROR: I do not have read/write permissions to /palworld! Please check you've set your PUID and PGID environment variables correctly. If so, please run \"chown -R ${PUID}:${PGID} palworld/\" on the host machine and try again."
      exit 1
  fi

  # Check for SteamCMD updates
  echo 'Checking for SteamCMD updates...'
  FEXBash './steamcmd.sh +quit'

  # Check if the server is installed
  if [ ! -f "/palworld/PalServer.sh" ]; then
      echo 'Server not found! Installing... (Do not panic if it looks stuck)'
      installServer
  fi
  # TODO: Don't run this if it's the first install (It does double checking on files on first install if this is enabled)
  # If auto updates are enabled, try updating
  if [ "$ALWAYS_UPDATE_ON_START" == "true" ]; then
      echo 'Checking for updates... (Do not panic if it looks stuck)'
      installServer
  fi

  # Set up command line args from environment variables
  START_OPTIONS=""
  if [[ -n "$COMMUNITY_SERVER" ]] && [[ "$COMMUNITY_SERVER" == "true" ]]; then
      START_OPTIONS="$START_OPTIONS EpicApp=PalServer"
  fi
  if [[ -n "$MULTITHREAD_ENABLED" ]] && [[ "$MULTITHREAD_ENABLED" == "true" ]]; then
      START_OPTIONS="$START_OPTIONS -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
  fi

  # Fix for steamclient.so not being found
  mkdir -p /home/steam/.steam/sdk64
  cp /home/steam/Steam/linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

  echo 'Starting server... You can safely ignore Steam errors! (Also the server has pretty much 0 logging, so just try connecting to it)'

  # Go to /palworld
  cd /palworld

  # Start server
  FEXBash "./PalServer.sh $START_OPTIONS"
}

main
