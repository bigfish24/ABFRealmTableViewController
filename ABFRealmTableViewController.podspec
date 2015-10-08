Pod::Spec.new do |s|
  s.name         = "ABFRealmTableViewController"
  s.version      = "1.2"
  s.summary      = "Realm Data-Binding For UITableView"
  s.description  = <<-DESC
The ABFRealmTableViewController class is a subclass of UITableViewController but adds data-binding to an RLMObject subclass.
                   DESC
  s.homepage     = "https://github.com/bigfish24/ABFRealmTableViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Fish" => "af@realm.io" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/bigfish24/ABFRealmTableViewController.git", :tag => "v#{s.version}" }
  s.source_files  = "ABFRealmTableViewController/*.{h,m}"
  s.requires_arc = true
  s.dependency "RBQFetchedResultsController", ">= 2.3"
  s.dependency "Realm", ">= 0.95.1"

end