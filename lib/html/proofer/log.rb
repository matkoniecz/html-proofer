require 'yell'

module HTML
  class Proofer
    class Log
      include Yell::Loggable

      def initialize(verbose)
        log_level = verbose ? :debug : :info

        @logger = Yell.new({ :format => false, :name => 'HTML::Proofer', :level => "gte.#{log_level}" }) do |l|
          l.adapter :stdout, :level => [:debug, :info, :warn]
          l.adapter :stderr, :level => [:error, :fatal]
        end
      end

      def log(level, color, message)
        @logger.send level, colorize(color, message)
      end

      def colorize(color, message)
        if $stdout.isatty && $stderr.isatty
          Colored.colorize(message, foreground: color)
        else
          message
        end
      end

      # dumb override to play nice with Typhoeus/Ethon
      def debug(message = nil)
        log(:debug, :yellow, message || $stdout)
      end
    end
  end
end
