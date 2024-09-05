
# cncnet-docker-net8-tunnel

A repo that contains a dockerfile to create a cncnet tunnel server in docker using the DOT NET 8 Core technology.

1

Clone the dockerfile from this repo to your server.
You will need to edit your server name here too

2

Build the docker container from the docker file as below (feel free to update my-tunnel-server to a different name for ease of identifying in docker commands):

```sh
docker build -t my-tunnel-server .
```

3

Run your new container with the below:

```sh
docker run -d --name my-tunnel-server \
    -p 50000:50000/tcp \
    -p 50000:50000/udp \
    -p 50001:50001/tcp \
    -p 50001:50001/udp \
    -p 8054:8054/udp \
    -p 3478:3478/udp \
    --cap-add=NET_RAW --cap-add=NET_ADMIN \
    --restart unless-stopped \
    my-tunnel-server
```
