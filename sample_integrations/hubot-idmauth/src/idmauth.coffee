# Notes:
#  Copyright 2016 Hewlett-Packard Development Company, L.P.
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copie of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.

module.exports = (robot) ->
  # Check if hubot-enterprise is loaded
  if not robot.e
    robot.logger.error 'hubot-enterprise not present, idmauth cannot run'
    return
  robot.logger.info 'idmauth integration initialized'

  # Bot information for registration
  bot_info = 
    name: 'idmauth'
    short_desc: 'Showcases idm auth support'
    long_desc: '...'

  # Convenience method for developer to generate a IDM Auth config
  idm_auth_params = 
    endpoint: 
      url: "http://myidmserver.example.com"
      verb: "POST"
  auth_info = robot.e.auth.generate_idm_auth idm_auth_params

  # Register integration with previous configurations
  robot.e.registerIntegration bot_info, auth_info  
  
  # Register some commands
  command_info = 
    verb: 'create'
    entity: 'ticket'
    help: 'create ticket' 
    type: 'respond'
  
  robot.e.create command_info, (msg, auth_payload) ->
    text = 'Executed idmauth (integration) create ticket.'
    robot.logger.debug text
    string_payload = JSON.stringify(auth_payload, ' ', 2)
    robot.logger.debug string_payload 
    msg.reply text
    msg.reply string_payload

