require 'rubygems'
require 'gosu'
require 'rmagick'
include Magick

class Shuffler < Gosu::Window
  PADDING = 20
  
  def initialize

    @black_tile = 16
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
    @image = {}
    16.times{|i| @image[i] = Array.new(2)}
    counter = 0
    5.times{|i| @x_cord << @crop_x*i;@y_cord << @crop_y*i }
    4.times do |y|
        4.times do |x|
            if x == 3 and y == 3
                magic = Magick::Image.new(@crop_x, @crop_y) { self.background_color = 'black' }
                magic = magic.border(3, 3, 'black')
            else
                magic = magick_pic.crop(@x_cord[x], @y_cord[y], @x_cord[x+1], @y_cord[y+1])
                magic = magic.border(3, 3, 'black')
            end
            @image[counter][0] = Gosu::Image.new(magic)
            @image[counter][1] = counter
            counter +=1
        end
    end
  end


  def draw
    counter = -1
    4.times do |y|
        4.times do |x| 
            counter+=1
            @image[counter].first.draw @x_cord[x], @y_cord[y], 0
        end
    end
  end

  def move_left
    tile = @image.find {|k, v| v.last == 15}
    unless [0, 4, 8, 12].include? tile.first
      @image[tile.first], @image[tile.first-1] = @image[tile.first-1], @image[tile.first]
    end
  end

  def move_right
    tile = @image.find {|k, v| v.last == 15}
    unless [3, 7, 11, 15].include? tile.first
      @image[tile.first], @image[tile.first+1] = @image[tile.first+1], @image[tile.first]
    end
  end

  def move_up   
    tile = @image.find {|k, v| v.last == 15}
    unless [0, 1, 2, 3].include? tile[0]
      @image[tile.first], @image[tile.first-4] = @image[tile.first-4], @image[tile.first]
    end
  end

  def move_down
    tile = @image.find {|k, v| v.last == 15}
    unless [12, 13, 14, 15].include? tile.first
      @image[tile.first], @image[tile.first+4] = @image[tile.first+4], @image[tile.first]
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    elsif id == Gosu::KB_LEFT
      move_left
    elsif id == Gosu::KB_RIGHT
      move_right
    elsif id == Gosu::KB_UP
      move_up
    elsif id == Gosu::KB_DOWN
      move_down
    end
  end

end

Shuffler.new.show