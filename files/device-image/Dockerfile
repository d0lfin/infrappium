FROM ubuntu-debootstrap:14.04

ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:$PATH
ENV PORT 4723
ENV HUB_PORT 4443
ENV DEVICEUDID qwert

COPY files/configgen.sh /opt/configgen.sh
COPY files/adbkey.pub /root/.android/adbkey.pub
COPY files/adbkey /root/.android/adbkey

RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y \
    curl \
    gettext-base \
    lib32ncurses5 \
    lib32stdc++6 \
    lib32z1 \
    unzip \
    wget \

# Install nodejs
    && curl --silent --location https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && apt-get clean \

# Reload cache after add location of graphic libraries
    && ldconfig -v \

    && chmod +x /opt/configgen.sh \

    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/java /usr/bin/java \
    && /opt/configgen.sh > /opt/nodeconfig.json \
    && node /opt/appium/ -p $PORT --log-timestamp --session-override --udid $DEVICEUDID \
           --nodeconfig /opt/config/nodeconfig.json