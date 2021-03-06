#!/bin/bash
# Sample shell script to install oracle jdk and set it as default jdk
# Author: Pankaj Labade

# source the properties:
. ./jdk-inst.properties

echo JDK installer is present at $oracle_jdk_loc

ext=${oracle_jdk_installer#*.}

set_java(){
   sudo update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/bin/java" 1 
   sudo update-alternatives --install "/usr/bin/javac" "javac" "$JAVA_HOME_Parent_Dir/$oracle_jdk_val/bin/javac" 1 
   sudo update-alternatives --install "/usr/bin/javaws" "javaws" "$JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/bin/javaws" 1 
    
   # Run below commands to active the oracle JDK I just installed.    
   sudo update-alternatives --set java $JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/bin/java
   sudo update-alternatives --set javac $JAVA_HOME_Parent_Dir/$oracle_jdk_val/bin/javac
   sudo update-alternatives --set javaws $JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/bin/javaws
   
   sudo rm -rf $JAVA_HOME_Parent_Dir/$oracle_jdk_installer
}

if [ $ext = "bin" ] ; then
    echo You are providing a $oracle_jdk_installer file 
    cd $oracle_jdk_loc
    sudo cp -rvf $oracle_jdk_loc/$oracle_jdk_installer $JAVA_HOME_Parent_Dir
    cd $JAVA_HOME_Parent_Dir
    sudo chmod +x $oracle_jdk_installer
    sudo ./$oracle_jdk_installer
    set_java
elif [ $ext = "tar.gz" ] ; then
    echo You are providing a $oracle_jdk_installer file
    cd $oracle_jdk_loc
    sudo cp -rvf $oracle_jdk_loc/$oracle_jdk_installer $JAVA_HOME_Parent_Dir
    cd $JAVA_HOME_Parent_Dir
    sudo chmod +x $oracle_jdk_installer
    sudo tar xvzf $oracle_jdk_installer   
    set_java
fi

# Finally test the switch has been successful:
java -version 
javac -version

# Installing the Firefox/Chrome plugin

if [ ! -d ~/.mozilla/plugins ]; then
   mkdir ~/.mozilla/plugins
fi

# Remove the IcedTea plugin, if it has been installed.
sudo apt-get -mf remove icedtea6-plugin

# Remove a former version of the Java plugin (may or may not be present)
rm -fr ~/.mozilla/plugins/libnpjp2.so

# Now you can install the plugin, by creating a symbolic link 
# (you tell Firefox, where the plugin is located).

if [ "$JDK_32_bit" = "yes" ]; then
	ln -s $JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/lib/i386/libnpjp2.so ~/.mozilla/plugins/
else
    ln -s $JAVA_HOME_Parent_Dir/$oracle_jdk_val/jre/lib/amd64/libnpjp2.so ~/.mozilla/plugins/
fi
