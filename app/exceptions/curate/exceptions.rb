module Curate
  #
  module Exceptions
    class RepresentativeObjectMissingError < RuntimeError
      attr_reader :base_exception, :work
      def initialize(base_exception, work)
        @base_exception = base_exception
        @work = work
        super("For #{work.class} ID=#{work.id}, encountered error #{base_exception}")
      end
    end
  end
end
