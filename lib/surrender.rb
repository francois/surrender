require "surrender/version"
require "surrender/most_recent_policy"
require "surrender/weekly_policy"
require "surrender/monthly_policy"
require "surrender/yearly_policy"
require "date"

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

    policies = [
      Surrender::MostRecentPolicy.new(options.fetch(:most_recent)),
      Surrender::WeeklyPolicy.new(options.fetch(:weekly)),
      Surrender::MonthlyPolicy.new(options.fetch(:monthly)),
      Surrender::YearlyPolicy.new(options.fetch(:yearly)),
    ]

    all_files = filenames.map(&:to_s)
    valid_filenames = all_files.select{|fn| fn =~ BACKUP_RE}
    unprocessable = all_files - valid_filenames
    valid_filenames.each do |filename|
      filename =~ BACKUP_RE
      date = Date.new($1.to_i, $3.to_i, $4.to_i)

      policies.each do |policy|
        policy.add(filename, date)
      end
    end

    deleteable = valid_filenames.select do |filename|
      policies.all?{|policy| policy.deleteable?(filename)}
    end

    [unprocessable, deleteable]
  end

  BACKUP_RE = /\b((?:19|2\d)\d{2})(.)?(0\d|1[012])\2?([012]\d|3[01])(?:T|\b)/
end
