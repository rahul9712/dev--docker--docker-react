# to be able to configure nginx for assets within our server, we need to build two phases.
#   1. Build Phase
#       Use node:alpine as base image
#       Copy package.json file
#       Install dependencies
#       Run 'npm run build'
#   2. Run Phase
#       Use nginx as base image
#       Copy over the result of 'npm run build'
#       Start nginx


# Phase 1: Install dependencies and build our app.
# Base Image and tag it as builder
FROM node:alpine as builder
# Work Dir
WORKDIR '/app'
# Copy package
COPY package.json .
# Setup dependencies
RUN npm install
# Copy rest of files
COPY . .
# Build our app
RUN npm run build

# /app/build ---> Result of npm run build


# Previous phase is complete, and nothing will be executed on following phase
# Phase 2: Bring files andfrom phase 1 and run nginx
# Base image for nginx
FROM nginx
# Copy files from builder phase <From path> <to path>
COPY --from=builder /app/build /usr/share/nginx/html
# No need to start enginx, as base image will take care of it
