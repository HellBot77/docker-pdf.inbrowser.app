FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/pdf.inbrowser.app.git && \
    cd pdf.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /pdf.inbrowser.app
COPY --from=base /git/pdf.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /pdf.inbrowser.app/dist .
