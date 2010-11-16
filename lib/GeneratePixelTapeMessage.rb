#
# Get Text
# Determine number of characters
# Create wrapping image size
# extract image sprite from master
# join using composite method
# if we don't have the char then get creative!
=begin
class Rectangle
	def initialize(y, x, height, width, linecolor, fillcolor)
		@y         =         y                      
		@x         =         x
		@height    =    height
		@width     =     width
		@linecolor = linecolor
		@fillcolor = fillcolor
		@linewidth = 1
	end
	attr_accessor :y, :x, :height, :width, :linecolor, :fillcolor, :linewidth
end
=end

class GeneratePixelTapeMessage

    attr_accessor :label_text
    
    

    def initialize(label_text)
      
        # load data from yaml file
        @pixel_tape_data = YAML::load(File.open(File.dirname(__FILE__)+'/app_config.yml'))
 
 
        file = File.dirname(__FILE__)+'/pixeltape-alpha.jpg'
        @sprite_image = Magick::Image::read(file).first

        @label_text = label_text
        #self.generate_label
    end

    def generate_label(height)

        offset = 0
        
        #Create master image
        self.generate_master_image
        
        @label_text.split(//).each do |char|
             
             if have_char?(char)
                char_img = @sprite_image.excerpt(@pixel_tape_data[:char_data][char][:x], @pixel_tape_data[:char_data][char][:y], @pixel_tape_data[:char_data][char][:width], @pixel_tape_data[:char_data][char][:height])
	           else
		            char_img = generate_alternative(char)
	           end
	          
	          # Add to master image and increment spacing
            @temp_image = @temp_image.composite(char_img, offset, 0, Magick::OverCompositeOp)
          
            #increment offset
            offset = offset + @pixel_tape_data[:char_data][char][:width]
        end        
        
        
        
        @temp_image.change_geometry!("x#{safe_height(height)}") { |cols, rows, img|
         img.resize!(cols, rows)
         }
        

        return @temp_image

    end


    
    
    def generate_master_image
      
      @temp_image = Magick::Image.new(self.count_characters * @pixel_tape_data[:image_sprite_width], @pixel_tape_data[:image_sprite_height])
      
    end

    def have_char?(char)

        return @pixel_tape_data[:available_chars].include?(char)

        
    end

    def generate_alternative(char)
        # load creative file and perform lookup
      	return @pixel_tape_data[:alternate_char_data][char]
    end

    def tokenize_string
        return @label_text.split(//)
    end

    def count_characters
        return @label_text.length
    end
    
    def scale_factor
      return @pixel_tape_data[:image_sprite_width] / @pixel_tape_data[:image_sprite_height]
    end
    
    def scale_width(new_height)
      return self.scale_factor * self.count_characters * new_height
    end
    
    def safe_height(height)
      if @pixel_tape_data[:available_sizes].include?(height)
        return height
      else
        return "225"
      end
    end


end
