#!/bin/bash

#--< SINGLE.sh >--------------------------------------------------#
#=
#= install wordpress single instance + mysql DB instance for wp user
#= 
#=  PRE-REQUISITES:
#=  0. mysql set up: 1 master user, some dbowner users
#=  1. apache must be configured properly ( rewrite, .htaccess )
#=  2. virtual hosting names must be set up under: /srv/www/html/<NAME>
#=  3.  
#=  4.     
#=      
#---------------------------------------------------------------------#
# source ./.SINGLE-env.sh
# exit
##!/bin/bash
#- < env-SINGLE > ---------------------------------------------------#
#=
#= install wordpress single env
#= 
#=  PRE-REQUISITES:
#=  0. mysql set up: 1 master user, some dbowner users
#=  1. apache must be configured properly ( rewrite, .htaccess )
#=  2. virtual hosting names must be set up under: /srv/www/html/<NAME>
#=  3.  
#=  4.     
#=      
#---------------------------------------------------------------------#
# Source Load environment in XXX_inst.sh #.  ./env-XXX.sh

pause () { echo -e "...\n";read -rsn1 -p"Press any key to continue . . .";echo; }
#_____________________________________________#

# { SINGLE,MULTIDOM }
MODE='SINGLE'    
#_____________________________________________#

#-- DB params ------------------------------#
SQL_ROOT='sqldbadmin'
SQL_ROOTPW='SqlDbAdmin'
WP_DBHOST='localhost'
WP_DBNAME='wp1single'
WP_DBUSR='wp1single'
WP_DBPAS='Wp1Single.Pass'
WP_OSUSR='dsegovic'
WP_DBPREFIX='g1_'
WP_COLATE='utf8_unicode_ci'

#== WP Folders  ==#
WP_BASE='/var/www/html'
WP_LOG='/var/www/logs/single'
WP_SUB='w1s'
WP_URL='nuc'
WP_TITLE='TEST_Single'

#-- Wp admin(s) --------------------------------#
WP_ADM_USER='admin0'
WP_ADM_PASS='Admin0.pass'
WP_ADM_EMAIL='admin0@example.com'
WP_ADM0_DISPLAY='Super_0_Admin'

WP_ADM1_USER='admin1'
WP_ADM1_PASS='Admin1.pass'
WP_ADM1_EMAIL='admin1@example.com'
WP_ADM1_DISPLAY='Super_1_Admin'

WP_USER1='user1'
WP_USER1_PASS='User1.pass'
WP_USER1_EMAIL='User1.pass'
WP_USER1_DISPLAY='User1'

#WP_USER2='User1'
#WP_USER2_PASS='User2.pass'
#WP_USER2_EMAIL='User1@example.com'
#WP_USER2_DISPLAY='User2'

WP_INST=${WP_BASE}

#== wp-config.php params: =========================#
WP_CF_EXTRA_PHP=$(cat<< END_EXTRA_PHP
##= Start extra PHP vars  =======#
#
define( 'WP_HOME', 'http://${WP_URL}' );
define( 'WP_SITEURL', 'http://${WP_URL}' );
# define( 'WP_HOME', 'https://' . $_SERVER['SERVER_NAME'] . '/' );
# define( 'WP_SITEURL', 'https://' . $_SERVER['SERVER_NAME'] . '/' );
define( 'WP_POST_REVISIONS', false );
# define( 'NOBLOGREDIRECT', 'https://${WP_URL}');
#
##= Start extra PHP vars  =======#
# define('FORCE_SSL_ADMIN', true);
# define('FORCE_SSL_LOGIN', true);
define( 'WP_MEMORY_LIMIT', '128M' );
#define('FTP_HOST','127.0.0.1:22');
#define('FTP_USER','wpress');
#define('FTP_PASS','');
define( 'FS_METHOD', 'direct' );
# define('WP_DEBUG', false);
define( 'WP_DEBUG', true );
# define('WP_DEBUG_LOG', false);
define( 'WP_DEBUG_LOG', true );
# define('WP_DEBUG_DISPLAY', false);
define( 'WP_DEBUG_DISPLAY', true );
@ini_set( 'display_errors', 1 );
# erlog file !!
@ini_set( 'error_log', "${WP_LOG}/php_error.log" );
#---------------------------------------#
# define( 'COOKIE_DOMAIN', $_SERVER[ 'HTTP_HOST' ] );
# define( 'COOKIEPATH', preg_replace( '|https?://[^/]+|i', '', get_option( 'home' ) . '/' ) );
# define( 'SITECOOKIEPATH', preg_replace( '|https?://[^/]+|i', '', get_option( 'siteurl' ) . '/' ) );
# define( 'ADMIN_COOKIE_PATH', SITECOOKIEPATH . 'wp-admin' );
# define( 'PLUGINS_COOKIE_PATH', preg_replace( '|https?://[^/]+|i', '', WP_PLUGIN_URL ) );
# !!! END COOOKIEEES !!!!
#---------------------------------------#
# define('FS_CHMOD_DIR',0775);
# define('FS_CHMOD_FILE',0664);
# define('WP_TEMP_DIR',dirname(__FILE__).'/wp-content/tmp');
# -> Redirect Loop solve !!!
# define('ADMIN_COOKIE_PATH', '/');
# define( 'COOKIE_DOMAIN', '' );
# define('COOKIEPATH', '');
# define('SITECOOKIEPATH', '');
#= End extra PHP vars ============#
END_EXTRA_PHP
)
#========================================================#
#====  END env-SINGLE.sh  ===========================-EOF-#
#__________________________________________

# remember initial workig folder
WP_WRK=`pwd`
echo -e "Work folder: ${WP_WRK} \n"
# echo -e "WPBASE:${WP_BASE}, SUB:${WP_SUB}"
echo -e "WPINST:${WP_INST}\n"
# echo -e "\nNow, delete existing wp ...!! \n\n"
# pause

# echo -e "Delete/create  $WP_BASE/$WP_SUB ..\n"
mkdir -p ${WP_BASE}/${WP_SUB}
rm -rf ${WP_BASE}/${WP_SUB} 
# rm -f ${WP_BASE}/.htaccess

mkdir -p ${WP_INST}/wp-content/tmp
mkdir -p ${WP_INST}/wp-content/uploads
mkdir -p ${WP_LOG}

# pause
echo -e "\n# Create wp-cli.local \n"
WP_CLI='wp-cli.local.yml'

cat >$WP_CLI<<CONTENT_Wp_Cli
#======================================#
## Global parameter defaults for wp-cli
#======================================#
# wp-cli.local.yml
##=====================================#
path: ${WP_INST}

CONTENT_Wp_Cli
#-------------------

#========================================================#
echo -e "\n Make sqlproc for: DROP & RECREATE DB and USER \n"
# file: mk-db-user.sql
MkUFile='mk-db-usr.sql'
touch "$MkUFile.lck"
#=========================================================#

MkDbUsr_v=$(cat << WP_MK_DBSQL
DROP   DATABASE IF EXISTS $WP_DBNAME;
CREATE DATABASE IF NOT EXISTS $WP_DBNAME DEFAULT CHARACTER SET = utf8 DEFAULT COLLATE = utf8_unicode_ci;
DROP USER IF EXISTS '$WP_DBUSR'@'localhost';
CREATE USER '$WP_DBUSR'@'localhost' IDENTIFIED BY '$WP_DBPAS';
GRANT ALL PRIVILEGES ON $WP_DBNAME.* TO '$WP_DBUSR'@'localhost';
WP_MK_DBSQL
)
#===========================================================#
echo "$MkDbUsr_v" >$MkUFile 

cat $MkUFile
# echo -e "\n\nAnd now exec this sql: "
# pause
echo -e "\n Run sqlproc for: RECREATE DB & USER ... \n"
mysql -u $SQL_ROOT --password="$SQL_ROOTPW" < $MkUFile  
echo -e "\nDB OK, now make wordpress !\n"
pause
#========================================================#
#= wp
#=  
# WP_SUB=''

#wp core download  --locale=en_GB  --version=latest --force  --path=${WP_INST}
wp core download  --locale=en_US  --version='4.8.3' --force  --path=${WP_INST}

wp config create  --dbhost=${WP_DBHOST}   --dbname=${WP_DBNAME}      --dbuser=${WP_DBUSR} \
       	--dbpass=${WP_DBPAS}            --dbprefix=${WP_DBPREFIX} --dbcollate=${WP_COLATE}  \
          --path=${WP_INST}           --extra-php="${WP_CF_EXTRA_PHP}"
# --force 

echo -e "wp-config created, check .."
pause
#===================================================================#
#    
# wp core multisite-install --url=${WP_URL}                --title=${WP_TITLE} \
wp core install           --url=${WP_URL}                --title=${WP_TITLE} \
                   --admin_user=${WP_ADM_USER}  --admin_password=${WP_ADM_PASS} \
                  --admin_email=${WP_ADM_EMAIL}           --path=${WP_INST} \
#                  --subdomains
#echo -e " wp multi installed, check ..\n"

pause
#===================================================================#

#= create two .htaccess files 1st for WP_BASE, 2nd for multisite in SUB
#- 1st
HTAC_TOP=$(cat<<TOP_HTAccess
# wp multi domain top folder .htaccess
# START  WORDPRESS
# -- password protect the whole site ------------------------#
#    AuthBasicAuthoritative On
#    AuthType Basic
#    AuthName ". . . . Restricted !! . . . .  "
#    AuthUserFile /srv/www/html/.secret/.htpassfile
#    require valid-user
#------------------------------------------------#
# FORBID ANY .ht* files
    <Files .ht*>
    Order Allow,Deny
    Deny from all
    </Files>
<IfModule mod_rewrite.c>

    RewriteEngine On
#-- Force ssl --------------
#     RewriteCond %{HTTPS} !=on
#     RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
    RewriteBase /
    RewriteRule ^index\.php$ - [L]

    # add a trailing slash to /wp-admin
    RewriteRule ^wp-admin$ wp-admin/ [R=301,L]

    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]
    RewriteRule ^(wp-(content|admin|includes).*) \$1 [L]
    RewriteRule ^(.*\.php)$ \$1 [L]
    RewriteRule . index.php [L]

</IfModule>
# END WORDPRESS

TOP_HTAccess
)
#--- write out :
#echo "$HTAC_TOP" > ${WP_INST}/.htaccess
echo "$HTAC_TOP" > ${WP_INST}/top.htaccess
#---
# mkdir -p ${WP_BASE}/${WP_SUB}
# 2nd
HTAC_SUB_MULTI=$(cat<<SUB_HTAccess
# wp subfolder ? .htaccecc
# Begin WORDPRESS
<IfModule mod_rewrite.c>

RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]

# add a trailing slash to /wp-admin
RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ $1wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(wp-(content|admin|includes).*) \$1 [L]
RewriteRule ^([_0-9a-zA-Z-]+/)?(.*\.php)$ $1 [L]
RewriteRule . index.php [L]

</IfModule>
# End WordPress
SUB_HTAccess
)
#---
# !!!!!!  write out   !!!!!!!!!!!!!!!!!!!
#echo -e "$HTAC_SUB_MULTI" >  ${WP_BASE}/${WP_SUB}/.htaccess
#echo -e "$HTAC_SUB_MULTI" >  ${WP_INST}/dom.htaccess
#echo -e "\n Check .HTACCESS files!!!!! \n" 
#pause  
#========================================================================#

if [ "${WP_ADM1_USER:-}" ]; then
echo -e "\n#=== Create aditional admin user with passwd .=================# \n"
#= 2
    wp user create ${WP_ADM1_USER} ${WP_ADM1_EMAIL}  --role=administrator  --porcelain
    wp user update ${WP_ADM1_USER}  --display=${WP_ADM1_DISPLAY}    --user_pass=${WP_ADM1_PASS}  
    #wp super-admin add ${WP_ADM1_USER} 
fi

if [ "${WP_USER1:-}" ]; then
    wp user create ${WP_USER1}  "{WP_USER1_EMAIL}"    --role=administrator  --porcelain
    wp user update ${WP_USER1} --display=${WP_USER1_DISPLAY}  --user_pass="${WP_USER1_PASS}"
fi
if [ "${WP_USER2:-}" ]; then
    wp user create ${WP_USER2}  "{WP_USER2_EMAIL}"    --role=administrator  --porcelain
    wp user update ${WP_USER2} --display=${WP_USER2_DISPLAY}  --user_pass="${WP_USER2_PASS}"
fi
#=============================================================================#

#=== Options ... ??? =====================================#
#
echo -e "Set some wp options: \n" 
# pause
wp rewrite structure '/%year%/%postname%'  --hard
# wp rewrite structure '/%postname%'  --hard
#
wp option set home "http://${WP_URL}"
wp option set url  "http://${WP_URL}"
wp option set siteurl "http://${WP_URL}"
#
wp option set blogdescription "${WP_TITLE}"
wp option set timezone_string 'Europe/Zagreb'
wp option set date_format 'Y-m-d'
wp option set time_format 'H:i'
#==========================================
echo -e " TO DO :\n"
echo -e " - ?? OK . check .htaccess \n"
echo -e " - Try to Login as super, go to MySites-NetworkAdmin-Settings-Network Settings: \n"
echo -e " !! NOT OK-3. check .htaccess for  for multisite\n"
echo -e " -. Allow new registrations - Logged in users may register new sites. \n"
echo -e " -. Add New Users - Allow site administrators to add new users to their site.\n"
echo -e " -. Enable administration menus + Plugins  \n"
echo -a " -. Load plugins: run <a-plug.sh>\n"
echo -e "!!-. setup user plugin privileges \n" 
echo -e " -.!!! ? create  main index page !!! \n"
WpPR_F_Name='root_wppriv.sh'
WpPrivs_Var=$(cat << 'WPRIVS_Content'
#!/bin/bash
#----------------------
# run as root !!
#----------------------
# cd ${WP_INST}
chown -R wpress:www-data .
# chown  wpress:www-data wp-config.php
# chown  wpress:www-data .htaccess
find . -type f -exec chmod 644 {} +
find . -type d -exec chmod 755 {} +
# chmod 660 wp-config.php
# chmod 660 .htaccess
#
WPRIVS_Content
)
#=============================================
echo -e "$WpPrivs_Var" > ${WP_BASE}/${WpPR_F_Name}

rm *.lck
echo -e "\n -. run as root: ${WpPR_F_Name} ...\n"
echo -e "??  ~Finished !! .. ?? \n"
#- END --#
