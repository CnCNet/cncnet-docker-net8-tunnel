# Start with the Ubuntu base image
FROM ubuntu:latest

# Install Common Software Properties
RUN apt-get update && \
        apt-get install -y software-properties-common

# Add extra repository for backports
RUN add-apt-repository ppa:dotnet/backports -y

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y wget tar unzip dotnet-sdk-8.0 aspnetcore-runtime-8.0 dotnet-runtime-8.0 libssl-dev && \
    rm -rf /var/lib/apt/lists/*


## No longer needed with move to dotnet8 tunnel
## Fix "No usable version of libssl was found" .NET Core error
## .NET Core 3.1 only works with OpenSSL 1.x, but Ubuntu 22.04 LTS comes with much newer OpenSSL 3.0
## RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
## dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb

# Set the working directory
WORKDIR /app

# Download and extract the zip file to /app
RUN wget -O cncnet-server.zip https://github.com/Rans4ckeR/cncnet-server/releases/download/v4.0.18/cncnet-server-v4.0.18-net8.0-V2+V3-linux-x64.zip && \
    unzip cncnet-server.zip -d /app && \
    rm cncnet-server.zip

# Change permissions to make cncnet-server executable
RUN chmod +x /app/cncnet-server


## No longer needed with move to dotnet8 tunnel
## Set environment variable to disable globalization support
## ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

# Expose the required ports
EXPOSE 50000/tcp 50000/udp 50001/tcp 50001/udp 8054/udp 3478/udp

# Start the tunnel server and write logs to the volume
CMD ./cncnet-server --name "My CnCNet tunnel" --2 --3 --m 200 --p 50001 --p2 50000 > /logs/cncnet-server.log 2>&1 && tail -f /logs/cncnet-server.log
