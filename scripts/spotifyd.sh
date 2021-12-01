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
MAC_TAR_URL="https://github.com/shiqizhenyes/spotifyd/releases/download/v${VERSION}/spotifyd-macos-slim.tar.gz"

CHECKVER_CODE=`curl -X HEAD -m 3 -sfw "%{response_code}" ${MAC_TAR_URL}`
if [ $CHECKVER_CODE -ne 302 ]; then
	echo "Version ${VERSION} does not exist" >&2
	exit 3
fi

# The Spotifyd CD generates sha512s, but Homebrew only supports sha256s.
# The URLs for the respective sha512s
#MAC_SHA_URL="https://github.com/shiqizhenyes/spotifyd/releases/download/v${VERSION}/spotifyd-macos-slim.sha512"

echo "Fetching macOS sha256"
#MAC_SHA=$(curl -sLS "${MAC_SHA_URL}" | cut -f1 -d\ "")
MAC_SHA=$(curl -sLS "${MAC_TAR_URL}" | shasum -a 256 | cut -f1 -d\ "")

cat > Formula/spotifyd.rb <<FORMULA
class Spotifyd < Formula
  version "v${VERSION}"
  desc "A spotify daemon"
  homepage "https://github.com/shiqizhenyes/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/shiqizhenyes/spotifyd/releases/download/#{version}/spotifyd-macos-slim.tar.gz"
    sha256 "${MAC_SHA}"
  end

  depends_on "dbus"

  def install
    bin.install "spotifyd"
  end

  test do
    system "#{bin}/spotifyd", "--version"
  end
end
FORMULA

echo "Successfully updated! Check the code before pushing."
