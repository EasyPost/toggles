module Feature
  class Permissions
    module Operation
      class Range
        def self.call(args)
          raise StandardError, "Invalid range operation" if args.size != 2
          (args.first..args.last)
        end
      end
    end
  end
end
