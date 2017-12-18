#!/bin/bash
# echo $0
#---------------------------------
# name: dmpdb.sh
# Function: 
#    1.a) dump wpress ( only 1 user ) database, 
#    1.b) make db load procedure.
#  X 2.   bkup wpress web folder in two parts: p1): wp-content only, p2): all the rest separately,
#  X 3.   bkup user wpres(?)  home wrk folder
#      All this in ( /home/BK ) / (TODAY) / (NOW) /  Folder
#
# Last change: 2017-12-15_11:38
#---------------------------------
#
#== Declare funcs: ----
# 1. pause
#---------------------
function pause(){
    echo -e "...\n";read -rsn1 -p"Press any key to continue . . .";echo
}
#-- End Declare   ----
#___________________________________

#___ single DB_USERS ___________________
#             
SQL_ROOT='mysqlmaster'
SQL_ROOTPW='My.Sql.Master.Pass'
WP_DBNAME='db-single'
WP_DBUSR='usr-single'
WP_DBPAS='..........'
WP_OSUSR='wpress'
WP_BASE='/srv/www/html/single'
##
#_____________________________________


# what ?
WP_WWW="${WP_BASE}"
# where ?
BK_DST='./DbDmp'
# who ?

# when ?
NOW=$(date +"%Y%m%d-%H%M")
TODAY=$(date +"%Y%m%d-%a")
#
#___ DB DUMP vars: ____________________
BK_DIR="${BK_DST}/${TODAY}/${NOW}"

DB_ADM_USR="$SQL_ROOT"
DB_ADM_PAS="$SQL_ROOTPW"

DB_USR="${WP_DBUSR}"
DB_PASS="${WP_DBPAS}"              
#DB_NAME=''
DB_BASE="${WP_DBNAME}"

DST_PATH="${BK_DIR}"
JOB_ID_SFX="${DB_USR}_${HOSTNAME}_${DB_BASE}_${NOW}_"

SQL_DMP_FILE="DBdmp_${JOB_ID_SFX}_.sql"
WP_CONT_FILE="wp_content_${JOB_ID_SFX}_.tar"
WP_WWW_FILE="wp_www_${JOB_ID_SFX}_.tar"
WP_HOME_FILE="wp_home_${JOB_ID_SFX}_.tar"

DMP_DEST="${DST_PATH}/${SQL_DMP_FILE}"
WP_CONT_DEST="${DST_PATH}/${WP_CONT_FILE}"
WP_WWW_DEST="${DST_PATH}/${WP_WWW_FILE}"
LOG_F="${DST_PATH}/job_${JOB_ID_SFX}_.log"
WP_HOME_DEST="${DST_PATH}/${WP_HOME_FILE}"

BZIP_CMD='bzip2 -zqs8 '
BUNZIP_CMD='bzip2 -d '
#___________________________________________

mkdir -p ${DST_PATH}

touch ${LOG_F}
touch ${WP_CONT_DEST}
# touch ${WP_WWW_DEST}
touch ${DMP_DEST}

chmod 0770 ${DST_PATH}
# chown -R wpress:wpress ${DST_PATH}

# copy myself to bkup folder 
cp $0 ${DST_PATH}

#------------------------------
# 1.a) RUN grc DB DUMP:
mysqldump -u ${DB_USR} --password="${DB_PASS}"  ${DB_BASE}  -R -e --triggers --single-transaction > ${DMP_DEST}  2>>${LOG_F}
# bzip db_dump 
# bzip2 -zqs6 ${DMP_DEST}
${BZIP_CMD} ${DMP_DEST} 2>>${LOG_F}

#------------------------------
# 2.1) tar & bzip  wpress 1.content and 2.www BKUP
WP_TAR_CONT="${WP_WWW}/.htaccess ${WP_WWW}/wp-config.php ${WP_WWW}/wp-content"
#
tar cf ${WP_CONT_DEST} ${WP_TAR_CONT} 2>>${LOG_F}
${BZIP_CMD} ${WP_CONT_DEST}  2>>${LOG_F}

# 2.2) wpress www NO wp-content
# tar c --exclude='wp-content' -f ${WP_WWW_DEST} ${WP_WWW}  2>>${LOG_F}
# ${BZIP_CMD} ${WP_WWW_DEST}   2>>${LOG_F}
#________________________________________________
# 3. bkup wpress user home
# tar c -f ${WP_HOME_DEST}  "/home/wpress"  2>>${LOG_F}
# ${BZIP_CMD} ${WP_HOME_DEST}   2>>${LOG_F}

chown -R wpress:wpress ${DST_PATH}

# find ${DST_PATH} -type f -exec chmod 0640 {} +
# find ${DST_PATH} -type d -exec chmod 0750 {} +

# 1.b) make db load script in BK_DIR location
LoadDbDmpFileName="LoadThisDmp_${JOB_ID_SFX}_.sh"
DestForLoadFile=${DST_PATH}/${LoadDbDmpFileName}
LoadSourceVar=$(cat << _END_Load_Source_
#!/bin/bash

echo -e "BUnzip file ..\n"
# bzip2 -d ${SQL_DMP_FILE}.bz2
${BUNZIP_CMD} ${SQL_DMP_FILE}.bz2 
echo -e "Unzip done. Loading ..... \n"
mysql -u ${DB_USR} --password="${DB_PASS}" ${DB_BASE} < ./${SQL_DMP_FILE}

_END_Load_Source_
)
#__
touch "${DestForLoadFile}"
echo "${LoadSourceVar}" >  ${DestForLoadFile}
chmod 0700  ${DestForLoadFile}

# [ -z "$PS1" ]
if tty -s; 
then 
    echo -e "\n Wpress BKUP done in : ${BK_DIR}\n"
    echo -e "\n#- Files: \n"
    ls -lasthR ${BK_DIR}
    echo -e "#====================================================================================#"
    echo -e "#====================================================================================#"
    echo -e "#=== Script to Load This dump is: ${LoadDbDmpFileName}  =========================#"
    echo -e "#=== ${NOW} BKUP DONE ===============================================================#"
    echo -e "#====================================================================================#"
    pause
else return
fi
#END KRAJ THE_END
