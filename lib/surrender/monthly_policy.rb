require "surrender/bucket_policy"

module Surrender
  class MonthlyPolicy < BucketPolicy
    def bucket(date)
      Date.new(date.year, date.month, 1)
    end
  end
end
