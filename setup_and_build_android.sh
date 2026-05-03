#!/bin/bash
set -e

echo "Updating apt and installing JDK 17, wget, and unzip..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk wget unzip curl

echo "Downloading Android Command Line Tools..."
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
rm -rf latest
echo "Fetching the latest Android Command Line Tools URL..."
CMD_TOOLS_URL=$(curl -s https://dl.google.com/android/repository/repository2-3.xml | grep -o 'commandlinetools-linux-[0-9]*_latest.zip' | head -n 1)
wget "https://dl.google.com/android/repository/$CMD_TOOLS_URL" -O cmdline-tools.zip
unzip -q cmdline-tools.zip
mv cmdline-tools latest
rm cmdline-tools.zip

echo "Setting up Android environment variables..."
export ANDROID_HOME=~/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Accepting Android SDK licenses..."
yes | sdkmanager --licenses

echo "Installing Android Platform Tools, Platforms, and Build Tools..."
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "Android SDK and JDK installed successfully!"

echo "Installing React Native dependencies..."
cd /workspaces/sai/sai-rn-agent
npm install

echo "Building Android App (Release APK)..."
cd android
chmod +x gradlew
./gradlew assembleRelease

echo "Build complete! APK should be in sai-rn-agent/android/app/build/outputs/apk/release/"
