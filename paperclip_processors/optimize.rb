module Paperclip
  class Optimize < Processor

    class InstanceNotGiven < ArgumentError; end

    def initialize(file, options = {},attachment = nil)
      super
      @file = file
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @current_geometry   = Geometry.from_file file # This is pretty slow
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      command = "-optimize #{File.expand_path(@file.path)} > #{File.expand_path(dst.path)}"
      begin
        success = Paperclip.run("jpegtran", command.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny_thumbnails
      end
      dst
    end

  end
end

