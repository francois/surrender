module Surrender
  class MostRecentPolicy
    def initialize(count)
      @count = count
      @memo  = []
    end

    attr_reader :count, :memo

    def name
      "most recent"
    end

    def add(filename, _)
      memo << filename
      memo.shift if memo.size > count
    end

    def deleteable?(filename)
      !memo.include?(filename)
    end

    alias_method :keys, :memo
  end
end
