FROM node:12-stretch-slim

RUN runDeps="openssl ca-certificates patch git" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $runDeps \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV CYPRESS_INSTALL_BINARY=0
ENV RAZZLE_API_PATH=VOLTO_API_PATH
ENV RAZZLE_INTERNAL_API_PATH=VOLTO_INTERNAL_API_PATH

RUN npm install -g pnpm
RUN npm install -g yalc

RUN mkdir -p /opt/
WORKDIR /opt

RUN git clone https://github.com/eea/searchlib.git
RUN chown -R node /opt/searchlib/
USER node
WORKDIR /opt/searchlib
RUN git checkout standalone-split

RUN pnpm i || true
RUN pnpm m build || true

USER root
WORKDIR /opt/searchlib/packages/searchlib
RUN yalc publish

WORKDIR /opt/searchlib/packages/searchlib-globalsearch
RUN yalc publish

WORKDIR /opt/searchlib/packages/searchlib-less
RUN yalc publish

WORKDIR /opt/searchlib/packages/searchlib-middleware
RUN yalc publish

COPY . /opt/frontend/
RUN chown -R node /opt/frontend/

WORKDIR /opt/frontend/

RUN yarn develop
RUN yalc add --no-pure @eeacms/search
RUN yalc add --no-pure @eeacms/globalsearch
RUN yarn
RUN yarn build
# RUN rm -rf /home/node/.cache

EXPOSE 3000 3001 4000 4001

ENTRYPOINT ["/opt/frontend/entrypoint-prod.sh"]
CMD ["yarn", "start:prod"]
