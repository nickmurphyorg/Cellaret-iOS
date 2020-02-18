# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Cellaret' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # use_frameworks!
  use_modular_headers!

  # Plugins
  plugin 'cocoapods-keys', {
  :project => "Cellaret",
  :keys => [
    "apiToken"
  ]}

  target 'CellaretTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
