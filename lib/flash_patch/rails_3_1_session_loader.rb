module FlashPatch
  class Rails31SessionLoader
    def self.load_session(decrypted_session_string)
      session = Marshal.load decrypted_session_string.gsub('FlashHash','FlashGash')
      flash_messages_from_original_klass = session.delete('flash')
      session['flash'] = ActionDispatch::Flash::FlashHash.new.update(flash_messages_from_original_klass)
      session
    end
  end
end
