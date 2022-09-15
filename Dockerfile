# syntax = docker/dockerfile:1.0-experimental

# ---- Builder ----
FROM node:14.15-alpine as builder
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
COPY tsconfig.json ./
COPY tsconfig.build.json .
RUN --mount=type=secret,id=npmrc,dst=/root/.npmrc npm ci
COPY ./src ./src
RUN npm run build

# ---- Dev ----
FROM node:14.15-alpine AS dev
ENV NODE_ENV=development
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/dist ./dist
COPY . .
EXPOSE 3000
CMD ["npm", "run", "start:dev"]

# ---- Production ----
FROM node:14.15-alpine AS production
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN --mount=type=secret,id=npmrc,dst=/root/.npmrc npm ci --only=production
COPY --from=builder /usr/src/app/dist ./dist
COPY service-envs-config.json .
EXPOSE 3000
CMD ["npm", "run", "start:prod"]
