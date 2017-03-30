require 'rubygems'
require 'gosu'
require 'rmagick'

WIDTH, HEIGHT = 640, 480

class Shuffler < Gosu::Window
  PADDING = 20
  
  def initialize
    super WIDTH, HEIGHT
    
    self.caption = "Welcome!"
    
    magick_pic = Magick::Image.read("naruto.jpg").first
    @pic = Gosu::Image.new(magick_pic)
    puts @pic.height
    puts @pic.width   
    # magick_pic_1 = magick_pic.crop(0, 0, 100, 100)
    # magick_pic_2 = magick_pic.crop(0, 100 , 100, 100)
    # magick_pic_3 = magick_pic.crop(0, 200, 100, 100)

    # @pic_1 = Gosu::Image.new(magick_pic_1)
    # @pic_2 = Gosu::Image.new(magick_pic_2)
    # @pic_3 = Gosu::Image.new(magick_pic_3)

    # num_slices = 9
    # @pic = []
    # slice_height = magick_pic.y_resolution / num_slices
    # (0...num_slices).collect { |i|
    #   magick_pic.crop(
    #     0, i * slice_height,
    #     magick_pic.x_resolution, slice_height,
    #     true # reset image offset
    #   )
    #   @pic << Gosu::Image.new(magick_pic, :tileable => true)
    # }    
  
  end
  
  def draw

    @pic.draw 20, 20, 0
    # @pic_1.draw 20, 20, 0
    # @pic_2.draw 20, 120, 0
    # @pic_3.draw 20, 220, 0
    # end
  end

end

Shuffler.new.show