module Surrender
  class WeeklyPolicy
    def initialize(count)
      @count = count
      @memo  = Hash.new
    end

    attr_reader :count, :memo

    def add(filename, date)
      week = date - date.wday
      memo[week] = filename
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
