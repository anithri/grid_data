module GridData
  class GridDataError < StandardError
    @@ignore = :warn

    def ok_to_ignore?
      @@ignore
    end

    def self.ok_to_ignore
      @@ignore
    end
    alias ok_to_ignore? ok_to_ignore

    def self.ok_to_ignore=(val)
      @@ignore = val
    end

  end

  class ConfigFileError < GridDataError; end

  module RaiseOrIgnore
    def raise_or_ignore(*args)
      if args[0].kind_of?(Exception) && args[0].respond_to(:ignore_me?) && args[0].ignore_me?
        if args[0].ignore_me? == :silent
          return nil
        else
          warn args.map(&:to_s).join(":")
          return nil
        end
      end
      raise args
    end
  end

  #module Kernel
  #  include RaiseOrIgnore
  #end

end

