# Node v12 doesn't work for architect-ui
# because of SASS and node-pre-gyp dependencies
FROM node:10.16.0-slim as builder
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
ENV PUBLIC_URL=/
COPY . ./
RUN npm run build

FROM nginx:1.17.0-alpine
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
