## Stage 1: Build Stage
#FROM oven/bun:1
#
## Buat user dan grup baru
#RUN addgroup -S mygroup && adduser -S myuser -G mygroup
#
## Set working directory
#WORKDIR /app
#
## Set user ke myuser
#USER myuser
#
#COPY bun.lockb .
#COPY package.json .
#COPY bunfig.toml .
#
## Pastikan CGO diaktifkan
#ENV CGO_ENABLED=1
#
#RUN bun install --frozen-lockfile
#
#COPY express.ts .
#
## compile everything to a binary called cli which includes the bun runtime
#RUN bun build express.ts --compile --minify --sourcemap --outfile cli
#
## Set user kembali ke root untuk eksekusi CMD (jika diperlukan)
#USER root
#
## execute the binary!
#CMD ["/app/cli"]


# FROM DOC BUNJS
# use the official Bun image
# see all versions at https://hub.docker.com/r/oven/bun/tags
FROM oven/bun:1 AS base
WORKDIR /usr/src/app
RUN mkdir /usr/src/app/logs

# install dependencies into temp directory
# this will cache them and speed up future builds
FROM base AS install
RUN mkdir -p /temp/dev
COPY package.json bun.lockb /temp/dev/
RUN cd /temp/dev && bun install

## install with --production (exclude devDependencies)
#RUN mkdir -p /temp/prod
#COPY package.json bun.lockb /temp/prod/
#RUN cd /temp/prod && bun install --frozen-lockfile --production

# copy node_modules from temp directory
# then copy all (non-ignored) project files into the image
FROM base AS prerelease
COPY --from=install /temp/dev/node_modules node_modules
COPY . .

# [optional] tests & build
#ENV NODE_ENV=production
#RUN bun test
#RUN bun run build
RUN bun build express.ts --compile --minify --sourcemap --outfile cli

# copy production dependencies and source code into final image
FROM base AS release
#COPY --from=install /temp/prod/node_modules node_modules
COPY --from=prerelease /usr/src/app/cli .
#COPY --from=prerelease /usr/src/app/package.json .

# run the app
USER bun
EXPOSE 4999/tcp
#ENTRYPOINT [ "bun", "run", "index.ts" ]
ENTRYPOINT [ "/usr/src/app/cli" ]