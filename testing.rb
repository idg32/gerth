require 'cli_pix'
file_path = "green_sq.png"
image = CliPix::Image.from_file(file_path, autoscale: false)
#image.size = [2,2]
image.display