Pod::Spec.new do |s|
  s.name         = "RealmTableViewController"
  s.version      = "1.2"
  s.summary      = "Realm Swift Data-Binding For UITableView"
  s.description  = <<-DESC
The RealmTableViewController class is a subclass of UITableViewController but adds data-binding to a Realm Swift object subclass.
                   DESC
  s.homepage     = "https://github.com/bigfish24/ABFRealmTableViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Fish" => "af@realm.io" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/bigfish24/ABFRealmTableViewController.git", :tag => "v#{s.version}" }
  s.source_files  = "RealmTableViewController/*.{swift}"
  s.requires_arc = true
  s.dependency "SwiftFetchedResultsController", ">= 2.3"
  s.dependency "RealmSwift", ">= 0.95.1"

end