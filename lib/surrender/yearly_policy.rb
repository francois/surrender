require "surrender/bucket_policy"

module Surrender
  class YearlyPolicy < BucketPolicy
    def bucket(date)
      Date.new(date.year, 1, 1)
    end
  end
end
