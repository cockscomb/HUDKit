Pod::Spec.new do |s|

  s.name    = "HUDKit"
  s.version = "1.0.0"
  s.summary = "HUDKit provides HUD interface as UIPresentationController."

  s.description = <<-DESC
    HUDKit provides the HUD interface as an implementation of
    UIPresentationController. You can show your any view controllers in the HUD
    panel.

    HUDKit provides HUDProgressViewController also. This can be used as progress
    HUD easily.
  DESC

  s.homepage = "https://github.com/cockscomb/HUDKit"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author           = { "Hiroki Kato" => "mail@cockscomb.info" }
  s.social_media_url = "https://twitter.com/cockscomb"

  s.platform = :ios, "8.0"

  s.source = { :git => "https://github.com/cockscomb/HUDKit.git", :tag => "#{s.version}" }

  s.source_files = "HUDKit/Classes/**/*.{swift}"
  s.resource     = "HUDKit/Classes/**/*.{xib}"

end
