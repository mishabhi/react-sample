# Node v12 doesn't work for architect-ui
# because of SASS and node-pre-gyp dependencies
FROM node:10.16.0-slim as builder
# work at app directory, dedicated by `node` base image
WORKDIR /usr/src/app
# copy only needed files to `npm install`
COPY package.json package-lock.json ./
RUN npm install
# build option telling to search compiled files
# at the HTTP root of server
# (`/` instead of `/react-sample/`)
ENV PUBLIC_URL=/
# copy other files needed for build
COPY . ./
RUN npm run build

# use artifacts from previous phase and serve it via Nginx at port 80
FROM nginx:1.17.0-alpine
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
