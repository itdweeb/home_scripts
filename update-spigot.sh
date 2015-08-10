#!/bin/bash

# Download
pushd ~/build/spigot
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar &> lastdl.log

# Build
java -jar BuildTools.jar &> lastbuild.log
popd

# Backup
pushd ~/server
mv craftbukkit.jar /backup/minecraft/`date +"craftbukkit.jar_backup_%Y-%m-%d.%H-%M-%S.jar"`
popd

# Install
pushd ~/build/spigot
mv craftbukkit-1.*.jar ~/server/craftbukkit.jar

