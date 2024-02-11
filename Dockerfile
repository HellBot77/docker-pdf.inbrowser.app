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
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /pdf.inbrowser.app/dist /srv/http
EXPOSE 8043