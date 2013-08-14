module Surrender
  class BucketPolicy
    def initialize(count)
      @count = count
      @memo  = Hash.new
    end

    attr_reader :count, :memo

    def add(filename, date)
      memo[bucket(date)] = filename
      memo.delete(memo.keys.first) if memo.size > count
    end

    def deleteable?(filename)
      !memo.values.include?(filename)
    end

    def keys
      memo.keys
    end
  end
end
