FROM node:13.12.0

RUN yarn install

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"