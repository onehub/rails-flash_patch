module FlashPatch
  class Rails30SessionLoader
    def self.load_session(decrypted_session_string)
      # From trial-and-error, we can change one letter in the name of
      # class in the Marshal-dumped string. So, we can call the backport
      # class FlashGash and use gsub so that Marshal will load the Rails 3.0 session
      # hash using it
      idx   = decrypted_session_string.index('FlashHash')
      g_idx = idx + 5

      cleaned_string = decrypted_session_string.dup
      cleaned_string[g_idx] = 'G'

      session = Marshal.load cleaned_string

      flash_messages_from_original_klass = session.delete('flash')
      session['flash'] = ActionDispatch::Flash::FlashHash.new.update(flash_messages_from_original_klass)
      session
    end
  end
end
