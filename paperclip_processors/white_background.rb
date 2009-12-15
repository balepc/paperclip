module Paperclip
  class WhiteBackground < Processor

    class InstanceNotGiven < ArgumentError; end

    def initialize(file, options = {},attachment = nil)
      super
      @file = file
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @watermark        = RAILS_ROOT + "/public/images/watermark.png"
      @current_geometry   = Geometry.from_file file # This is pretty slow
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      command = "-background white -gravity center -extent 507x380 +repage #{File.expand_path(@file.path)} #{File.expand_path(dst.path)}"
      begin
        success = Paperclip.run("convert", command.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny_thumbnails
      end
      dst
    end

  end
end

