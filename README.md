## 👋 Welcome to navidrome 🚀  

navidrome README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update navidrome
```
  
## Install and run container
  
```shell
dockerHome="/var/lib/srv/$USER/docker/casjaysdevdocker/navidrome/navidrome/latest/rootfs"
mkdir -p "/var/lib/srv/$USER/docker/navidrome/rootfs"
git clone "https://github.com/dockermgr/navidrome" "$HOME/.local/share/CasjaysDev/dockermgr/navidrome"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/navidrome/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-navidrome-latest \
--hostname navidrome \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/navidrome:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/navidrome
    container_name: casjaysdevdocker-navidrome
    environment:
      - TZ=America/New_York
      - HOSTNAME=navidrome
    volumes:
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/navidrome/navidrome/latest/rootfs/data:/data:z"
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/navidrome/navidrome/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/navidrome
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/navidrome" "$HOME/Projects/github/casjaysdevdocker/navidrome"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/navidrome"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
