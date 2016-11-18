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

touch .env
cat > .env <<EOF
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

exit $?