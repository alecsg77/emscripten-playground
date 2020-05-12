ARG EMSCRIPTEN_VERSION=latest
FROM trzeci/emscripten:${EMSCRIPTEN_VERSION} as build

ARG BUILD_TASKS=MINIMAL
RUN /emsdk_portable/emscripten/sdk/embuilder.py build ${BUILD_TASKS}
