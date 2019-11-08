FROM node

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY source/package*.json ./

RUN npm install

WORKDIR /usr/src/app/maps

COPY municipios.geojson .

COPY sucursal.geojson .

RUN npm install http-server -g

CMD [ "http-server", "--cors='kbn-version'", "-p", "8000" ]

EXPOSE 8080 8000

#CMD [ "node", "server.js" ]
