require "surrender/version"

module Surrender
  DEFAULT_ARGUMENTS = {
    most_recent: 7,
    weekly: 5,
    monthly: 2,
    yearly: 2
  }.freeze

  # @return [Array<String>, Array<String>] The first argument returns filenames which did not match the regular expression.
  #                                        The second argument returns filenames which matched the regular expression and
  #                                        are candidates to be deleted.
  def self.reject(filenames, options={})
    options = DEFAULT_ARGUMENTS.merge(options)
    extra_keys = options.keys - DEFAULT_ARGUMENTS.keys
    raise ArgumentError, "Unknown keys: #{extra_keys.inspect} -- won't proceed" unless extra_keys.empty?

    unprocessable = []
    most_recent   = []
    weekly        = []
    monthly       = []
    yearly        = []
    deleteable    = []

    filenames.each do |filename|
      most_recent << filename
      if most_recent.size > options.fetch(:most_recent) then
        deleteable << most_recent.shift
      end
    end

    [unprocessable, deleteable]
  end

  BACKUP_RE = /\b((?:19|2\d)\d{2})(.)?(0\d|1[012])\2([012]\d|3[01])(?:T|\b)/
end
