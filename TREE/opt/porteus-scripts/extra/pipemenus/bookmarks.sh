#!/bin/bash

echo '<openbox_pipe_menu>'

filemanager="spacefm"

for bookmark in `sed 's/[ ][^ ]*$//' ~/.config/spacefm/bookmarks
` ; do
  echo '<item label="'`basename ${bookmark}`'">'
  echo '<action name="Execute"><execute>'
  echo "$filemanager ${bookmark}"
  echo '</execute></action>'
  echo '</item>'
done

echo '</openbox_pipe_menu>'
