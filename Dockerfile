FROM node:14-stretch-slim

RUN runDeps="openssl ca-certificates patch git python build-essential" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $runDeps \
 && apt-get install iputils-ping curl mc -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV CYPRESS_INSTALL_BINARY=0
ENV RAZZLE_API_PATH=VOLTO_API_PATH
ENV RAZZLE_INTERNAL_API_PATH=VOLTO_INTERNAL_API_PATH

RUN npm install -g mrs-developer

RUN mkdir -p /opt/

COPY . /opt/frontend/
COPY ./jsconfig.json.tpl /opt/frontend/jsconfig.json


WORKDIR /opt/frontend/src/addons
RUN git clone https://github.com/eea/searchlib.git
WORKDIR /opt/frontend/src/addons/searchlib
RUN git checkout standalone-split

RUN chown -R node /opt/frontend/

USER node

WORKDIR /opt/frontend/

RUN RAZZLE_API_PATH=VOLTO_API_PATH RAZZLE_INTERNAL_API_PATH=VOLTO_INTERNAL_API_PATH yarn \
  && RAZZLE_API_PATH=VOLTO_API_PATH RAZZLE_INTERNAL_API_PATH=VOLTO_INTERNAL_API_PATH yarn build \
  && rm -rf /home/node/.cache

EXPOSE 3000 3001 4000 4001

ENTRYPOINT ["/opt/frontend/entrypoint-prod.sh"]
CMD ["yarn", "start:prod"]
