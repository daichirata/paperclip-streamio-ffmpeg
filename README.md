# paperclip-streamio-ffmpeg

Video Transcoder for Paperclip using [streamio/streamio-ffmpeg](https://github.com/streamio/streamio-ffmpeg).

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

* geometry
  * See more https://github.com/thoughtbot/paperclip#post-processing .
* format
  * output file format.
* convert_options
  * See more https://github.com/streamio/streamio-ffmpeg#transcoding .
* transcoder_options
  * See more https://github.com/streamio/streamio-ffmpeg#transcoding .
* screenshot
  * shorthand for `convert_options: { screenshot: true, seek_time: 3 }`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daichirata/paperclip-streamio-ffmpeg.
