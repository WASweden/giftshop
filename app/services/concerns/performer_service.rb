module PerformerService
  def self.included(base)
    base.send(:define_singleton_method, :perform) do |*args|
      return self.send(:new, *args).send(:perform)
    end
  end

  module FormattedErrors
    def to_s
      self.map(&:to_s).join(", ")
    end
  end

  class Failure
    attr_reader :errors

    def initialize(errors = [])
      @errors = [errors].flatten
      @errors.extend(FormattedErrors)
    end

    def success?
      false
    end
    alias_method :valid?, :success?
  end

  F = Failure

  class Success
    attr_reader :data

    def initialize(data = {})
      @data = data.is_a?(Hash) ? OpenStruct.new(data) : data
    end

    def success?
      true
    end

    alias_method :valid?, :success?

    def value
      data
    end

    def method_missing(meth, *args)
      if data.respond_to?(meth)
        self.data.send(meth, *args)
      elsif data.is_a?(Hash) && data.key?(meth) && args.length == 0
        self.data.send(:[], meth)
      else
        super
      end
    end
  end

  S = Success
end

