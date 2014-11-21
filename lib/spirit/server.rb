require 'socket'
require 'uri'

require_relative 'script'
require_relative 'master'
require_relative 'package'
require_relative 'workflow'

module Spirit

  class Server

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def info(request)

      repo_uri = URI.parse(@config['repository']['url'])
      repository_uri_preview = "%s://%s:*@%s%s" % [repo_uri.scheme, @config['repository']['user'], repo_uri.hostname, repo_uri.path]

      info = {
          'computer_primary_key' => @config['repository']['hostPrimaryKey'],
          'host_ip' => '127.0.0.1', # TODO: Get IP from Rack
          'host_name' => request.host,
          'host_system_version' => '9', # System minor version (9 = 10.9)
          'multicast_client_datarate_min' => @config['multicast']['minimumClientDataRate'],
          'multicast_stream_datarate_max' => @config['multicast']['maximumDataRatePerStream'],
          'name' => 'Spirit Server',
          'network_interfaces' => {
              'en0' => 'Ethernet' # TODO: System interfaces from Rack?
          },
          'protocol-version' => @config['version'],
          'repository_url_preview' => repository_uri_preview,
          'role' => @config['role'], # master | ?
          'secure_server' => 'NO', # TODO: make true if ssl certificate configured
          'status' => 0, # TODO: Not sure how this is applicable
          'version' => '1.6.12',
          'version-string' => 'Spirit Server 1.6.12.1',
          'server_url' => request.base_url,
          'host_system_version' => '9' # Host major system version
      }
      info
    end

    def stats
      data = {
          'clients' => 0,
          'computers' => 0,
          'masters' => Master.all_dict.length,
          'packages' => Package.all_dict.length,
          'scripts' => Script.all.length,
          'workflows' => Workflow.all_dict.length
      }
    end

  end

end