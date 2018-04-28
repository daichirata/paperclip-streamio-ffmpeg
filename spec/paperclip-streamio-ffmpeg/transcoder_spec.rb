require "spec_helper"

RSpec.describe Paperclip::Transcoder do
  let(:dummy_file) do
    double("dummy file", path: "dummy/path.#{file_extension}")
  end

  let(:file_resolution) do
    "1280x720"
  end

  let(:file_extension) do
    "mp4"
  end

  let(:options) do
    {}
  end

  let(:transcoder) do
    Paperclip::Transcoder.new(dummy_file, options)
  end

  let(:dummy_movie) do
    double("dummy movie",
           resolution: file_resolution,
           metadata: { error: { string: "error" } })
  end

  before do
    allow(FFMPEG::Movie).to receive(:new) { dummy_movie }
  end

  describe "#initialize" do
    describe "convert_options" do
      subject do
        transcoder.instance_variable_get("@convert_options")
      end

      context "when passing hash" do
        let(:options) do
          { convert_options: { screenshot: true } }
        end

        it { is_expected.to eq(options[:convert_options]) }
      end

      context "when passing string" do
        let(:options) do
          { convert_options: "-vf crop=60:60:10:10 -map 0:0 -map 0:1" }
        end

        it { is_expected.to eq({ custom: options[:convert_options].split(" ") }) }
      end
    end
  end

  describe "#make" do
    before do
      allow(dummy_movie).to receive(:valid?) { true }
    end

    describe "format" do
      context "when specifying a file format" do
        let(:options) do
          { format: "flv" }
        end

        it "should be output in specified format" do
          expect(dummy_movie).to receive(:transcode).with(end_with(".flv"), {}, {})
          dst = transcoder.make
          expect(dst.path).to end_with(".flv")
        end
      end

      context "when format is not specified" do
        let(:file_extension) do
          "flv"
        end

        it "should be output in original file format" do
          expect(dummy_movie).to receive(:transcode).with(end_with(".flv"), {}, {})
          dst = transcoder.make
          expect(dst.path).to end_with(".flv")
        end
      end
    end

    describe "geometry" do
      context "when specifying geometry without modifier" do
        let(:options) do
          { geometry: "640x480" }
        end

        it "should be resized while keeping the aspect ratio" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "640x360" }, {})
          transcoder.make
        end
      end

      context "when specifying geometry containing modifier `!`" do
        let(:options) do
          { geometry: "640x480!" }
        end

        it "should be resized ignoring aspect ratio" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "640x480" }, {})
          transcoder.make
        end
      end

      context "when specifying geometry smaller than the original file containing modifier `>`" do
        let(:options) do
          { geometry: "640x480>" }
        end

        it "should be resized while keeping the aspect ratio" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "640x360" }, {})
          transcoder.make
        end
      end

      context "when specifying geometry larger than the original file containing modifier `>`" do
       let(:options) do
          { geometry: "1920x1080>" }
        end

        it "should be converted with original file resolution" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "1280x720" }, {})
          transcoder.make
        end
      end

      context "when specifying geometry smaller than the original file containing modifier `<`" do
        let(:options) do
          { geometry: "640x480<" }
        end

        it "should be converted with original file resolution" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "1280x720" }, {})
          transcoder.make
        end
      end

      context "when specifying geometry larger than the original file containing modifier `<`" do
        let(:options) do
          { geometry: "1920x1080<" }
        end

        it "should be resized while keeping the aspect ratio" do
          expect(dummy_movie).to receive(:transcode).with(anything, { resolution: "1920x1080" }, {})
          transcoder.make
        end
      end
    end

    describe "screenshot" do
      context "when specifying a screenshot" do
        let(:options) do
          { screenshot: true }
        end

        it "should be specified screenshot settings" do
          expect(dummy_movie).to receive(:transcode).with(anything, { screenshot: true, seek_time: 3 }, {})
          transcoder.make
        end
      end
    end

    describe "transcoder_options" do
      context "when specifying a transcoder_options" do
        let(:options) do
          { transcoder_options: { preserve_aspect_ratio: :width } }
        end

        it "should be set transcoder_options" do
          expect(dummy_movie).to receive(:transcode).with(anything, {}, options[:transcoder_options])
          transcoder.make
        end
      end
    end

    context "when the file was not a movie" do
      before do
        allow(dummy_movie).to receive(:valid?) { false }
      end

      it "should return original file" do
        expect(transcoder.make).to eq(dummy_file)
      end
    end
  end
end
