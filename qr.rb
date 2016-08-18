require 'rqrcode'
require 'csv'
require 'RMagick'

include Magick

CSV_DIR = "csv"
OUTPUT_DIR = "output"

def cleanup
  system("rm #{OUTPUT_DIR}/png/box/*")
  system("rm #{OUTPUT_DIR}/png/shelf/*")
  system("rm #{OUTPUT_DIR}/png/fridge/*")
  system("rm #{OUTPUT_DIR}/pdf/*")
end

def load_csv(filename)
  csv = CSV.foreach(filename, col_sep: ',', headers: true, :header_converters => :symbol, :converters => :all)
  csv = csv.to_a.map { |row| row.to_hash }
  csv
end

def write_png(content, filename, obj)
  qrcode = RQRCode::QRCode.new(content)
  image = qrcode.as_png(size: 250)
  IO.write("#{OUTPUT_DIR}/png/#{obj}/#{filename}", image.to_s)
end

def annotate_png(legend, filename, obj)
  png_filename = "#{OUTPUT_DIR}/png/#{obj}/#{filename}"
  image = Magick::Image.read(png_filename).first
  text = Magick::Draw.new
  text.font_family = 'helvetica'
  text.pointsize = 20
  text.gravity = Magick::SouthGravity
  text.annotate(image, 0,0,0,0, legend)
  image.write(png_filename)
end

def write_pdf(obj)
  list = Magick::ImageList.new
  Dir["#{OUTPUT_DIR}/png/#{obj}/*"].each do |i|
    list << Magick::Image.read(i).first()
  end
  list.write("#{OUTPUT_DIR}/pdf/#{obj}.pdf")
end

cleanup()

boxes = load_csv("#{CSV_DIR}/box.csv")
boxes.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "box")
  annotate_png("#{b[:name]} | #{b[:vaccine_type]}", "#{b[:name]}.png", "box")
end
write_pdf("box")

shelves = load_csv("#{CSV_DIR}/shelf.csv")
shelves.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "shelf")
  annotate_png("#{b[:name]} | #{b[:vaccine_type]}", "#{b[:name]}.png", "shelf")
end
write_pdf("shelf")

fridges = load_csv("#{CSV_DIR}/fridge.csv")
fridges.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "fridge")
  annotate_png("#{b[:name]}", "#{b[:name]}.png", "fridge")
end
write_pdf("fridge")

# boxes = CSV.foreach("#{CSV_DIR}/box.csv", col_sep: ',', headers: true, :header_converters => :symbol, :converters => :all)
# boxes = boxes.to_a.map { |row| row.to_hash }
#
# boxes.each do |b|
#   qrcode = RQRCode::QRCode.new(b[:name])
#   image = qrcode.as_png(size: 250)
#   IO.write("#{OUTPUT_DIR}/box/#{b[:name]}.png", image.to_s)
#
#   image = Magick::Image.read("#{OUTPUT_DIR}/box/#{b[:name]}.png").first
#   text = Magick::Draw.new
#   text.font_family = 'helvetica'
#   text.pointsize = 20
#   text.gravity = Magick::SouthGravity
#   text.annotate(image, 0,0,0,0, "#{b[:name]} | #{b[:vaccine_type]}")
#   image.write("#{OUTPUT_DIR}/box/#{b[:name]}.png")
# end
#
# list = Magick::ImageList.new
# Dir["#{OUTPUT_DIR}/box/*"].each do |i|
#   list << Magick::Image.read(i).first()
# end
# list.write("pdf/box.pdf")
#
#
# shelves = CSV.foreach("#{CSV_DIR}/shelf.csv", col_sep: ',', headers: true, :header_converters => :symbol, :converters => :all)
# shelves = shelves.to_a.map { |row| row.to_hash }
#
# shelves.each do |s|
#   qrcode = RQRCode::QRCode.new(s[:name])
#   image = qrcode.as_png(size: 250)
#   IO.write("#{OUTPUT_DIR}/shelf/#{s[:name]}.png", image.to_s)
#
#   image = Magick::Image.read("#{OUTPUT_DIR}/shelf/#{s[:name]}.png").first
#   text = Magick::Draw.new
#   text.font_family = 'helvetica'
#   text.pointsize = 20
#   text.gravity = Magick::SouthGravity
#   text.annotate(image, 0,0,0,0, "#{s[:name]} | #{s[:vaccine_type]}")
#   image.write("#{OUTPUT_DIR}/shelf/#{s[:name]}.png")
# end
#
# list = Magick::ImageList.new
# Dir["#{OUTPUT_DIR}/shelf/*"].each do |i|
#   list << Magick::Image.read(i).first()
# end
# list.write("pdf/shelf.pdf")
#
# fridges = CSV.foreach("#{CSV_DIR}/fridge.csv", col_sep: ',', headers: true, :header_converters => :symbol, :converters => :all)
# fridges = fridges.to_a.map { |row| row.to_hash }
# fridges.each do |f|
#   qrcode = RQRCode::QRCode.new(f[:name])
#   image = qrcode.as_png(size: 250)
#   IO.write("#{OUTPUT_DIR}/fridge/#{f[:name]}.png", image.to_s)
#
#   image = Magick::Image.read("#{OUTPUT_DIR}/fridge/#{f[:name]}.png").first
#   text = Magick::Draw.new
#   text.font_family = 'helvetica'
#   text.pointsize = 20
#   text.gravity = Magick::SouthGravity
#   text.annotate(image, 0,0,0,0, "#{f[:name]}")
#   image.write("#{OUTPUT_DIR}/fridge/#{f[:name]}.png")
# end
#
# list = Magick::ImageList.new
# Dir["#{OUTPUT_DIR}/fridge/*"].each do |i|
#   list << Magick::Image.read(i).first()
# end
# list.write("pdf/fridge.pdf")