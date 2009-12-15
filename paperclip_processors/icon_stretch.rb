module Paperclip
  class IconStretch < Processor

    class InstanceNotGiven < ArgumentError; end

    def initialize(file, options = {},attachment = nil)
      super
      @file = file
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      #@watermark        = RAILS_ROOT + "/public/images/watermark.png"
      @current_geometry   = Geometry.from_file file # This is pretty slow
      #@watermark_geometry = watermark_dimensions
    end

    def make
      w = @current_geometry.height.to_i
      h = @current_geometry.width.to_i
      if w < 507 and h < 380
        dst = Tempfile.new([@basename, @format].compact.join("."))
        ext = 380/h > 507/w ? "507" : "x380"
        command = "-resize #{ext} #{File.expand_path(@file.path)} #{File.expand_path(dst.path)}"
        begin
          success = Paperclip.run("convert", command.gsub(/\s+/, " "))
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error processing the icon stretch for #{@basename}" if @whiny_thumbnails
        end
      end
      return dst || file
    end

  end
end

