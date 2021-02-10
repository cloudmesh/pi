# Cloudmesh Pi

```bash
git clone --recurse-submodules --depth 1 git@github.com:cloudmesh/pi.git
cd pi
npm install
```

## Running the website locally

Once you've cloned or copied the site repo, from the repo root folder, run:

```
hugo server
```

## Running a container locally

You can run docsy-example inside a [Docker](ihttps://docs.docker.com/)
container, the container runs with a volume bound to the `docsy-example`
folder. This approach doesn't require you to install any dependencies other
than Docker and Docker Compose.

> Reference: https://docs.docker.com/compose/gettingstarted/

1. Build the docker image 

```bash
docker-compose build
```

1. Run the built image

```bash
docker-compose up
```

> NOTE: You can run both commands at once as `docker-compose up --build` while you are working.

1. Verify work 

Open your web browser and type `http://localhost:1313` in your navigation bar,
This opens a local instance of the docsy-example homepage. You can now make
changes to the docsy example and those changes will immediately show up in your
browser after you save.

To stop the container, first identify the container ID with:

```bash
CTRL + C to terminate `docker-compose` process
```

That will terminate the container.

1. Remove produced images

You can execute `rm` to remove the produced images

```console
docker-compose rm
```
