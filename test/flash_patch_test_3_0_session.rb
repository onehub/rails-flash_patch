string = File.read('../session_examples/rails_3_0_with_flash.dump')
session = FlashPatch::Rails30SessionLoader.load_session(string)
puts "Session should have flash content:"
p session['flash']
