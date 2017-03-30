require 'rubygems'
require 'gosu'
require 'rmagick'
include Magick

class Shuffler < Gosu::Window
  PADDING = 20
  
  def initialize

    magick_pic = Magick::Image.read("naruto.jpg").first
    @pic = Gosu::Image.new(magick_pic)
    
    width = @pic.width + 6
    height = @pic.height + 6 
    
    super width, height
    
    self.caption = "Great Shuffler!"
    @crop_x = @pic.width / 4
    @crop_y = @pic.height / 4
    @x_cord = []
    @y_cord = []
    @image = []
    5.times{|i| @x_cord << @crop_x*i;@y_cord << @crop_y*i }
    4.times do |y|
        4.times do |x|
            if x == 3 and y == 3
                puts "inside if"
                magic = Magick::Image.new(@crop_x, @crop_y) { self.background_color = 'black' }
                magic = magic.border(3, 3, 'black')
            else
                magic = magick_pic.crop(@x_cord[x], @y_cord[y], @x_cord[x+1], @y_cord[y+1])
                magic = magic.border(3, 3, 'black')
            end
            @image << Gosu::Image.new(magic)
        end
    end
  end


  def draw
    counter = -1
    4.times do |y|
        4.times do |x| 
            counter+=1
            @image[counter].draw @x_cord[x], @y_cord[y], 0
        end
    end
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @image[@black_tile], @image[@black_tile-1] = @image[@black_tile-1], @image[@black_tile]
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @image[@black_tile], @image[@black_tile+1] = @image[@black_tile+1], @image[@black_tile]
    end
    if Gosu.button_down? Gosu::KB_UP
      @image[@black_tile], @image[@black_tile-4] = @image[@black_tile-4], @image[@black_tile]
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @image[@black_tile], @image[@black_tile+4] = @image[@black_tile+4], @image[@black_tile]
    end
  end

end

Shuffler.new.show