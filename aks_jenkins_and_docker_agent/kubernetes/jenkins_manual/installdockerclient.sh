docker_url=https://download.docker.com/linux/static/stable/x86_64
docker_version=18.03.1-ce
curl -fsSL $docker_url/docker-$docker_version.tgz | \
tar zxvf - --strip 1 -C /usr/bin docker/docker
