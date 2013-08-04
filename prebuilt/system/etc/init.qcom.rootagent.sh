#!/system/bin/sh
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
set -x
agentvalue=`getprop persist.sys.agentvalue`

value=($agentvalue)
action=${value[0]} # 0 based
doAction=""

# Autotrigger functions
ROOT_AUTOTRIGGER_PATH="/sdcard/logs/autotrigger"
function Preprocess(){
rm -r $ROOT_AUTOTRIGGER_PATH
mkdir -p $ROOT_AUTOTRIGGER_PATH
}
function Logcat(){
logcat -v time -d > $ROOT_AUTOTRIGGER_PATH/main.txt
logcat -b radio -v time -d > $ROOT_AUTOTRIGGER_PATH/radio.txt
logcat -b events -v time -d > $ROOT_AUTOTRIGGER_PATH/events.txt
}
function Dmesg(){
dmesg > $ROOT_AUTOTRIGGER_PATH/dmesg.txt;
}
function Dumpsys(){
dumpsys > $ROOT_AUTOTRIGGER_PATH/dumpsys.txt;
}
function Top(){
top -n 1 > $ROOT_AUTOTRIGGER_PATH/top.txt;
}
function ANR(){
ANR_PATH="/data/anr"
ANR_LIST=`ls $ANR_PATH`
for file in $ANR_LIST;
do
	cat $ANR_PATH/$file> $ROOT_AUTOTRIGGER_PATH/$file
done
}
function Tombstone(){
TOMBSTONE_PATH="/data/tombstones"
TOMBSTONE_LIST=`ls $TOMBSTONE_PATH`
for file in $TOMBSTONE_LIST;
do
	cat $TOMBSTONE_PATH/$file> $ROOT_AUTOTRIGGER_PATH/$file
done
}
function CatchAll(){
	Preprocess;Top;Dumpsys;Logcat;Dmesg;ANR;Tombstone;
}
# only the action in our action list can be executed
case $action in	
	"insmod")
		doAction=$agentvalue
	;;
	"rmmod")
		doAction=$agentvalue
	;;
	"echo")
		doAction=$agentvalue
	;;
	"chmod")
		doAction=$agentvalue
	;;
	"autotrigger")
		case ${value[1]} in
			"ApplicationCrash")
                CatchAll
			;;
			"SystemRestart")
                CatchAll
			;;
			"SystemTombstone")
                CatchAll
			;;
		esac
	;;

esac
echo $doAction

eval "$doAction"
# clear the action when done
setprop persist.sys.agentvalue 0
