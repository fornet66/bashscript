#!/bin/bash
# Stage
Width=44
Height=20
BorderTop=2
BorderLeft=6
((BorderRight=Width-8))
((BorderBtm=Height+2))
Padding=""

# Stair
StairWidth=10
StairX=(0)
StairY=(0)
StairZ=(0) # 1-=== 2-ooo 3-+++
HeadItem=0
StairNum=8
StairSpace=0
StairYSpeed=-1

# Player
Player=":)"
PlayerWidth=2
PlayerXPos=0
((PlayerYPos=Height+1))
PlayerXSpeed=0
PlayerYSpeed=-1
Life=10

# System
((InfoX=Width+5))
Count=0
CurCount=0
Score=0
Level=1
SleepTime=100000
Stty=" "
sig=0

# Color
Normal="\033[0m"
Red="\033[1;41m"
Red2="\033[7;31;47m"
Green="\033[1;37;42m"
Brown="\033[1;43m"
FRed="\033[1;31m"
FBlue="\033[1;34m"
FPurple="\033[1;35m"
FChing="\033[1;36m"
FBold="\033[1m"

function DrawStage(){
  local PaddingLen i
  Item="$Normal    $Green[]$Normal"
  ((PaddingLen=Width-4))

  for((i=1;i<=PaddingLen;i+=2))
  do
    Padding=$Padding"  "
  done
  Item=$Item$Padding"$Green[]$Normal"

  DrawBlood
  tput cup 2 4
  echo -e "$Green[]$Normal VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV $Green[]$Normal"

  for((i=1;i<Height;i++))
  do
    echo -e "$Item"
  done
  tput cup 3 $InfoX
  echo -e "$FPurple Score  $Normal"
  tput cup 4 $InfoX
  echo -e "$FBlue $Score  $Normal"
  tput cup 5 $InfoX
  echo -e "$FPurple Level  $Normal"
  tput cup 6 $InfoX
  echo -e "$FBlue $Level  $Normal"
  tput cup 8 $InfoX
  echo -e "$FPurple LEFT $Normal"
  tput cup 9 $InfoX
  echo -e "$FBlue J $Normal"
  tput cup 10 $InfoX
  echo -e "$FPurple RIGHT $Normal"
  tput cup 11 $InfoX
  echo -e "$FBlue K $Normal"
  tput cup 12 $InfoX
  echo -e "$FPurple EXIT $Normal"
  tput cup 13 $InfoX
  echo -e "$FBlue Q $Normal"
}

function ScoreRefresh(){
  tput cup 4 $InfoX
  echo -e "$FBlue $Score  $Normal"
}

function LevelRefresh(){
  tput cup 6 $InfoX
  echo -e "$FBlue $Level  $Normal"
}

function ScreenRefresh(){
  local i
  for((i=3;i<BorderBtm;i++))
  do
        tput cup $i 6
    echo "$Padding"
  done
}

function IsReduceLife(){
  [[ $1 -eq 3 ]] && ((Life--)) && DrawBlood
}

function DrawBlood(){
  local i blood=" "
  for((i=0;i<Life;i++))
  do
        blood=$blood"  "
  done
  tput cup 0 4
  echo "$Normal                        "
  tput cup 0 4
  echo -e "$Brown Life $Red2$blood$Normal"
}

function ProduceStair(){ # param:Index
  ((StairX[$1]=RANDOM%15))
  ((StairX[$1]=StairX[$1]*2+6))
  ((StairY[$1]=BorderBtm))
  ((StairZ[$1]=RANDOM%6))
  [[ StairZ[$1] -eq 0 ]] || [[ StairZ[$1] -eq 4 ]] || [[ StairZ[$1] -eq 5 ]] && ((StairZ[$1]=1))
}

function DrawStair(){ # param: Index
  tput cup ${StairY[$1]} ${StairX[$1]}
  case ${StairZ[$1]} in
  1)  echo -e "$FBold==========$Normal"
  ;;
  2)  echo -e $FChing"oooooooooo$Normal"
  ;;
  3)  echo -e "$FRed++++++++++$Normal"
  ;;
  esac
}

function DrawPlayer(){
  tput cup $PlayerYPos $PlayerXPos
  echo -e $Brown"$Player"$Normal
}

# debug
function ArrayList(){
  local i
  echo =================
  for((i=0;i<StairNum;i++))
  do  
    echo ${StairX[$i]} ${StairY[$i]} ${StairZ[$i]}
  done
  echo =================
}

function GameInit(){
  clear
  Stty=`stty -g`
  echo -ne "\033[?25l"
  stty -echo
  DrawStage
  ((StairX[0]=RANDOM%15))
  ((StairX[0]=StairX[0]*2+6))
  ((StairY[0]=BorderBtm))
  ((StairZ[0]=1))
  ((PlayerXPos=StairX[0]+4))
}

function GameExit(){
  sleep 0.5 
  echo -e "\033[?25h\033[${y};0H"
  stty $Stty
  clear
  exit 0
}

function GameOver(){
  tput cup 10 18
  echo -e "$Red   GAME  OVER   $Normal"
  tput cup 11 18
  echo -e "$Red                $Normal"
  tput cup 12 18
  echo -e "$Red Exit(q)        $Normal"
  tput cup 13 18
  echo -e "$Red Continue(c)    $Normal"
  tput cup 14 18
  echo -e "$Red                $Normal"
  exit 0
}

function GameClear(){
  tput cup 10 18
  echo -e "$Red    ALL  CLEAR    $Normal"
  tput cup 11 18
  echo -e "$Red                  $Normal"
  tput cup 12 18
  echo -e "$Red YOU ARE SUPERMAN $Normal"
  tput cup 13 18
  echo -e "$Red CONGRATULATIONS! $Normal"
  tput cup 14 18
  echo -e "$Red                  $Normal"
  exit 0
}

function GetCount(){
  [[ StairX[$HeadItem] -eq 0 ]] && ProduceStair $HeadItem
  ((HeadItem++))
  [[ HeadItem -eq StairNum ]] && !((HeadItem=0)) && ((Score+=1)) && ScoreRefresh \
  && [[ Score%5 -eq 0 ]] && ((Level++)) && ((SleepTime-=1000)) && LevelRefresh \
  && [[ Life -lt 10 ]] && ((Life+=2)) && [[ Life -gt 10 ]] && ((Life=10)) && DrawBlood

  ((Count=RANDOM%2))
  [[ $Count -eq 0 ]] && ((Count=2))
  [[ $Count -eq 1 ]] && ((Count=4))
}

function DataProcess(){
  [[ Count -eq CurCount ]] && !((CurCount=0)) && GetCount
  ((CurCount++))

  [[ Life -eq 0 ]] && GameOver 
  [[ SleepTime -eq 0 ]] && GameClear

  # Player Process
  [[ PlayerXPos -eq BorderLeft ]] && [[ sig -eq 27 ]] && ((PlayerXSpeed=2)) && Player=":)"
  [[ PlayerXPos -eq BorderLeft ]] && [[ sig -eq 26 ]] && ((PlayerXSpeed=0)) && ((sig=0))
  [[ PlayerXPos -eq Width ]] && [[ sig -eq 26 ]] && ((PlayerXSpeed=-2)) && Player="(:"
  [[ PlayerXPos -eq Width ]] && [[ sig -eq 27 ]] && (( PlayerXSpeed=0)) && ((sig=0))
  ((PlayerXPos+=PlayerXSpeed))
  ((PlayerYPos+=PlayerYSpeed))
  [[ PlayerYPos -eq BorderTop ]] || [[ PlayerYPos -eq BorderBtm ]] && !((Life=0)) && DrawBlood && GameOver
  DrawPlayer
 
  # Stairs Process
  for((i=0;i<StairNum;i++))
  do
        [[ StairX[$i] -ne 0 ]] && ((StairY[$i]-=1)) && [[ StairY[$i] -gt BorderTop ]] && DrawStair $i
        [[ StairY[$i] -eq BorderTop ]] && !((StairX[$i]=0)) && !((StairY[$i]=0)) && !((StairZ[$i]=0))
  done

  # Collision Process
  PlayerYSpeed=1
  for((i=0;i<StairNum;i++))
  do
        [[ StairX[$i] -ne 0 ]] && [[ PlayerXPos -ge StairX[$i] ]] && [[ PlayerXPos -le StairX[$i]+8 ]] \
        && [[ PlayerYPos+1 -eq StairY[$i] ]] && [[ StairZ[$i] -ne 2 ]] && ((PlayerYSpeed=-1)) \
        && IsReduceLife ${StairZ[$i]} && break
  done
}

function GameRun(){
  trap "sig=26" 26
  trap "sig=27" 27
  trap "sig=28" 28
  while :
  do
        case $sig in
        26) ((PlayerXSpeed=-2)) && Player="(:" 
        ;;
        27) ((PlayerXSpeed=2)) && Player=":)" 
        ;;
        28)        exit 0
        ;;
        esac
        #sig=0
        ScreenRefresh
        DataProcess
        usleep $SleepTime
  done
}

GameInit

# background process
{
  GameRun
} &

# main function
while read -s -n 1 Key
do
  case $Key in
  [jJ]) kill -26 $! > /dev/null 2>&1
  ;;
  [kK]) kill -27 $! > /dev/null 2>&1
  ;;
  [cC]) if [ -z "`ps x | grep $! | grep -v "grep $!" | awk '{print $1}'`" ]
                then
                {
                  GameRun
                } &
            fi
  ;;
  [qQ]) kill -28 $! > /dev/null 2>&1
            GameExit
  ;;
  *)
  ;;
  esac
done

