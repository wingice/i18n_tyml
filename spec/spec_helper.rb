current_dir = File.expand_path(File.dirname(__FILE__))
$:.unshift File.join(current_dir, "..", "lib")


Dir["#{current_dir}/support/**/*.rb"].each do |file|
  require file
end


