require 'camping'

require 'active_support'
require 'yaml'

# enable xhtml source code indentation for debugging views
Markaby::Builder.set(:indent, 2)

# seed the random number generator (ruby does this by default, but it doesn't hurt to do it here just to be sure)
srand

# Camping.goes must be called after the authenticator class is loaded, otherwise weird things happen
Camping.goes :CASServer

module CASServer
end

# load configuration
$CONF = HashWithIndifferentAccess.new(YAML.load_file(File.dirname(File.expand_path(__FILE__))+"/config.yml"))
begin
  # attempt to instantiate the authenticator
  $AUTH = $CONF[:authenticator].constantize.new
rescue NameError
  # the authenticator class hasn't yet been loaded, so lets try to load it from the casserver/authenticators directory
  auth_rb = $CONF[:authenticator].underscore.gsub('cas_server/', '')
  require 'casserver/'+auth_rb
  $AUTH = $CONF[:authenticator].constantize.new
end

require 'casserver/util'
require 'casserver/views'
require 'casserver/controllers'

def CASServer.create
end