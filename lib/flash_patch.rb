require 'action_dispatch/middleware/cookies'
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
      def initialize(parent_jar, secret)
        ensure_secret_secure(secret)
        @parent_jar = parent_jar
        @verifier   = ActiveSupport::MessageVerifier.new(secret)
        @nonloading_verifier = ActiveSupport::MessageVerifier.new(secret, :serializer => DummySerializer)
      end
      def [](name)
        if signed_message = @parent_jar[name]
          begin
            @verifier.verify(signed_message)
          rescue ArgumentError
            string = @nonloading_verifier.verify(signed_message)

            # Swap FlashHash Class
            original_flash_hash_klass = ActionDispatch::Flash::FlashHash
            ActionDispatch::Flash.send :remove_const, :FlashHash
            ActionDispatch::Flash.const_set 'FlashHash', Flash::FlashHashKludge

            session = Marshal.load string
            flash_messages_from_original_klass = session.delete('flash')

            # Restore FlashHash Class
            ActionDispatch::Flash.send :remove_const, :FlashHash
            ActionDispatch::Flash.const_set 'FlashHash', original_flash_hash_klass

            session['flash'] = ActionDispatch::Flash::FlashHash.new.update(flash_messages_from_original_klass)
            session
          end
        end
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        nil
      end
    end
  end
end
