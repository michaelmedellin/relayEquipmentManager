FROM node:18 AS build-env
WORKDIR /app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm ci --omit=dev
COPY . ./
RUN npm run build

FROM node:18 AS ts-remover
WORKDIR /app
COPY --from=build-env /app/package*.json ./
COPY --from=build-env /app/dist ./
RUN npm ci --only=production

FROM gcr.io/distroless/nodejs:18
WORKDIR /app
COPY --from=ts-remover /app ./
CMD ["app.js"]
