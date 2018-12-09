# https://source.android.com/setup/build/requirements
# only Android 7.0 (Nougat) - Android 8.0 (Oreo): Ubuntu - OpenJDK 8, Mac OS - jdk 8u45 or newer

FROM openjdk:8

MAINTAINER Ricky Ng-Adam <rngadam@yahoo.com>

ENV VERSION_SDK_TOOLS "4333796"

# latest is 4.10.3 however that releases leads to an incompability with jacoco and this error:
#
# Execution failed for task ':app:transformClassesWithJacocoForDebug'.
# > There was a failure while executing work items
#    > A failure occurred while executing com.android.build.gradle.internal.transforms.JacocoTransform$JacocoWorkerAction
#       > java.lang.ExceptionInInitializerError (no error message)
#
ENV GRADLE_VERSION 4.6

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/home/user/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip"

# Create a non-root user
RUN useradd -m user
USER user
WORKDIR /home/user

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-${GRADLE_VERSION} gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH="/home/user/gradle/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"
