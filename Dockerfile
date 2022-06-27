FROM node:18 AS build-env
WORKDIR /app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm ci 
COPY . ./
RUN npm run build
RUN npm install --omit=dev 

FROM node:18 AS ts-remover
WORKDIR /app
COPY --from=build-env /app/package*.json ./
COPY --from=build-env /app/dist ./
COPY --from=build-env /app/defaultConfig.json ./
COPY --from=build-env /app/defaultController.json ./
RUN npm ci --omit=dev

FROM gcr.io/distroless/nodejs:18
WORKDIR /app
COPY --from=ts-remover /app ./
USER 1000
CMD ["app.js"]

