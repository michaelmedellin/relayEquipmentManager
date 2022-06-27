FROM node:18 AS build-env
WORKDIR /app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm ci 
COPY . ./
RUN npm run build

FROM gcr.io/distroless/nodejs:18
WORKDIR /app
RUN mkdir ./dist
COPY --from=build-env /app/dist ./dist
COPY --from=build-env /app/defaultConfig.json ./
CMD ["dist/app.js"]
