# Copyright (c) 2014, Daniel Martin <etd[at]nomejortu.com
# All rights reserved.
#
#
# This Metasploit plugin allows you to post information into your Dradis
# instance directly from within Metasploit's console.
#
# Commands:
#

require 'dradis-client'

module Msf
  class Plugin::Dradis < Msf::Plugin
    VERSION = '0.1.0'

    # ------------------------------------------------------------- Description
    def desc
      'Plugin to connect the Metasploit console with a running Dradis instance'
    end
    def name
      'Dradis'
    end
    def version
      VERSION
    end


    # --------------------------------------------------------- Init & teardown

    def initialize(framework, opts)
      unless framework.db and framework.db.active
        print_line "The #{name} plugin requires the framework to be connected to a Database!"
        return
      end

      super
      add_console_dispatcher(DradisConsoleDispatcher)
      banner = %{
      
      ooo.                     8  o           .oPYo. 8                o       
      8  `8.                   8              8    8 8                        
      8   `8 oPYo. .oPYo. .oPYo8 o8 .oPYo.   o8YooP' 8 o    o .oPYo. o8 odYo. 
      8    8 8  `' .oooo8 8    8  8 Yb..      8      8 8    8 8    8  8 8' `8 
      8   .P 8     8    8 8    8  8   'Yb.    8      8 8    8 8    8  8 8   8 
      8ooo'  8     `YooP8 `YooP'  8 `YooP'    8      8 `YooP' `YooP8  8 8   8 
      .....::..:::::.....::.....::..:.....::::..:::::..:.....::....8 :....::..
      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::ooP'.:::::::::
      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::...:::::::::::

      }
      print_line banner
      print_line "#{name} v#{version} plugin loaded"
    end

    def cleanup
      remove_console_dispatcher('DradisDispatcher')
    end


    # --------------------------------------------------------- Meat & potatoes
    class DradisConsoleDispatcher
      include Msf::Ui::Console::CommandDispatcher

      def name
        'Dradis Logger'
      end

      # The list of commands we make available to the ./msfconsole
      def commands
        {
          # meta commands
          'dradis_config'   => "Show Dradis API configuration (#{config_file})",
          'dradis_help'	    => 'Displays help',
          'dradis_version'  => 'Displays version information',

          # API commands
          'dradis_add_node' => 'Add a new Node to dradis',
          'dradis_nodes'    => 'List all nodes'
        }
      end

      # --------------------------------------------------------- Meta commands
      def cmd_dradis_config
        return missing_config unless configured?

        print_line "Dradis host: #{configuration[:host]}"
        print_line "Dradis user: #{configuration[:user]}"
        print_line "Dradis pass: #{configuration[:pass]}"
      end

      def cmd_dradis_help
        print_line 'No idea what I am doing'
      end

      def cmd_dradis_version
        print_line "#{Msf::Plugin::Dradis::name} v#{Msf::Plugin::Dradis::version}"
      end



      # ---------------------------------------------------------- API commands
      def cmd_dradis_add_node(*args)
        return missing_config unless configured?

        if args.size == 1
          dradis.add_node(args[0], parent_id: nil)
        elsif args.size == 2
          dradis.add_node(args[0], parent_id: args[1])
        else
          print_error "dradis_add_node node_label <parent_id>"
        end
      end

      def cmd_dradis_nodes
        return missing_config unless configured?

        dradis.nodes.each do |node|
          print_line "%02i: %-30s (pid: %02i)" % [node.id, node.label, node.parent_id || 0]
        end
      end

      private

      def dradis
        @dradis ||= Dradis::Client::Endpoint.new do |config|
                      config.host          = configuration[:host]
                      config.user          = configuration[:user]
                      config.shared_secret = configuration[:pass]
                    end
      end

      def config_file
        File.join(Msf::Config.get_config_root, 'dradis.yml')
      end

      def configuration
        @config ||= if File.exists?(config_file)
                      YAML.load_file(config_file).symbolize_keys
                    else
                      nil
                    end
      end

      def configured?
        !!configuration
      end

      def missing_config
        print_error "No configuration found at: #{config_file}"
        print_error "Use this as a template (without the =====):"
        print_line "============================"
        print_line "host: https://127.0.0.1:3004"
        print_line "user: msf_api"
        print_line "pass: shared_password"
        print_line "============================"
      end
    end
  end
end