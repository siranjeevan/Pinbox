require 'xcodeproj'

project_path = 'Pinbox.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Check if package is already added
pkg_url = 'https://github.com/sindresorhus/KeyboardShortcuts'
pkg_ref = project.root_object.package_references.find { |p| p.repositoryURL == pkg_url }

if pkg_ref.nil?
  # Create XCRemoteSwiftPackageReference
  pkg_ref = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
  pkg_ref.repositoryURL = pkg_url
  pkg_ref.requirement = {
    'kind' => 'upToNextMajorVersion',
    'minimumVersion' => '2.0.0'
  }
  project.root_object.package_references << pkg_ref

  # Create XCSwiftPackageProductDependency
  target = project.targets.first
  pkg_dep = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
  pkg_dep.package = pkg_ref
  pkg_dep.product_name = 'KeyboardShortcuts'
  
  target.package_product_dependencies << pkg_dep
  
  # Ensure the framework is linked
  build_phase = target.frameworks_build_phase
  # But we can't easily add XCSwiftPackageProductDependency to the build phase without a PBXBuildFile in xcodeproj gem easily...
  # Actually, Xcodeproj provides `add_dependency` but it's for targets.
  # Let's manually add PBXBuildFile
  build_file = project.new(Xcodeproj::Project::Object::PBXBuildFile)
  build_file.product_ref = pkg_dep
  build_phase.files << build_file

  project.save
  puts "Added KeyboardShortcuts package dependency."
else
  puts "KeyboardShortcuts package already exists."
end
