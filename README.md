## 👋 Welcome to music 🚀  

 play music  
  
  
## Run container

```shell
dockermgr update music
```

### via command line

```shell
docker pull casjaysdevdocker/music:latest && \
docker run -d \
--restart always \
--name casjaysdevdocker-music \
--hostname casjaysdev-music \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/.local/share/docker/storage/music/data:/data \
-v $HOME/.local/share/docker/storage/music/config:/config \
-p 19020:80 \
-p 6600:6600 \
casjaysdevdocker/music:latest
```

### via docker-compose

```yaml
version: "2"
services:
  music:
    image: casjaysdevdocker/music
    container_name: music
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-music
    volumes:
      - $HOME/.local/share/docker/storage/music/data:/data:z
      - $HOME/.local/share/docker/storage/music/config:/config:z
    ports:
      - 80:80
    restart: always
```

## Authors  

🤖 casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/r/casjay) 🤖  
⛵ CasjaysDevdDocker: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
