set -e

if [ -z ${LIBRARIES_DIR+x} ]; then
  echo "LIBRARIES_DIR must be set to the libraries directory path... exiting"
  exit 1
fi

if [ ! -d "$LIBRARIES_DIR" ]; then
  echo "$LIBRARIES_DIR does not exit... exiting"
  exit 1
fi

function make_directory {
  directory=$1

  lib_directory="$LIBRARIES_DIR/$directory"

  if [ ! -d "$lib_directory" ]; then
    echo "- making directory $lib_directory"
    mkdir -p "$lib_directory"
    echo
  fi
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

    make_directory $directory
  fi
  src="$src/$name"

  echo "- destination is $dest"
  echo

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

  echo "- - -"
  echo "($name done)"
  echo
}
