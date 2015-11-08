set -e

if [ -z ${LIBRARIES_DIR+x} ]; then
  echo "LIBRARIES_DIR must be set to the libraries directory path... exiting"
  exit 1
fi

if [ ! -d "$LIBRARIES_DIR" ]; then
  echo "$LIBRARIES_DIR does not exit... exiting"
  exit 1
fi

function symlink-nested-library {
  directory=$1
  name=$2

  echo
  echo "Symlinking $name"
  echo "- - -"

  dest="$LIBRARIES_DIR/$directory"

  if [ ! -d "$dest" ]; then
    echo "Making directory $dest"
    mkdir -p "$dest"
  fi

  symlink-library $name $directory
}

function symlink-library {
  name=$1
  directory=$2

  echo
  echo "Symlinking $name"
  echo "- - -"

  src="$(PWD)/lib"
  dest="$LIBRARIES_DIR"
  if [ ! -z "$directory" ]; then
    src="$src/$directory"
    dest="$dest/$directory"
  fi
  src="$src/$name"

  echo "Destination is $dest"

  full_name=$directory/$name

  for entry in $src*; do
    entry_basename=$(basename $entry)
    dest_item="$dest/$entry_basename"

    if [ -h "$dest_item" ]; then
      echo "- removing symlink: $dest_item"
      rm $dest_item
    fi

    echo "- symlinking $entry_basename to $dest_item"

    cmd="ln -s $entry $dest_item"
    echo $cmd
    ($cmd)

    echo
  done


  # if [ -h "$dest/$name" ]; then
  #   for entry in $LIBRARIES_DIR/$full_name*; do
  #     if [ -e "$entry" ]; then
  #       echo "- removing symlink: $entry"
  #       rm $entry
  #     fi
  #   done
  # fi

  # echo "- creating symlinks"
  # ln -s $(PWD)/lib/$full_name* $dest

  echo "- - -"
  echo "($name done)"
  echo
}
