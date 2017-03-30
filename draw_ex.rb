#!/usr/bin/env ruby -w
#
# Simple demo program for RMagick
#
# Concept and algorithms lifted from Magick++ demo script written
# by Bob Friesenhahn.
#
require 'rmagick'
include Magick

#
#   RMagick version of Magick++/demo/demo.cpp
#

Font = 'Helvetica'

begin
  puts 'Read images...'

  model = ImageList.new('model.miff')
  model.border_color = 'black'
  model.background_color = 'black'
  model.cur_image[:Label] = 'RMagick'

  smile = ImageList.new('smile.miff')
  smile.border_color = 'black'
  smile.cur_image[:Label] = 'Smile'

  #
  #   Create image stack
  #
  puts 'Creating thumbnails'

  # Construct an initial list containing five copies of a null
  # image. This will give us room to fit the logo at the top.
  # Notice I specify the width and height of the images via the
  # optional "size" attribute in the parm block associated with
  # the read method. There are two more examples of this, below.
  example = ImageList.new
  5.times { example.read('NULL:black') { self.size = '70x70'} }

  puts '   draw...'
  # example << model.cur_image.copy
  # example.cur_image[:Label] = 'Draw'
  gc = Draw.new
  gc.fill 'black'
  # gc.fill_opacity 0
  # gc.stroke 'gold'
  # gc.stroke_width 2
  gc.rectangle 100,100,200,200
  gc.draw(model)

  #
  #   Create image montage - notice the optional
  #   montage parameters are supplied via a block
  #

  puts 'Montage images...'

  montage = example.montage do
    self.geometry = '130x194+10+5>'
    self.gravity = CenterGravity
    self.border_width = 1
    rows = (example.size + 4) / 5
    self.tile = Geometry.new(5,rows)
    self.compose = OverCompositeOp

    # Use the ImageMagick built-in "granite" format
    # as the background texture.

    #       self.texture = Image.read("granite:").first
    self.background_color = 'white'
    self.font = Font
    self.pointsize = 18
    self.fill = '#600'
    self.filename = 'RMagick Demo'
    #       self.shadow = true
    #       self.frame = "20x20+4+4"
  end

  # Add the ImageMagick logo to the top of the montage. The "logo:"
  # format is a fixed-size image, so I don't need to specify a size.
  puts 'Adding logo image...'
  logo = Image.read('logo:').first
  if /GraphicsMagick/.match Magick_version
    logo.resize!(200.0/logo.rows)
  else
    logo.crop!(98, 0, 461, 455).resize!(0.45)
  end

  # Create a new Image for the composited montage and logo
  montage_image = ImageList.new
  montage_image << montage.composite(logo, 245, 0, OverCompositeOp)

  # Write the result to a file
  montage_image.compression = RLECompression
  montage_image.matte = false
  puts 'Writing image ./rm_demo_out.miff'
  montage_image.write 'rm_demo_out.miff'

# Uncomment the following lines to display image to screen
# puts "Displaying image..."
# montage_image.display

rescue
  puts "Caught exception: #{$ERROR_INFO}"
end

puts <<END_INFO

This example demonstrates the export_pixels and import_pixels methods
by copying an image one row at a time. The result is an copy that
is identical to the original.

END_INFO

img = Image.read('rm_demo_out.miff').first
copy = Image.new(img.columns, img.rows)

begin
  img.rows.times do |r|
    scanline = img.export_pixels(0, r, img.columns, 1, 'RGB')
    copy.import_pixels(0, r, img.columns, 1, 'RGB', scanline)
  end
rescue NotImplementedError
  $stderr.puts 'The export_pixels and import_pixels methods are not supported' \
               ' by this version of ImageMagick/GraphicsMagick'
  exit
end

copy.write('copy.gif')

exit