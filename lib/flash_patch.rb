$:.unshift File.dirname(__FILE__)
require 'action_dispatch/middleware/cookies'
require 'flash_patch/rails_3_0_session_loader'

module ActionDispatch
  class DummySerializer
    def self.load(string)
      string
    end
  end
  class Flash
    # Based on definition of FlashHash in Rails 3.0
    class FlashHashKludge < Hash
      def initialize #:nodoc:
        super
        @used = Set.new
      end
    end
  end
  class Cookies
    class SignedCookieJar
      def initialize_with_nonloading_verifier(parent_jar, secret)
        initialize_without_nonloading_verifier(parent_jar, secret)
        @nonloading_verifier = ActiveSupport::MessageVerifier.new(secret, :serializer => DummySerializer)
      end
      alias_method_chain :initialize, :nonloading_verifier
      def [](name)
        if signed_message = @parent_jar[name]
          begin
            @verifier.verify(signed_message)
          rescue ArgumentError
            string = @nonloading_verifier.verify(signed_message)

            FlashPatch::Rails30SessionLoader.new(string).load_session
          end
        end
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        nil
      end
    end
  end
end
