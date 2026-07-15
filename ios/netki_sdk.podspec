#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint netki_sdk.podspec` to validate before publishing.
#

# Source of truth for the bridge version is pubspec.yaml. The bump-version
# workflow updates only pubspec; reading it here keeps s.version (and the
# NetkiBridgeVersion injected below) in sync automatically.
def self.read_pubspec_version
  pubspec_path = File.join(__dir__, '..', 'pubspec.yaml')
  line = File.readlines(pubspec_path).find { |l| l.start_with?('version:') }
  raise "version not found in #{pubspec_path}" unless line
  # Strip Flutter's +build-number suffix; preserve pre-release tags (-beta, etc.)
  line.sub('version:', '').strip.split('+').first
end

Pod::Spec.new do |s|
  s.name             = 'netki_sdk'
  s.version          = read_pubspec_version
  s.summary          = 'NetkiSDK Flutter plugin for identity verification'
  s.description      = <<-DESC
Flutter plugin that bridges the native NetkiSDK for iOS and Android,
providing identity verification and onboarding capabilities.
                       DESC
  s.homepage         = 'https://netki.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Netki' => 'support@netki.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'NetkiSDK', '~> 12.0.1'
  s.platform = :ios, '17.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # NetkiBridgeVersion is read at runtime by NetkiSDK (>= 11.6.0) which scans
  # all loaded framework bundles for this key. Tracks the Flutter bridge
  # version in transaction_metadata.bridge_version.
  s.info_plist = {
    'NetkiBridgeVersion' => s.version.to_s
  }

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'netki_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
