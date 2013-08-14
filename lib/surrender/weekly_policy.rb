require "surrender/bucket_policy"

module Surrender
  class WeeklyPolicy < BucketPolicy
    def bucket(date)
      date - date.wday
    end
  end
end
