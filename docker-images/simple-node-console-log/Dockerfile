FROM node:20-alpine

USER node

WORKDIR /home/node/app

COPY --chown=node ./app/index.js .

CMD ["node", "index.js"]