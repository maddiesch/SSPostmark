TARGET_NAME      = "SSPostmarkTests"
TEST_SDK         = "iphonesimulator"

task :default => :test

task :test do 
  com = "xcodebuild -target \"#{TARGET_NAME}\" -sdk #{TEST_SDK} TEST_AFTER_BUILD=YES GCC_PREPROCESSOR_DEFINITIONS=\"TEST=1\" | grep Executed"
  return_val = `#{com}`
  puts "**************************\n#{return_val.split("\n").last}"
end

namespace :doc do 
  desc "Generate AppleDoc documentation"
  task :generate do |t, args|
    `appledoc .`
  end
  desc "Open the docs in default browser"
  task :open do |t, args|
    `open ./Documentation/html/index.html`
  end
  desc "Generate then open the docs"
  task :generate_open do |t, args|
    Rake::Task["doc:generate"].invoke
    Rake::Task["doc:open"].invoke
  end
end

