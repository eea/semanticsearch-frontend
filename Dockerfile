FROM node:14-stretch-slim

RUN runDeps="openssl ca-certificates patch git python build-essential" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $runDeps \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV CYPRESS_INSTALL_BINARY=0
ENV RAZZLE_API_PATH=VOLTO_API_PATH
ENV RAZZLE_INTERNAL_API_PATH=VOLTO_INTERNAL_API_PATH

RUN npm install -g pnpm
RUN npm install -g yalc
RUN npm install -g mrs-developer

RUN mkdir -p /opt/

#RUN yarn develop
#RUN yarn
#RUN yarn build
# RUN rm -rf /home/node/.cache

EXPOSE 3000 3001 4000 4001

#ENTRYPOINT ["/opt/frontend/entrypoint-prod.sh"]
#CMD ["yarn", "start:prod"]
