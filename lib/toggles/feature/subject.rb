module Feature
  module Subject
    class Invalid < StandardError
      def initialize(args)
        super("Invalid or missing subjects for permissions: #{args}")
      end
    end

    class NotApplicable < StandardError
      def initialize(args)
        super("Subjects not applicable for permissions: #{args}")
      end
    end

    class Empty < StandardError
    end
  end
end
