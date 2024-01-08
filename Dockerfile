# ----------------------------
# build-stage
# ----------------------------
FROM mobiledevops/flutter-sdk-image:3.16.4 AS build-stage

# root user phase
USER root

## install required packages
RUN mkdir /app && chown -R mobiledevops:mobiledevops /app
WORKDIR /app
RUN apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# mobiledevops user phase
USER mobiledevops

## setup python venv & install python packages
COPY ./app/requirements.txt ./
RUN python3 -m venv ~/venv \
    && . ~/venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt

## Build App
COPY ./app .
RUN . ~/venv/bin/activate \
    && flet build --project flet-app --product flet-app apk

# ----------------------------
# export-stage
# ----------------------------
FROM scratch AS export-stage
COPY --from=build-stage /app/build/apk /
