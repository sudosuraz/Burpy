#!/bin/bash
OR='\e[38;5;202m'
GR='\e[32m'
NL='\e[0m'
WH='\e[97m'
BL='\e[34m'


echo -e "
${OR} ██████╗██╗   ██╗██████╗ ██████╗ ██████╗ ███████╗███████╗███████╗████████╗${NL}
${OR}██╔════╝╚██╗ ██╔╝██╔══██╗╚════██╗██╔${BL}══${NL}${OR}██╗╚══███╔╝██╔════╝██╔════╝╚══██╔══╝${NL}
${WH}██║      ╚████╔╝ ██████╔╝ █████╔╝${BL}██████╔╝${NL}${WH}  ███╔╝ █████╗  ███████╗   ██║   ${NL}
${WH}██║       ╚██╔╝  ██╔══██╗ ╚═══██╗${BL}██╔══██╗${NL}${WH} ███╔╝  ██╔══╝  ╚════██║   ██║   ${NL}
${GR}╚██████╗   ██║   ██████╔╝██████╔╝██║${BL}  █${NL}${GR}█║███████╗███████╗███████║   ██║   ${NL}
${GR} ╚═════╝   ╚═╝   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   ${NL}
"
echo "  This script is made by CyberZest
"

# Check if Java JDK 19 is installed
if ! command -v javac >/dev/null 2>&1; then
    echo "Java JDK 19 is not installed, installing"
    mkdir -p /usr/local/java
    mkdir -p /usr/local/java/jdk19
    curl -L https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.tar.gz -o jdk19.tar.gz
    tar -xf jdk19.tar.gz -C /usr/local/java/jdk19 --strip-components=1
    rm jdk19.tar.gz
    echo "export JAVA_HOME=/usr/local/java/jdk19" | sudo tee -a /etc/environment
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/environment
    sudo update-alternatives --install /usr/bin/java java /usr/local/java/jdk19/bin/java 1
    sudo update-alternatives --install /usr/bin/javac javac /usr/local/java/jdk19/bin/javac 1
    source /etc/profile
    echo "Java JDK 19 downloaded and installed successfully"
fi

# Check if Java JRE 8 is installed
if ! command -v java >/dev/null 2>&1; then
    jre8_url=https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244548_89d678f2be164786b292527658ca1605
    sudo mkdir -p /usr/local/java/jre8
    sudo curl -L -o /usr/local/java/jre8/jre8.tar.gz $jre8_url
    sudo tar -xzf /usr/local/java/jre8/jre8.tar.gz -C /usr/local/java/jre8
    sudo rm /usr/local/java/jre8/jre8.tar.gz
    sudo update-alternatives --install /usr/bin/java java /usr/local/java/jre8/jre1.8.0_301/bin/java 1
    sudo update-alternatives --install /usr/bin/javac javac /usr/local/java/jre8/jre1.8.0_301/bin/javac 1
    sudo update-alternatives --set java /usr/local/java/jre8/jre1.8.0_301/bin/java 1
    sudo update-alternatives --set javac /usr/local/java/jre8/jre1.8.0_301/bin/javac 1
    echo "Java JRE 8 downloaded and installed successfully"
fi

if [[ $EUID -eq 0 ]]; then
    # Download Burp Suite Profesional Latet Version
    echo 'Downloading Burp Suite Professional ....'
    mkdir -p /usr/share/burpsuite
    cp loader.jar /usr/share/burpsuite/
    cp burp_suite.ico /usr/share/burpsuite/
    rm Windows_setup.ps1
    rm -rf .git
    cd /usr/share/burpsuite/
	rm burpsuite.jar
    html=$(curl -s https://portswigger.net/burp/releases)
    version=$(echo $html | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=&type=jar"
    echo $version
    wget "$Link" -O burpsuite_pro_v$version.jar --quiet --show-progress
    sleep 2
    
    # Execute Burp Suite Professional with Keyloader
    echo 'Executing Burp Suite Professional with Keyloader'
    echo "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/burpsuite_pro_v$version.jar &" > burpsuite
    chmod +x burpsuite
    cp burpsuite /bin/burpsuite

    # execute Keygenerator
    echo 'Starting Keygenerator'
    (java -jar loader.jar) &
    sleep 3s
    (./burpsuite)
else
    echo "Execute Command as Root User"
    exit
fi
