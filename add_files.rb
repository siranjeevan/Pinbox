require 'xcodeproj'
project_path = 'Pinbox.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# recursive add files
def add_files(dir_path, group, target)
  Dir.foreach(dir_path) do |file|
    next if file == '.' or file == '..' or file == '.DS_Store'
    file_path = File.join(dir_path, file)
    if File.directory?(file_path)
      next if file == 'Pinbox.xcodeproj'
      # Find or create group
      sub_group = group.children.find { |g| g.display_name == file || g.path == file } || group.new_group(file, file)
      add_files(file_path, sub_group, target)
    else
      if file.end_with?('.swift') || file.end_with?('.xcassets')
        # Check if file is already added
        file_ref = group.children.find { |f| f.path == file }
        if file_ref.nil?
          file_ref = group.new_reference(file_path)
          if file.end_with?('.swift')
            target.add_file_references([file_ref])
          elsif file.end_with?('.xcassets')
            # For xcassets, add it to resources build phase
            target.add_resources([file_ref])
          end
        end
      end
    end
  end
end

main_group = project.main_group.children.find { |g| g.display_name == 'Pinbox' || g.path == 'Pinbox' }
if main_group.nil?
  puts "Could not find main group Pinbox"
  exit 1
end

add_files('Pinbox', main_group, target)
project.save
puts "Added files to Xcode project."
