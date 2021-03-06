module Git
  module Whistles
    class Jira
      attr_reader :username, :password, :site

      def initialize
        get_config
      end

      def get_client(opts = {})
        options = {
          username: @username,
          password: @password,
          site: @site,
          context_path: '',
          auth_type: :basic,
          read_timeout: 120
        }

        options.merge!(opts)

        JIRA::Client.new(options)
      end

      def get_config
        @username = `git config jira.username`.strip
        if username.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your JIRA username!
            Please set it with:
            $ git config [--global] jira.username <username>
          }
          raise "Aborting."
        end

        @password = `git config jira.password`.strip
        if password.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your JIRA password!
            Please set it with:
            $ git config [--global] jira.password <password>
          }
          raise "Aborting."
        end

        @site = `git config jira.site`.strip
        if site.empty?
          puts Term::ANSIColor.yellow %Q{
            Your branch appears to have a issue ID,
            but I don't know your JIRA site!
            Please set it with:
            $ git config [--global] jira.site <https://mydomain.atlassian.net>
          }
          raise "Aborting."
        end
      end
    end
  end
end
