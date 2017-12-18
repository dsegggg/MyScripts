##!/bin/bash
#- < env-wp01-single > ---------------------------------------------------#
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

pause(){
echo -e "...\n";read -rsn1 -p"Press any key to continue . . .";echo
}

SQL_ROOT='admin'
SQL_ROOTPW='Admin'

WP_DBHOST='localhost'
WP_DBNAME='wp1single'
WP_DBUSR='wp1single'
WP_DBPAS='wp1single-pass'
WP_OSUSR='wpress'
WP_DBPREFIX='g1_'
WP_COLATE='utf8_unicode_ci'

WP_BASE='/srv/www/html/single'
WP_LOG='/srv/www/html/logs/single'
WP_SUB='w1s'
WP_INST=${WP_BASE}
# /${WP_SUB}
WP_URL='wp01.example.com'
WP_TITLE='TEST_Single'
#-----------------------------------------------#
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

WP_USER2='User1'
WP_USER2_PASS='User2.pass'
WP_USER2_EMAIL='User1@example.com'
WP_USER2_DISPLAY='User2'

WP_CF_EXTRA_PHP=$(cat<< END_EXTRA_PHP
##= Start extra PHP vars  =======#
#
define( 'WP_HOME', 'https://${WP_URL}' );
define( 'WP_SITEURL', 'https://${WP_URL}' );
# DOMAINSITEURL
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
# @ini_set( 'error_log', '/srv/www/html/logs/php_error.log' );
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
#====  END env-wp01-single.sh  ====================
