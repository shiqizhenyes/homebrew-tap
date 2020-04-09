#!/bin/sh
VERSION=$1

# check presence of version
if [ -z $VERSION ]; then
	echo "Missing argument with version" >&2
	exit 1
fi

echo "Preparing release $VERSION"

# check presence of tooling
SHASUM=`which shasum`
CURL=`which curl`
[ -n ${SHASUM} ] && [ -n ${CURL} ] || exit 2

# Check if macOS release exists, if it does then it is likely that the Linux one does too
TARGET="https://github.com/Spotifyd/spotifyd/releases/download/v${VERSION}/spotifyd-macos-full.tar.gz"

CHECKVER_CODE=`curl -X HEAD -m 3 -sfw "%{response_code}" ${TARGET}`
if [ $CHECKVER_CODE -ne 302 ]; then
	echo "Version ${VERSION} does not exist" >&2
	exit 3
fi

# The URLs for the respective sha512s
LINUX_SHA_URL="https://github.com/Spotifyd/spotifyd/releases/download/v${VERSION}/spotifyd-linux-full.sha512"
MAC_SHA_URL="https://github.com/Spotifyd/spotifyd/releases/download/v${VERSION}/spotifyd-macos-full.sha512"

echo "Fetching Linux sha512"
LINUX_SHA=$(curl -sLS "${LINUX_SHA_URL}" | cut -f1 -d\ "")
echo "Fetching macOS sha512"
MAC_SHA=$(curl -sLS "${MAC_SHA_URL}" | cut -f1 -d\ "")

cat > Formula/spotifyd.rb <<FORMULA
class Spotifyd < Formula
  version "v${VERSION}"
  desc "A spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-macos-full.tar.gz"
    sha512 "${MAC_SHA}"
  elsif OS.linux?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-linux-full.tar.gz"
    sha512 "${LINUX_SHA}"
  end

  depends_on "dbus"
  depends_on "portaudio"

  def install
    bin.install "spotifyd"
  end

  test do
    system "#{bin}/spotifyd", "--version"
  end
end
FORMULA

echo "Successfully updated! Check the code before pushing."
