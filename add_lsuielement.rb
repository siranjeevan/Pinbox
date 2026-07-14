require 'xcodeproj'
project_path = 'Pinbox.xcodeproj'
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  target.build_configurations.each do |config|
    config.build_settings['INFOPLIST_KEY_LSUIElement'] = 'YES'
  end
end

project.save
puts "Added LSUIElement to build settings"
