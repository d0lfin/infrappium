FROM ubuntu-debootstrap:14.04

ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:$PATH
ENV LD_LIBRARY_PATH ${ANDROID_HOME}/tools/lib64/gles_mesa:${ANDROID_HOME}/tools/lib64/:${ANDROID_HOME}/tools/lib64/qt/lib
ENV DISPLAY :10

COPY files/android.conf /etc/ld.so.conf.d/
COPY files/xorg.conf /etc/X11/
COPY files/run_emulator.sh /opt/

RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y \
    curl \
    gettext-base \
    lib32ncurses5 \
    lib32stdc++6 \
    lib32z1 \
    libgl1-mesa-glx \
    libx11-6 \
    libx11-dev \
    libx11-6:i386 \
    libx11-dev:i386 \
    qemu-kvm \
    qemu-system-x86 \
    unzip \
    xserver-xorg \
    xserver-xorg-video-dummy \
    x11-xserver-utils \
    x11vnc \
    wget \
    zlib1g:i386 \

# Install nodejs
    && curl --silent --location https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && apt-get clean \

# Reload cache after add location of graphic libraries
    && ldconfig -v \

    && chmod +x /opt/run_emulator.sh \

    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/Emulator.ini /root/.android/avd/
COPY files/config.ini /root/.android/avd/Emulator.avd/

CMD ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/java /usr/bin/java \
    && /opt/run_emulator.sh \
    && node /opt/appium/ -p 4723 --log-timestamp