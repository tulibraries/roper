# frozen_string_literal: true

require "octokit"
require "netrc"
require "json"

module Roper
  # This class is concerned with GitHub API communications.
  class Hub
    # Create and instance of the Hub class
    #
    # @param [String] repo A GitHub reposiory in the form <user>/<name>
    # @param [String] ref The sha for a commit
    def initialize(repo, ref)
      @repo = repo
      @ref = ref
      @client = Octokit::Client.new(netrc: true)
    end

    # Changes the status on a GitHub PR
    #
    # @see https://octokit.github.io/octokit.rb/Octokit/Client/Statuses.html
    #
    # @param state [String] The state: pending, success, failure
    #
    # @param options [Hash] A customizable set of options
    # @option options [String] :target_url A link to the built site
    # @option options [String] :description A short human-readable description of this status
    def create_status(state, options = {})
      @client.create_status(@repo, @ref, state, options.merge(context: "roper"))
    end

    def self.create(repo, ref, options = {})
      if options["disable-hub"]
        DumbHub.new(repo, ref)
      else
        self.new(repo, ref)
      end
    end
  end

  class DumbHub < Hub
    def create_status(state, options = {})
    end
  end
end
