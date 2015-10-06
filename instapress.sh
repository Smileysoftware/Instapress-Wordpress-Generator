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
##
##################################################



# echo "$(whoami)"
# finger $(whoami) | awk '/Name:/ {print $4" "$5}'



clear

echo "Welcome to InstaPress"
echo "One stop show for a Wordpress installation on Vagrant"
echo ""
echo "Vagrant and VirtualBox must be installed"
echo ""
echo ""
echo "The site will be configured in ~/sites/whatever you want"



#Find out what the site should be called
echo "Please enter the name of your site (Lowercase no spaces):"
read -p "Site Name: " siteName
#Set the default site name to Elemental
siteName=${siteName:-Elemental}

##Convert the site name to lower case
siteName="$( echo $siteName | awk '{print tolower($0)}')"
##Convert the string to remove spaces and replace with -'s
siteName="$( echo ${siteName// /-})"


#Get the name of the theme to be created.
read -p "Theme Name: " themeName
#Set the default site name to Elemental
themeName=${themeName:-Elemental}

##Convert the site name to lower case
themeNameLower="$( echo $themeName | awk '{print tolower($0)}')"
##Convert the string to remove spaces and replace with -'s
themeNameLower="$( echo ${themeNameLower// /-})"











## Jump to the users home folder.
cd ~

## Test to see if the folder exists.
if [ -d "$baseFolder$siteName" ]; then
  echo "Whao, That folder already exists"
  # Remove the folder FOR TESTING

  if [ testMode ]; then

    echo "But, this is test mode so. Onwards!"

    vagrant halt
    vagrant destroy
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

echo ""
echo "Vagrant box running"

echo ""
echo "Begin Wordpress installation"
echo ""

##Move to the public folder
cd public

##Start a git repo
git init

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

vagrant ssh -- "cd /var/www/public
php wp-cli.phar plugin install ninja-forms --activate"

vagrant ssh -- "cd /var/www/public
php wp-cli.phar plugin install responsive-menu --activate"

vagrant ssh -- "cd /var/www/public
php wp-cli.phar plugin install user-role-editor --activate"



##Build a .gitignore file
echo ".idea
.DS_STORE
.vagrant
node_modules/
.sass-cache
*.sql
" > .gitignore

## Build a basic git repo
git config --global user.name "Lyle Barras"
git config --global user.email lyle.barras@barrasweb.co.uk
git config --global core.editor nano

git add .
git commit -m "Initial commit using InstaPress"






## Final step is to add a hosts file.
# echo "192.168.33.10    $siteName.dev" | pbcopy
# sudo nano /etc/hosts

sudo sh -c "echo '192.168.33.10' $siteName.dev >> /etc/hosts" 

open http://$siteName.dev
open http://$siteName.dev/wp-admin