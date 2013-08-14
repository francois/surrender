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
    weekly        = Hash.new

    deleteable = filenames.each_with_object(Hash.new{|h,k| h[k] = Hash.new}) do |filename, votes|
      next unprocessable << filename unless BACKUP_RE =~ filename

      date = Date.new($1.to_i, $3.to_i, $4.to_i)

      most_recent << filename
      votes[filename][:most_recent] = :keep
      if most_recent.size > options.fetch(:most_recent) then
        votes[most_recent.shift][:most_recent] = :delete
      end

      last_sunday = date - date.wday
      if weekly.include?(last_sunday)
        votes[weekly.delete(last_sunday)][:weekly] = :delete
      end
      weekly[last_sunday] = filename
      votes[filename][:weekly] = :keep
    end.select do |_, votes|
      votes.values.uniq.size == 1 && votes.values.uniq.first == :delete
    end.keys

    [unprocessable, deleteable]
  end

  BACKUP_RE = /\b((?:19|2\d)\d{2})(.)?(0\d|1[012])\2?([012]\d|3[01])(?:T|\b)/
end
