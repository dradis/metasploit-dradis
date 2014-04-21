# Copyright (c) 2014, Daniel Martin <etd[at]nomejortu.com
# All rights reserved.
#
#
# This Metasploit plugin allows you to post information into your Dradis
# instance directly from within Metasploit's console.
#
# Commands:
#

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
        'DradisDispatcher'
      end

      # The list of commands we make available to the ./msfconsole
      def commands
        {
          'dradis_help'	=> 'Displays help',
          'dradis_version' => 'Displays version information'
        }
      end

      def cmd_dradis_help
        print_line 'No idea what I am doing'
      end

      def cmd_dradis_version
        print_line "#{Msf::Plugin::Dradis::name} v#{Msf::Plugin::Dradis::version}"
      end
    end
  end
end