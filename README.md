# paperclip-streamio-ffmpeg

Video Transcoder for Paperclip using [streamio/streamio-ffmpeg](https://github.com/streamio/streamio-ffmpeg).

<p align="center">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square" alt="Software License" />
  </a>
  <a href="https://rubygems.org/gems/paperclip-streamio-ffmpeg">
    <img src="https://badge.fury.io/rb/paperclip-streamio-ffmpeg.svg" alt="Gem Version" />
  </a>
  <a href="https://travis-ci.org/daichirata/paperclip-streamio-ffmpeg">
    <img src="https://travis-ci.org/daichirata/paperclip-streamio-ffmpeg.svg?branch=master" alt="Travis CI" />
  </a>
  <a href="https://github.com/daichirata/paperclip-streamio-ffmpeg/releases">
    <img src="https://img.shields.io/github/release/daichirata/paperclip-streamio-ffmpeg.svg?style=flat-square" alt="Latest Version" />
  </a>
  <a href="https://github.com/daichirata/paperclip-streamio-ffmpeg/issues">
    <img src="https://img.shields.io/github/issues/daichirata/paperclip-streamio-ffmpeg.svg?style=flat-square" alt="Issues" />
  </a>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paperclip-streamio-ffmpeg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-streamio-ffmpeg

## Usage

Edit your paperclip model:

``` ruby
# app/models/assets.rb

class Asset < ApplicationRecord
  # paperclip style
  has_attached_file :attachment,
                    processors: [:transcoder],
                    styles: {
                      thumb: {
                        geometry: "150x150>",
                        format: :jpeg,
                        screenshot: true,
                      },
                      preview: {
                        geometry: "1280x720>",
                        format: :mp4,
                      }
                    }

  # streamio-ffmpeg style
  has_attached_file :attachment2,
                    processors: [:transcoder],
                    styles: {
                      thumb: {
                        format: :jpeg,
                        convert_options: {
                          resolution: "150x150",
                          screenshot: true,
                          seek_time: 3,
                        }
                        transcoder_options: {
                          preserve_aspect_ratio: :width
                        }
                      },
                      preview: {
                        format: :mp4,
                        convert_options: {
                          resolution: "320x240",
                          video_codec: "libx264",
                          frame_rate: 10,
                          video_bitrate: 300,
                        }
                      }
                    }
end
```

### Options

**geometry**

If modifier is not specified, keep the aspect ratio.

```
original file: 1280x720, geometry: 640x480, output: 640x360`
```

If `!` Or `#` is specified, resizing is done ignoring the aspect ratio.

```
original file: 1280x720, geometry: 640x480!, output: 640x480
```

If `>` is specified, it will be resized only if the resolution of the original file is greater than specified. The aspect ratio is kept.

```
original file: 1280x720, geometry: 640x480>,  output: 640x360
original file: 1280x720, geometry: 1920x1080>, output: 1280x720
```

If `<` is specified, it will be resized only if the resolution of the original file is less than specified. The aspect ratio is kept.

```
original file: 1280x720, geometry: 640x480<,  output: 1280x720
original file: 1280x720, geometry: 1920x1080<, output: 1920x1080
```

Please specify the resolution with convert_options instead of geometry if you want to perform more detailed conversion, such as keeping the aspect in accordance with the vertical width.

**format**

Output file format. If you do not specify a format, it will be output in the same format as the original file.

**convert_options**

Specify conversion option of streamio-ffmpeg. See more https://github.com/streamio/streamio-ffmpeg#transcoding .

If string is specified, its value becomes an argument to ffmpeg.


**transcoder_options**

Specify transcoder option of streamio-ffmpeg. See more https://github.com/streamio/streamio-ffmpeg#transcoding .

**screenshot**

Shorthand for `convert_options: { screenshot: true, seek_time: 3 }`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daichirata/paperclip-streamio-ffmpeg.
