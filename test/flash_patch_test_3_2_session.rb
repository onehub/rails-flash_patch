string = File.read('../session_examples/rails_3_2_with_flash.dump')
session = FlashPatch::Rails31SessionLoader.load_session(string)
puts "Session should have flash content:"
p session['flash']
