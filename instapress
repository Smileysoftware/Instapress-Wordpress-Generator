##################################################
##
## Welcome to InstaPress
##
## Setup some variables
##
## The root folder name
baseFolder="sites/"
themeName="elem"

testMode=true

##################################################

clear

echo "Welcome to InstaPress"
echo "One stop show for a Wordpress installation on Vagrant"
echo ""
echo "Vagrant and VirtualBox must be installed"
echo ""
echo ""
echo "The site will be configured in ~/sites/whatever you want"
echo ""

#Find out what the site should be called
echo "Please enter the name of your site (Lowercase no spaces)"
read -p "Site Name:  (Default = InstaPress) " siteName
#Set the default site name to Elemental
siteName=${siteName:-InstaPress}

##Convert the site name to lower case
siteName="$( echo $siteName | awk '{print tolower($0)}')"
##Convert the string to remove spaces and replace with -'s
siteName="$( echo ${siteName// /-})"


#Get the name of the theme to be created.
read -p "Theme Name: (Default = InstaPress) " themeName
#Set the default site name to Elemental
themeName=${themeName:-InstaPress}

##Convert the site name to lower case
themeNameLower="$( echo $themeName | awk '{print tolower($0)}')"
##Convert the string to remove spaces and replace with -'s
themeNameLower="$( echo ${themeNameLower// /-})"

##Does the user want the ninja forms plugin?
read -p "Install the Ninja Forms plugin? Type 'no' or just hit enter to install " pluginNinjaForms
pluginNinjaForms=${pluginNinjaForms:-yes}

##Does the user want the responsive menu plugin?
read -p "Install the Responsive Menu plugin? Type 'no' or just hit enter to install " pluginResponsiveMenu
pluginResponsiveMenu=${pluginResponsiveMenu:-yes}

##Does the user want the user role editor plugin?
read -p "Install the User Role Editor plugin? Type 'no' or just hit enter to install " pluginUserRoleEditor
pluginUserRoleEditor=${pluginUserRoleEditor:-yes}

##Does the user want the Multiple Content Blocks plugin?
read -p "Install the Multiple Content Blocks plugin? Type 'no' or just hit enter to install " pluginMCB
pluginMCB=${pluginMCB:-yes}

##Does the user want the Advanced Custom Fields plugin?
read -p "Install the Advanced Custom Fields plugin? Type 'no' or just hit enter to install " pluginACF
pluginACF=${pluginACF:-yes}

##Ask if were allowed to remove hello dolly?
read -p "Remove the Hello Dolly plugin? Type 'no' to keep or just hit enter to remove " pluginDolly
pluginDolly=${pluginDolly:-yes}



## Jump to the users home folder.
cd ~

## Test to see if the folder exists.
if [ -d "$baseFolder$siteName" ]; then
  echo "Whao, That folder already exists"
  # Remove the folder FOR TESTING

  if [ testMode ]; then

    echo "But, this is test mode so. Onwards!"

    cd "$baseFolder$siteName"
    vagrant halt
    vagrant destroy
    cd ../../
    rm -rf $baseFolder$siteName

  else
  
  	exit  

  fi

fi

echo "The website will be created in" $baseFolder$siteName

# Create the folder
mkdir -p "$baseFolder$siteName"

# Move into that folder
cd "$baseFolder$siteName"


#Clone down the Scotch box repo
git clone https://github.com/scotch-io/scotch-box.git .

## Clean up the remotes
git remote rm origin

## Bring the box up
vagrant up

## Remove the old git and gitignore
rm  -rf .git
rm .gitignore

echo ""
echo "Vagrant box running"

echo ""
echo "Begin Wordpress installation"
echo ""

##Move to the public folder
cd public

## Curl down the CLI tool
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

## Download Wordpress
php wp-cli.phar core download

# Install Wordpress
vagrant ssh -- 'cd /var/www/public

php wp-cli.phar core config --dbname=scotchbox --dbuser=root --dbpass=root'

vagrant ssh -- "cd /var/www/public

php wp-cli.phar core install --url=$siteName.dev --title=$siteName --admin_user=admin --admin_password=letmein --admin_email=lyleyboy@gmail.com"

echo ""
echo "Wordpress installation complete"
echo ""


##Lets build a new theme
cd wp-content/themes/
mkdir $themeNameLower
cd $themeNameLower

echo "/*
Theme Name: $themeName
Theme URI: http://
Author: Lyle Barras
Author URI: http://theelementalweb.com
Description: A cool theme created by InstaPress
Version: 1.0
License: GNU General Public License v2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html
*/" > style.css

echo "<?php
echo 'Hello World';" > index.php

echo ""
echo "New theme created"
echo ""

vagrant ssh -- "cd /var/www/public

php wp-cli.phar theme activate $themeNameLower"

echo ""
echo "New theme enabled"
echo ""

echo "Install plugins"
echo ""

#If the user chose to install the ninja forms plugin
if [ $pluginNinjaForms = "yes" ]; then
  echo ""
  echo "Ninja Forms will be installed"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin install ninja-forms --activate"
fi

#If the user chose to install the responsive menu plugin
if [ $pluginResponsiveMenu = "yes" ]; then
  echo ""
  echo "Responsive Menu will be installed"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin install responsive-menu --activate"
fi

#If the user chose to install the user role editor
if [ $pluginUserRoleEditor = "yes" ]; then
  echo ""
  echo "User Role Editor will be installed"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin install user-role-editor --activate"
fi

#If the user chose to install the multiple content blocks
if [ $pluginMCB = "yes" ]; then
  echo ""
  echo "Multiple Content Blocks will be installed"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin install multiple-content-blocks --activate"
fi

#If the user chose to install the Advanced Custom Fields
if [ $pluginMCB = "yes" ]; then
  echo ""
  echo "Advanced Custom Fields will be installed"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin install advanced-custom-fields --activate"
fi

#Can we remove the hello dolly plugin?
if [ $pluginDolly = "yes" ]; then
  echo ""
  echo "Removing the Hello Dolly plugin"
  echo ""
  vagrant ssh -- "cd /var/www/public
  php wp-cli.phar plugin delete hello"
fi


##Move up the file structure to create the git shit
cd ../../

##Build a .gitignore file
echo ".idea
.DS_STORE
.vagrant
node_modules/
.sass-cache
*.sql
" > .gitignore

## Build a basic git repo
git init
git config --global user.name "Lyle Barras"
git config --global user.email lyle.barras@barrasweb.co.uk
git config --global core.editor nano

git add .
git commit -m "Initial commit using InstaPress"






## Final step is to add a hosts file.
sudo sh -c "echo '192.168.33.10' $siteName.dev >> /etc/hosts" 

## Open the two tabs with the site and the admin
open http://$siteName.dev
open http://$siteName.dev/wp-admin