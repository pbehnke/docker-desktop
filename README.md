## Vizier Desktop

- [Vizier Website](https://vizierdb.info)
- [Install Instructions](https://github.com/VizierDB/web-ui/wiki/Desktop-Install)

#### Using this repo

Install [docker-compose](https://docs.docker.com/compose/) first.  Then run:
```
git clone https://github.com/VizierDB/docker-desktop.git
cd docker-desktop
docker-compose build
docker-compose up
```

Per default `2GB` of memory are allocated to the Vizier container. If you want to use more memory, then change the setting in the `docker-compose.yml` file.

#### Cleanup
```
docker-compose down
```
