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
    && flet build apk

# ----------------------------
# export-stage
# ----------------------------
FROM scratch AS export-stage
COPY --from=build-stage /app/build/apk /

# ----------------------------
# test-stage
# ----------------------------
FROM budtmo/docker-android:emulator_11.0 AS test-stage
ENV EMULATOR_DEVICE="Samsung Galaxy S10"
ENV WEB_VNC=true
COPY --from=build-stage /app/build/apk /home/androidusr/docker-android
ENTRYPOINT ["/home/androidusr/docker-android/mixins/scripts/run.sh"]
CMD ["/bin/bash", "-c", "sleep 2m && adb install -r /home/androidusr/docker-android/app-release.apk"]