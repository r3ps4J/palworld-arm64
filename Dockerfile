# Use original image as base
FROM nitrog0d/palworld-arm64:latest

# Copy init-server.sh to container
COPY --chmod=755 ./init-server.sh /home/steam/init-server.sh

# Set up some default environment variables
ENV PUID=1000 \
    PGID=1000
