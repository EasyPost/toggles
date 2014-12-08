module Feature
  module Subject
    class Invalid < StandardError
      def initialize(args)
        super("Invalid subjects for permissions: #{args}")
      end
    end

    def self.difference(subjects, others)
      Set.new((subjects - others) + (others - subjects)).to_a
    end
  end
end
