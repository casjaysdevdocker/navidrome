## 👋 Welcome to navidrome 🚀  

navidrome  
  
  
## Run container

```shell
dockermgr update navidrome
```

### via command line

```shell
docker pull casjaysdevdocker/navidrome:latest && \
docker run -d \
--restart always \
--name casjaysdevdocker-navidrome \
--hostname casjaysdev-navidrome \
-e TZ=${TIMEZONE:-America/New_York} \
-v $HOME/Music:/data/music \
-v $HOME/.local/share/docker/storage/navidrome/data:/data:z \
-v $HOME/.local/share/docker/storage/navidrome/config:/config:z \
-p 19020:80 \
-p 6600:6600 \
casjaysdevdocker/navidrome:latest
```

### via docker-compose

```yaml
version: "2"
services:
  navidrome:
    image: casjaysdevdocker/navidrome
    container_name: navidrome
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-navidrome
    volumes:
      - $HOME/Music:/data/music:z
      - $HOME/.local/share/docker/storage/navidrome/data:/data:z
      - $HOME/.local/share/docker/storage/navidrome/config:/config:z
    ports:
      - 19020:80
      - 6600:6600
    restart: always
```

## Authors  

🤖 casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/r/casjay) 🤖  
⛵ CasjaysDevdDocker: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/r/casjaysdevdocker) ⛵  
