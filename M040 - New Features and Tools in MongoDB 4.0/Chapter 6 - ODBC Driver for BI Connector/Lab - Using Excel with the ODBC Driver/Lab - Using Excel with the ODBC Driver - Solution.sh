#!/bin/bash

# Creates the directories for the servers.
mkdir -p ~/repl/{1,2,3}

# Starts up the servers.
mongod --dbpath ~/repl/1 --logpath ~/repl/1/log --port 27017 --replSet M040 --bind_ip_all --fork
mongod --dbpath ~/repl/2 --logpath ~/repl/2/log --port 27027 --replSet M040 --bind_ip_all --fork
mongod --dbpath ~/repl/3 --logpath ~/repl/3/log --port 27037 --replSet M040 --bind_ip_all --fork

# Initiates the replicaSet.
mongo --eval 'rs.initiate()'
mongo --eval 'rs.add("m040:27027");rs.add("m040:27037")'

# Imports the lab data.
mongoimport --host M040/$(hostname):27017,$(hostname):27027,$(hostname):27037 -d m040 -c companies < /dataset/companies.json

# Starts the MongoDB Connector for BI.
mongosqld --addr 192.168.40.100 --mongo-uri mongodb://localhost