#!/bin/bash

ORANGE='\033[0;33m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


###########################
# The command line help   #
###########################
display_help() {
    echo "Usage: $0 [option...] {on|off}" >&2
    echo
    echo "   -i, --info           		displays the proxy settings"
    echo
    echo "Proxy settings must be set in ~/.proxy.conf as follow:"
    echo "USER=\"user\""
	echo "PASSWORD=\"user\""
    echo "HOST=\"host\""
    echo "PORT=\"port\""
    exit 1
}

###########################
# Display proxy settings  #
###########################
display_proxy_settings() {
    source $HOME/.proxy.conf

    echo "Proxy configurations are set in ~/.proxy.conf with current values:"
    echo -e "   User:     ${ORANGE}$USER${NC}"
    echo -e "   Password: ${ORANGE}$PASSWORD${NC}"
    echo -e "   Host:     ${ORANGE}$HOST${NC}"
    echo -e "   Port:     ${ORANGE}$PORT${NC}"
    echo
}

###########################
# Set proxy method        #
###########################
set_proxy() {
    source $HOME/.proxy.conf

    PROXY="http://$USER:$PASSWORD@$HOST:$PORT/"
    echo -e "From now on, you will use the following proxy settings: ${ORANGE}$PROXY${NC}"
    echo "  NOTE: Those proxy settings are sourced from ~/.proxy.conf"

    # Global proxy
    eval `export proxy=$PROXY`
    echo -e "   Global proxy:        ${GREEN}on${NC}"
    # Global http_proxy
    eval `export http_proxy=$PROXY`
    eval `export HTTP_PROXY=$PROXY`
    echo -e "   Global http_proxy:   ${GREEN}on${NC}"
    # Global https_proxy
    eval `export https_proxy=$PROXYl`
    eval `export HTTPS_PROXY=$PROXYl`
    echo -e "   Global https_proxy:  ${GREEN}on${NC}"
    # NPM proxy
    eval `npm config set proxy $PROXY`
    eval `npm config set https-proxy $PROXY`
    echo -e "   NPM proxy:           ${GREEN}on${NC}"
    # GIT proxy
    eval `git config --global http.proxy $PROXY`
    eval `git config --global https.proxy $PROXY`
    echo -e "   GIT proxy:           ${GREEN}on${NC}"
    # cURL proxy
    if [ ! -e "$HOME/.curlrc" ]; then
		touch "$HOME/.curlrc"
	fi
    echo "proxy=$PROXY" >> $HOME/.curlrc
    echo -e "   cURL proxy:          ${GREEN}on${NC}"

    echo -e "${YELLOW} > All proxy settings are on${NC}"
}

###########################
# Unset proxy method      #
###########################
unset_proxy() {

    # Global proxy
    eval `unset proxy`
    # Global http_proxy
    eval `unset http_proxy`
    eval `unset HTTP_PROXY`
    echo -e "   Global proxy:           ${RED}off${NC}"
    # Global https_proxy
    eval `unset https_proxy`
    eval `unset HTTPS_PROXY`
    echo -e "   Global HTTPS proxy:     ${RED}off${NC}"
    # NPM proxy
    eval `npm config delete proxy`
    eval `npm config delete https-proxy`
    echo -e "   NPM proxy:              ${RED}off${NC}"
    # GIT proxy
    eval `git config --global --unset http.proxy`
    eval `git config --global --unset https.proxy`
    echo -e "   GIT proxy:              ${RED}off${NC}"
    # cURL proxy
    if [ -e "$HOME/.curlrc" ]; then
		sed -i "/proxy\=/d" $HOME/.curlrc
	fi
    echo -e "   cURL proxy:             ${RED}off${NC}"

    echo -e "${YELLOW} > All proxy settings have been unset${NC}"
}

################################
# Check if parameters options  #
# are given on the commandline #
################################

# If no arguments: display help.
if [ -z "$1" ]
  then
	display_help
fi

# If help required: display help.
for arg in "$@"; do
    case "$arg" in
      -h | --help)
          display_help
          ;;
	esac
done

# If info required: display proxy settings.
for arg in "$@"; do
    case "$arg" in
      -i | --info)
          display_proxy_settings  # Call your function
          ;;
	esac
done

# set / unset proxy.
for arg in "$@"; do
    case "$arg" in
      on)
          set_proxy   # calling function set_proxy()
          exit 1 
          ;;
      off)
          unset_proxy   # calling function unset_proxy()
          exit 1 
          ;;  
    esac
done
