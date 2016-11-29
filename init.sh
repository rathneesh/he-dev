#!/usr/bin/env bash

# Copyright 2016 Hewlett-Packard Development Company, L.P.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Create an ssl certificate and key and place them in a directory called certs.
# These will be used by the express server.

# TODO: make this more robust, with error checking, etc.

./gen_certs.sh

env_file=".env"
answer="Y"
if [ -e "$env_file" ]; then
    echo "File $env_file already exists. Would you like to overwrite this file?"
    echo "Warning: you may lose your current environment configurations."
    echo "Type Y/y for 'yes' or any other character for 'no' followed by [ENTER]"
    read -n 1 answer
    echo ""
    cp $env_file "$env_file.bak" 2>/dev/null
fi

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then

cat > $env_file <<EOF
# Add here your integration-specific environment variables so that 
# you do not have to add them to the docker-compose.yml file.
# The format is the one used by docker-compose
#   https://docs.docker.com/compose/env-file/ 
#   https://docs.docker.com/compose/compose-file/#/envfile
#   https://docs.docker.com/compose/environment-variables/#/the-env-file
# Example:
# MYINTEGRATION_PORT=81811
# MYINTEGRATION_TENANT_ID=mytenant
# SOME_OTHER_VAR=blah

EOF

    echo "Would you like to provide the path to your hubot enterprise integration source code?"
    echo "Type Y/y for 'yes' or any other character for 'no' followed by [ENTER]"
    read -n 1 answer
    echo ""

    if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
        echo "Please type the FULL path to your integration source code (e.g. /root/hubot-myintegration) followed by [ENTER]"
        read integration_path
        if [ ! -e "$integration_path" ] || [ ! -d "$integration_path" ]; then
            echo "ERROR: specified path $integration_path is NOT valid."
            echo "Skipping setting HE_INTEGRATION_LOCAL_PATH for you. You must do it manually in $env_file"
        else
            env_var="HE_INTEGRATION_LOCAL_PATH=$integration_path"
            echo "Writing $env_var to $env_file"
            echo $env_var | tee -a $env_file
        fi
    fi
fi

proxy_file=".env_proxy"
container_list="auth,vault"

answer="Y"
if [ -e "$proxy_file" ]; then
    echo "File $proxy_file already exists. Would you like to overwrite this file?"
    echo "Warning: you may lose your current environment configurations."
    echo "Type Y/y for 'yes' or any other character for 'no' followed by [ENTER]:"
    read -n 1 answer
    echo ""
    cp $proxy_file "$proxy_file.bak" 2>/dev/null
fi

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then

cat > $proxy_file <<EOF
# Add here the environment variables for your http proxy servers.
# The format is the one used by docker-compose
#   https://docs.docker.com/compose/env-file/ 
#   https://docs.docker.com/compose/compose-file/#/envfile
#   https://docs.docker.com/compose/environment-variables/#/the-env-file
# Example:
# http_proxy=http://myproxy.example.com:8080
# https_proxy=http://myproxy.example.com:8080
# no_proxy=localhost,127.0.0.1,mycontainer

EOF


    if [ ! -z ${http_proxy+x} ] || [ ! -z ${HTTP_PROXY+x} ]; then

        echo "Are you deploying these containers in an environment bound to an http proxy server?"
        echo "Type Y/y for 'yes' or any other character for 'no' followed by [ENTER]:"
        read -n 1 answer
        echo ""
        
        if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
            echo "Checking proxy environment variables:"
            if [ ! -z ${http_proxy+x} ]; then
                env_var="http_proxy=$http_proxy"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            if [ ! -z ${HTTP_PROXY+x} ]; then
                env_var="HTTP_PROXY=$HTTP_PROXY"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            if [ ! -z ${https_proxy+x} ]; then
                env_var="https_proxy=$https_proxy"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            if [ ! -z ${HTTPS_PROXY+x} ]; then
                env_var="HTTPS_PROXY=$HTTPS_PROXY"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            if [ ! -z ${ftp_proxy+x} ]; then
                env_var="ftp_proxy=$ftp_proxy"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            if [ ! -z ${FTP_PROXY+x} ]; then
                env_var="FTP_PROXY=$FTP_PROXY"
                echo "Writing $env_var"
                echo $env_var | tee -a $proxy_file
            fi
            env_var=""
            if [ ! -z ${NO_PROXY+x} ]; then
                env_var="NO_PROXY=$NO_PROXY,$container_list"
            else
                env_var="NO_PROXY=localhost,127.0.0.1,$container_list"
            fi

            missing_localhost=$(echo $env_var | grep -v "localhost")
            if [ "$missing_localhost" == "0" ]; then
                env_var="localhost,$env_var"
            fi
            missing_loopback=$(echo $env_var | grep -v "127.0.0.1")
            if [ "$missing_loopback" == "0" ]; then
                env_var="127.0.0.1,$env_var"
            fi

            echo "Writing $env_var"
            echo $env_var | tee -a $proxy_file

            env_var=""
            if [ ! -z ${no_proxy+x} ]; then
                env_var="no_proxy=$no_proxy,$container_list"
            else
                env_var="no_proxy=localhost,127.0.0.1,$container_list"
            fi
            missing_localhost=$(echo $env_var | grep -v "localhost")
            if [ "$missing_localhost" == "0" ]; then
                env_var="localhost,$env_var"
            fi
            missing_loopback=$(echo $env_var | grep -v "127.0.0.1")
            if [ "$missing_loopback" == "0" ]; then
                env_var="127.0.0.1,$env_var"
            fi
            echo "Writing $env_var"
            echo $env_var | tee -a $proxy_file
        fi
    fi

fi

echo "Finished init script."

exit $?
