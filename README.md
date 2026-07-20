```bash
docker build -t xrdp2204 .

docker run -d -p 3389:3389 -v xrdp-root-home:/root --name xrdp_root xrdp2204



