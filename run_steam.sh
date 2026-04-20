#!/bin/sh
SCRIPTDIR=$(readlink -f $(dirname "$0"))
STEAMROOT="$SCRIPTDIR/steam"

# setup steam data dir
mkdir -p ~/.steam
if [ ! -d ~/.steam/steam ]; then
	ln -s "$STEAMROOT" ~/.steam/steam
fi

# ensure that the arm64 version of the steamrt based steam binary is used
if [ ! -d "$STEAMROOT/steamrt64_backup" ]; then
	mv "$STEAMROOT/steamrt64" "$STEAMROOT/steamrt64_backup"
fi
ln -s "$STEAMROOT/steamrtarm64" "$STEAMROOT/steamrt64"

# satisfy conditions for running steamrt client
echo "publicbeta" > "$STEAMROOT/package/beta"
touch "$STEAMROOT/.steam-enable-steamrt64-client"
chmod +x "$STEAMROOT/steamrtarm64/steam"

# make more scripts/binaries executable for the steam client
chmod +x "$STEAMROOT/steamrtarm64/steamwebhelper"
chmod +x "$STEAMROOT/steamrtarm64/steamwebhelper.sh"
chmod +x "$STEAMROOT/steamrtarm64/gldriverquery"
chmod +x "$STEAMROOT/steamrtarm64/vulkandriverquery"
chmod +x "$STEAMROOT/steamrtarm64/steamsysinfo"

# run steam
export LD_LIBRARY_PATH="$STEAMROOT/steamrtarm64/":$LD_LIBRARY_PATH
chmod +x "$STEAMROOT/steam.sh"
cd "$STEAMROOT" && "$STEAMROOT/steam.sh" -noverifyfiles
