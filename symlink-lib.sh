set -e

if [ -z ${LIBRARIES_DIR+x} ]; then
  echo "LIBRARIES_DIR must be set to the libraries directory path... exiting"
  exit 1
fi

if [ ! -d "$LIBRARIES_DIR" ]; then
  echo "$LIBRARIES_DIR does not exit... exiting"
  exit 1
fi

name=entity_store
prefix=event_store
full_name=$prefix/$name
dest="$LIBRARIES_DIR/$prefix"

if [ ! -d "$dest" ]; then
  mkdir -p "$dest"
fi

echo
echo "Symlinking $full_name"
echo "- - -"

if [ -h "$dest/$name" ]; then
  for entry in $LIBRARIES_DIR/$full_name*; do
    if [ -e "$entry" ]; then
      echo "- removing symlink: $entry"
      rm $entry
    fi
  done
fi

echo "- creating symlinks"
ln -s $(PWD)/lib/$full_name* $dest

echo "- - -"
echo "($full_name done)"
echo
