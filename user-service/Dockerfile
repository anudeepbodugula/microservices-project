########### Stage1: Build Stage ###########
FROM node:18-alpine AS build

WORKDIR /app
## Copy package.json and package-lock.json and install only prod dependencies
COPY package*.json ./
RUN npm install --only=production

####### Stage2: RUN Stage ###########

FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules
COPY . .

## Dont copy .env if you use secrets or envs via container
COPY .env .env

EXPOSE 3000

CMD [ "node", "index.js" ]