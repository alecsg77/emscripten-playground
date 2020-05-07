FROM trzeci/emscripten:latest as build

WORKDIR /workspace/wasm
COPY . ./

RUN emmake make

FROM nginx:stable-alpine

WORKDIR /var/www/

COPY --from=build /workspace/wasm/bin/ /var/www/
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

LABEL Name=wasm Version=0.0.1
