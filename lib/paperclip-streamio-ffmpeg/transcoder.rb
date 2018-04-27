require "streamio-ffmpeg"

module Paperclip
  class Transcoder < Processor
    def initialize(file, options = {}, attachment = nil)
      super

      @movie = FFMPEG::Movie.new(file.path)

      @target_geometry    = options.fetch(:string_geometry_parser, Geometry).parse(options[:geometry])
      @current_geometry   = options.fetch(:file_geometry_parser, Geometry).parse(@movie.resolution)
      @convert_options    = options.fetch(:convert_options, {})
      @convert_options    = { custom: @convert_options.split(/\s+/) } if @convert_options.respond_to?(:split)
      @transcoder_options = options.fetch(:transcoder_options, {})
      @screenshot         = options.fetch(:screenshot, false)
      @whiny              = options.fetch(:whiny, true)
      @format             = options[:format]
      @current_format     = File.extname(file.path)
      @basename           = File.basename(file.path, @current_format)
    end

    def make
      unless @movie.valid?
        Paperclip.log("[transcoder] #{@movie.metadata[:error][:string]} #{@file.path}")
        return @file
      end

      dst = Paperclip::TempfileFactory.new.generate(
        [@basename, @format ? ".#{@format}" : @current_format].join
      )

      begin
        options = {}
        if @screenshot
          options.merge!(screenshot: true, seek_time: 3)
        end
        if @current_geometry.present? && @target_geometry.present?
          options.merge!(resolution: @current_geometry.resize_to(@target_geometry.to_s).to_s)
        end
        @movie.transcode(dst.path, options.merge(@convert_options), @transcoder_options)
      rescue FFMPEG::Error
        raise Paperclip::Error, "There was an error processing the transcoder for #{@basename}" if @whiny
      end

      dst
    end
  end
end
