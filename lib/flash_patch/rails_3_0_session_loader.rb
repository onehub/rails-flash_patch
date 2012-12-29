module FlashPatch
  class Rails30SessionLoader
    def initialize(decrypted_session_string)
      @decrypted_session_string = decrypted_session_string
    end

    def load_session
      # From trial-and-error, we can change one letter in the name of
      # class in the Marshal-dumped string. So, we can call the backport
      # class FlashGash and use gsub so that Marshal will load the Rails 3.0 session
      # hash using it
      session = Marshal.load @decrypted_session_string.gsub('FlashHash','FlashGash')
      flash_messages_from_original_klass = session.delete('flash')
      session['flash'] = ActionDispatch::Flash::FlashHash.new.update(flash_messages_from_original_klass)
      session
    end
  end
end
