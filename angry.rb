require "pocketsphinx-ruby"

FILE = "test.raw"

microphone = Pocketsphinx::Microphone.new

puts "Recording!..."
File.open(FILE, "wb") do |file|
  microphone.record do
    FFI::MemoryPointer.new(:int16, 2048) do |buffer|
      50.times do
        sample_count = microphone.read_audio(buffer, 2048)
        file.write buffer.get_bytes(0, sample_count * 2)

        sleep 0.1
      end
    end
  end
end

puts "...Stopped recording."

decoder = Pocketsphinx::Decoder.new(Pocketsphinx::Configuration.default)
decoder.decode(FILE)

puts "> #{decoder.hypothesis}"
