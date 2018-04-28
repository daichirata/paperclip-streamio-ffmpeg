lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "paperclip-streamio-ffmpeg/version"

Gem::Specification.new do |spec|
  spec.name          = "paperclip-streamio-ffmpeg"
  spec.version       = PaperclipStreamioFFMPEG::VERSION
  spec.authors       = ["Daichi HIRATA"]
  spec.email         = ["daichirata@gmail.com"]

  spec.summary       = "Video Transcoder for Paperclip using streamio-ffmpeg"
  spec.description   = "Video Transcoder for Paperclip using streamio-ffmpeg"
  spec.homepage      = "https://github.com/daichirata/paperclip-streamio-ffmpeg"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "paperclip"
  spec.add_dependency "streamio-ffmpeg", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
