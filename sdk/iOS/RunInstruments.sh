#!/bin/bash -x

# Make sure we are executing in this script's directory
cd "$( cd "$( dirname "$0" )" && pwd )"
rm -R Results
mkdir Results

DIR="$( pwd )"

if [ $# -lt 7 ]
then
  #           $0 $1                  $2                  $3         $4                        $5           $6               $7        $8 (optional)       
  echo Usage: $0 \<Application URL\> \<Application Key\> \<device\> \<zumotestuser password\> \<clientId\> \<clientSecret\> \<runId\> \<iOSsdkZip\>
  echo Where
  echo   \<Application URL\> is the URL of the Mobile Service
  echo   \<Application key\> is the app key for that service
  echo   \<device\> is one of the following:
  echo       - iPhoneSim \(default\)  - iPadSim             - iPadSimResizable
  echo       - iPadSimAir           - iPadSimRetina       - iPhoneSimResizable
  echo       - iPhoneSim4s          - iPhoneSim5          - iPhoneSim5s
  echo       - iPhoneSim6Plus       - iPhoneSim6PlusWatch - iPhoneSim6sPlus
  echo       - iPhone6sPlusWatch
  echo   \<loginPassword\> - the password to use for log in operations \(for zumotestuser account\)
  echo   \<iOSsdkZip\> is the zip file location of the framework to test against \(optional\)
  exit 1
fi

echo "$3"
export DEVICE_ARG=
export APP_NAME=
export DEVICE_CMD_ARG=$3

echo Device: $DEVICE_CMD_ARG

# Build current app to test with
pushd ZumoE2ETestApp

if [ $8 ]
then
  # Copy specified framework
  cp -f $8 sdk.zip
else
  # Copy in current version of the framework
  curl --location --output sdk.zip --silent http://aka.ms/gc6fex
fi

unzip -o sdk.zip

xcodebuild -sdk iphonesimulator9.1 || exit 1
# xcodebuild -sdk iphoneos7.1
popd

if [ "$DEVICE_CMD_ARG" == "iPhone5" ]; then
  echo Using real device
  export DEVICE_ARG=2a75c76d6d92841f82746de082e61f9ee90c2dbf
  APP_NAME=ZumoE2ETestApp
fi

if [ "$DEVICE_CMD_ARG" == "iPad" ]; then
  echo Using real device
  export DEVICE_ARG=2cd4344e476a4496f695a904dd0b24013e865f0c  
  APP_NAME=ZumoE2ETestApp
fi

if [ "$DEVICE_CMD_ARG" == "iPad2Sim" ]; then
  echo Using iPad 2 Simulator
  export DEVICE_ARG=iPad\ 2\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPadSimAir" ]; then
  echo Using iPad Air Simulator
  export DEVICE_ARG=iPad\ Air\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPadSimAir2" ]; then
  echo Using iPad Air 2 Simulator
  export DEVICE_ARG=iPad\ Air\ 2\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPadSimPro" ]; then
  echo Using iPad Pro Simulator
  export DEVICE_ARG=iPad\ Pro\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPadSimRetina" ]; then
  echo Using iPad Retina Simulator
  export DEVICE_ARG=iPad\ Retina\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim4s" ]; then
  echo Using iPhone 4s Simulator
  export DEVICE_ARG=iPhone\ 4s\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim5" ]; then
  echo Using iPhone 5 Simulator
  export DEVICE_ARG=iPhone\ 5\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim5s" ]; then
  echo Using iPhone 5s Simulator
  export DEVICE_ARG=iPhone\ 5s\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6" ]; then
  echo Using iPhone 6 Simulator
  export DEVICE_ARG=iPhone\ 6\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6Plus" ]; then
  echo Using iPhone 6 Plus Simulator
  export DEVICE_ARG=iPhone\ 6\ Plus\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6s" ]; then
  echo Using iPhone 6s Simulator
  export DEVICE_ARG=iPhone\ 6s\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6sWatch" ]; then
  echo Using iPhone 6s Simulator + Apple Watch
  export DEVICE_ARG=iPhone\ 6s\ \(9.1\)\ +\ Apple\ Watch\ -\ 38mm\ \(2.0\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6sPlus" ]; then
  echo Using iPhone 6s Plus Simulator
  export DEVICE_ARG=iPhone\ 6s\ \(9.1\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$DEVICE_CMD_ARG" == "iPhoneSim6sPlusWatch" ]; then
  echo Using iPhone 6s Plus Simulator + Apple Watch
  export DEVICE_ARG=iPhone\ 6s\ Plus\ \(9.1\)\ +\ Apple\ Watch\ -\ 42mm\ \(2.0\)
  APP_NAME=$DIR/ZumoE2ETestApp/build/Release-iphonesimulator/ZumoE2ETestApp.app
fi

if [ "$APP_NAME" == "" ]
then
  echo Unsupported device: "$3"
  exit 1
fi

echo DEVICE_ARG: $DEVICE_ARG
echo APP_NAME: $APP_NAME

sed -e "s/--APPLICATION_URL--/$1/g" ZumoAutomationTemplate.js > ZumoAutomationTemplate-temp.js
sed -e "s/--APPLICATION_KEY--/$2/g" ZumoAutomationTemplate-temp.js > ZumoAutomationTemplate-temp1.js
sed -e "s/--CLIENT_ID--/$5/g" ZumoAutomationTemplate-temp1.js > ZumoAutomationTemplate-temp.js
sed -e "s/--CLIENT_SECRET--/$6/g" ZumoAutomationTemplate-temp.js > ZumoAutomationTemplate-temp1.js
sed -e "s/--RUN_ID--/$7/g" ZumoAutomationTemplate-temp1.js > ZumoAutomationTemplate-temp.js
sed -e "s/--AUTH_PASSWORD--/$4/g" ZumoAutomationTemplate-temp.js > ZumoAutomationWithData.js

echo Replaced data on template - now running instruments
echo Args: DEVICE_ARG = $DEVICE_ARG
echo APP_NAME = $APP_NAME

export INSTRUMENT_TEMPLATE=/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate

echo Running instruments...
instruments -w "$DEVICE_ARG" -t "$INSTRUMENT_TEMPLATE" "$APP_NAME" -e UIASCRIPT "ZumoAutomationWithData.js" -e UIARESULTSPATH "Results" || exit 1

exit 0
