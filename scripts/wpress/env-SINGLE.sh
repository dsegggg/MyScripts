##!/bin/bash
#- <  .env-SINGLE.sh > -----------------------------------------------#
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
# Source Load environment in SINGLE_inst.sh #.  ./.env-SINGLE.sh

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
WP_OSUSR='osuser01'
WP_DBPREFIX='wp_'
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
