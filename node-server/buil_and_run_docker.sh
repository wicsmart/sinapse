


docker build -t node-server-image/node-web-app .

docker run -p 19268:8080 -p 8000:8000 --name node-server --network=sinapase_sinapse -d node-server-image/node-web-app