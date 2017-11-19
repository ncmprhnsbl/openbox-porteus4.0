#!/bin/bash
# author:Matsuda Shinpei
# Date:March 2011
#
# Openbox Pipe Menu for audacious
# Feel free to change this script as you like.
# Probably, it's not so hard to make rhythembox or other media player control menus like this,
# as far as these media players support the CUI control commands.
# Indeed, here, adapted for Deadbeef..
 
if [ ! "$(pidof deadbeef)" ]; then
    cat <<EOF
<openbox_pipe_menu>
  <item label="Run deadbeef">
    <action name="Execute">
      <execute>
        deadbeef
      </execute>
    </action>
  </item>
</openbox_pipe_menu>
EOF
else
#Controls for when running 
cat <<EOF
<openbox_pipe_menu>
<separator label="DeadBeef Music Player" />
<separator label="`deadbeef --nowplaying '%a - %t - %l - %e'`" />
   <item label="Play-Pause">
     <action name="Execute">
       <execute>
         deadbeef --play-pause 
       </execute>
     </action>
   </item>
   <item label="Stop">
     <action name="Execute">
       <execute>
         deadbeef --stop
       </execute>
     </action>
   </item>
   <item label="Previous">
     <action name="Execute">
       <execute>
         deadbeef --prev
       </execute>
     </action>
   </item>
   <item label="Next">
     <action name="Execute">
       <execute>
         deadbeef --next
       </execute>
     </action>
   </item>
   <separator/>
   <item label="Random ">
     <action name = "execute">
       <execute>
         deadbeef --random
       </execute>
     </action>
   </item>
   <separator />
   <item label="Quit Deadbeef">
     <action name="Execute">
       <execute>
         deadbeef --quit
       </execute>
     </action>
   </item>
</openbox_pipe_menu>
EOF
fi
