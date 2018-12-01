#!/bin/bash
# Copyright (C) 2015 Paranoid Android Project
# Copyright (C) 2018 ATG Droid
# Copyright (C) 2018 PitchBlackTWRP <pitchblacktwrp@gmail.com>
# Copyright (C) 2018 Mohd Faraz <mohd.faraz.abc@gmail.com>
# Copyright (C) 2018 Sipun Ku Mahanta <sipunkumar85@gmail.com>
# Copyright (C) 2018 Sweeto143@github / Darkstar085@XDA
# Copyright (C) 2018 hifzhan41@github / hifzhan41@XDA


# Custom build script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#
# PA Colors
# plain for generic text, bold for titles, reset flag at each end of line
# plain blue should not be used for readability reasons - use plain cyan instead
CLR_RST=$(tput sgr0)                        ## reset flag
CLR_RED=$CLR_RST$(tput setaf 1)             #  red, plain
CLR_GRN=$CLR_RST$(tput setaf 2)             #  green, plain
CLR_YLW=$CLR_RST$(tput setaf 3)             #  yellow, plain
CLR_BLU=$CLR_RST$(tput setaf 4)             #  blue, plain
CLR_PPL=$CLR_RST$(tput setaf 5)             #  purple,plain
CLR_CYA=$CLR_RST$(tput setaf 6)             #  cyan, plain
CLR_BLD=$(tput bold)                        ## bold flag
CLR_BLD_RED=$CLR_RST$CLR_BLD$(tput setaf 1) #  red, bold
CLR_BLD_GRN=$CLR_RST$CLR_BLD$(tput setaf 2) #  green, bold
CLR_BLD_YLW=$CLR_RST$CLR_BLD$(tput setaf 3) #  yellow, bold
CLR_BLD_BLU=$CLR_RST$CLR_BLD$(tput setaf 4) #  blue, bold
CLR_BLD_PPL=$CLR_RST$CLR_BLD$(tput setaf 5) #  purple, bold
CLR_BLD_CYA=$CLR_RST$CLR_BLD$(tput setaf 6) #  cyan, bold

BUILD_START=$(date +"%s")
DATE=$(date -u +%Y%m%d-%H%M)
VERSION=1.0
NR_VENDOR=vendor/nusantara
NR_WORK=$OUT
NR_WORK_DIR=$OUT/zip
RECOVERY_IMG=$OUT/recovery.img
NR_DEVICE=$(cut -d'_' -f2-3 <<<$TARGET_PRODUCT)

if [ "$NR_OFFICIAL_CH" != "true" ]; then
	NR_BUILD_TYPE=UNOFFICIAL
else
	NR_BUILD_TYPE=OFFICIAL
fi

function search() {
for d in $(curl -s https://raw.githubusercontent.com/NusantaraRecovery/nr_vendor/nr/nr.devices); do
if [ "$d" == "$NR_DEVICE" ]; then
echo "$d";
break;
fi
done
}

if [ "$NR_BUILD_TYPE" != "UNOFFICIAL" ]; then
	F=$(search);
	if [[ "${F}" ]]; then
		NR_BUILD_TYPE=OFFICIAL
	else
		NR_BUILD_TYPE=UNOFFICIAL
	fi
fi

ZIP_NAME=NR-$NR_DEVICE-$VERSION-$DATE-$NR_BUILD_TYPE

echo -e "${CLR_BLD_RED}**** Making Zip ****${CLR_RST}"
if [ -d "$NR_WORK_DIR" ]; then
        rm -rf "$NR_WORK_DIR"
	rm -rf "$NR_WORK"/*.zip
fi

if [ ! -d "NR_WORK_DIR" ]; then
        mkdir "$NR_WORK_DIR"
fi

echo -e "${CLR_BLD_BLU}**** Copying Tools ****${CLR_RST}"
cp -R "$NR_VENDOR/Nusantara" "$NR_WORK_DIR"
echo -e "${CLR_BLD_BLU}- Copying Tools Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_GRN}**** Copying Updater Scripts ****${CLR_RST}"
mkdir -p "$NR_WORK_DIR/META-INF/com/google/android"
cp -R "$NR_VENDOR/updater/"* "$NR_WORK_DIR/META-INF/com/google/android/"
echo -e "${CLR_BLD_GRN}- Copying Updater Scripts Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_CYA}**** Copying Recovery Image ****${CLR_RST}"
mkdir -p "$NR_WORK_DIR/TWRP"
cp "$RECOVERY_IMG" "$NR_WORK_DIR/TWRP/"
echo -e "${CLR_BLD_CYA}- Copying Recovery Image Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_PPL}**** Compressing Files into ZIP ****${CLR_RST}"
cd $NR_WORK_DIR
zip -r ${ZIP_NAME}.zip *
BUILD_RESULT_STRING="BUILD SUCCESSFUL"
echo -e "${CLR_BLD_PPL}- Compressing Zip Done...${CLR_RST}"
echo -e ""
echo -e "${CLR_BLD_RED}  ███╗   ██╗██╗   ██╗███████╗ █████╗ ███╗   ██╗████████╗ █████╗ ██████╗  █████╗   ${CLR_RST}"
echo -e "${CLR_BLD_RED}  ████╗  ██║██║   ██║██╔════╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗  ${CLR_RST}"
echo -e "${CLR_BLD_RED}  ██╔██╗ ██║██║   ██║███████╗███████║██╔██╗ ██║   ██║   ███████║██████╔╝███████║  ${CLR_RST}"
echo -e "${CLR_BLD_RED}  ██║╚██╗██║██║   ██║╚════██║██╔══██║██║╚██╗██║   ██║   ██╔══██║██╔══██╗██╔══██║  ${CLR_RST}"
echo -e "${CLR_BLD_RED}  ██║ ╚████║╚██████╔╝███████║██║  ██║██║ ╚████║   ██║   ██║  ██║██║  ██║██║  ██║  ${CLR_RST}"
echo -e "${CLR_BLD_RED}  ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ${CLR_RST}"
echo -e "${CLR_BLD_RED}    ██████╗  ███████╗  ██████╗  ██████╗  ██╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ${CLR_RST}"
echo -e "${CLR_BLD_BLU}    ██╔══██╗ ██╔════╝ ██╔════╝ ██╔═══██╗ ██║   ██║ ██╔════╝ ██╔══██╗ ╚██╗ ██╔╝ ${CLR_RST}"
echo -e "${CLR_BLD_GRN}    ██████╔╝ █████╗   ██║      ██║   ██║ ██║   ██║ █████╗   ██████╔╝  ╚████╔╝  ${CLR_RST}"
echo -e "${CLR_BLD_PPL}    ██╔══██╗ ██╔══╝   ██║      ██║   ██║ ╚██╗ ██╔╝ ██╔══╝   ██╔══██╗   ╚██╔╝   ${CLR_RST}"
echo -e "${CLR_BLD_CYA}    ██║  ██║ ███████╗ ╚██████╗ ╚██████╔╝  ╚████╔╝  ███████╗ ██║  ██║    ██║    ${CLR_RST}"
echo -e "${CLR_BLD_YLW}    ╚═╝  ╚═╝ ╚══════╝  ╚═════╝  ╚═════╝    ╚═══╝   ╚══════╝ ╚═╝  ╚═╝    ╚═╝    ${CLR_RST}"
echo -e ""
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
if [[ "${BUILD_RESULT_STRING}" = "BUILD SUCCESSFUL" ]]; then
mv ${NR_WORK_DIR}/${ZIP_NAME}.zip ${NR_WORK_DIR}/../${ZIP_NAME}.zip
echo -e "${CLR_BLD_CYA}****************************************************************************************${CLR_RST}"
echo -e "${CLR_BLD_RED}*${CLR_RST}${CLR_BLD_RED} ${BUILD_RESULT_STRING}${CLR_RST}"
echo -e "${CLR_BLD_GRN}*${CLR_RST}${CLR_BLD_GRN} RECOVERY LOCATION: ${OUT}/recovery.img${CLR_RST}"
echo -e "${CLR_BLD_YLW}*${CLR_RST}${CLR_BLD_YLW} RECOVERY SIZE: $( du -h ${OUT}/recovery.img | awk '{print $1}' )${CLR_RST}"
echo -e "${CLR_BLD_PPL}*${CLR_RST}${CLR_BLD_PPL} ZIP LOCATION: ${NR_WORK}/${ZIP_NAME}.zip${CLR_RST}"
echo -e "${CLR_BLD_RED}*${CLR_RST}${CLR_BLD_RED} ZIP SIZE: $( du -h ${NR_WORK}/${ZIP_NAME}.zip | awk '{print $1}' )${CLR_RST}"
echo -e "${CLR_BLD_CYA}****************************************************************************************${CLR_RST}"
fi
