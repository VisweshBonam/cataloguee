FROM node:20-alpine3.21 AS builder
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

FROM node:20-alpine3.21
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop

WORKDIR /opt/server
COPY --from=builder /opt/server /opt/server

RUN chown -R roboshop:roboshop /opt/server
USER roboshop
CMD ["node" , "server.js"]


# FROM node:20-alpine3.21
# WORKDIR /opt/serever
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node", "server.js"]