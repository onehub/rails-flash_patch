module FlashPatch
  class Rails30SessionLoader
    def initialize(decrypted_session_string)
      @decrypted_session_string = decrypted_session_string
    end

    def load_session
      # Swap FlashHash Class
      original_flash_hash_klass = ActionDispatch::Flash::FlashHash
      ActionDispatch::Flash.send :remove_const, :FlashHash
      ActionDispatch::Flash.const_set 'FlashHash', ActionDispatch::Flash::FlashHashKludge
      session = Marshal.load @decrypted_session_string
      flash_messages_from_original_klass = session.delete('flash')

      # Restore FlashHash Class
      ActionDispatch::Flash.send :remove_const, :FlashHash
      ActionDispatch::Flash.const_set 'FlashHash', original_flash_hash_klass

      session['flash'] = ActionDispatch::Flash::FlashHash.new.update(flash_messages_from_original_klass)
      session
    end
  end
end
