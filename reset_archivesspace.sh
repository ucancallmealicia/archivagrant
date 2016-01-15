#!/usr/bin/env bash

echo "Stopping ArchivesSpace"
service archivesspace stop

echo "Dropping and recreating database"
mysql -uroot -prootpwd -e "drop database archivesspace"
mysql -uroot -prootpwd -e "create database archivesspace"
mysql -uroot -prootpwd -e "grant all on archivesspace.* to 'as'@'localhost' identified by 'as123'"

echo "Deleting indexer state"
cd /home/vagrant/archivesspace/data
rm -rf indexer_state
rm -rf solr_backups
rm -rf solr_index

echo "Setting up database"
cd /home/vagrant/archivesspace
scripts/setup-database.sh

echo "Starting ArchivesSpace"
service archivesspace start


echo "Applying ArchivesSpace defaults"
cd /vagrant
python archivesspace_defaults.py