# Palworld Arm64 Dedicated Server

Runs SteamCMD and Palworld with [FEX](https://github.com/FEX-Emu/FEX) (Only tested on Oracle Cloud free tier)

[Docker Hub](https://hub.docker.com/r/nitrog0d/palworld-arm64)

## Getting started

1. Make a docker-compose.yml file in a folder of your choice
2. Create `palworld` sub-directory on the folder and ensure the right permissions are set (see PUID and PGID environment variables).
3. Start via `docker compose up -d` (Starts detached, you can use `docker compose down` to stop it)
4. After first start, stop the server, setup your config at `palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` and start it again
5. The default port for your server is 8211 (UDP)

## Docker Compose
```yml
version: '3.9'
services:
  palworld-server:
    image: 'nitrog0d/palworld-arm64:latest'
    container_name: 'palworld-server'
    ports:
      - '8211:8211/udp'
    environment:
      - PUID=1000
      - PGID=1000
      - ALWAYS_UPDATE_ON_START=true
      - MULTITHREAD_ENABLED=true
      - COMMUNITY_SERVER=false
    restart: 'unless-stopped'
    volumes:
      - './palworld:/palworld'
```

### Environment variables

There are 3 environment variables you can set, everything else is configurable through the PalWorldSettings.ini file.

| Variable               | Description                       | Values      |
|------------------------|-----------------------------------|-------------|
| ALWAYS_UPDATE_ON_START | Always update the server on start | true/false  |
| MULTITHREAD_ENABLED    | Enable multithreading             | true/false  |
| COMMUNITY_SERVER       | Enable community server           | true/false  |

### More information on multithreading and community server (and other settings): https://tech.palworldgame.com/dedicated-server-guide

## Based on
- https://github.com/TeriyakiGod/steamcmd-docker-arm64
- https://github.com/thijsvanloef/palworld-server-docker
- https://github.com/jammsen/docker-palworld-dedicated-server
