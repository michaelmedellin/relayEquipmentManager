FROM node:18 AS build-env
COPY . /app
WORKDIR /app
RUN npm ci --omit=dev
RUN npm run build

FROM node:18 AS ts-remover
WORKDIR /app
COPY --from=build-env /app/package*.json ./
COPY --from=build-env /app/dist ./
RUN npm ci --only=production

FROM gcr.io/distroless/nodejs:18
WORKDIR /app
COPY --from=ts-remover /app /app
CMD ["app.js"]
