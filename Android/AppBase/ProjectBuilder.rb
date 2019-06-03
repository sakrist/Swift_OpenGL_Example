require_relative "Tool.rb"
require 'yaml'

class ProjectBuilder < Tool

   attr_reader :component
#   attr_reader :toolchainDir
   
   def self.usage()
      tool = Tool.new()

      tool.print("\n1. Build project:", 32)
      tool.print("   $ make build\n", 36)
      
      tool.print(" Example:  $ make build:x86\n", 36)
      
      tool.print(" Example:  $ make build:x86 toolchain=~/Library/Android/sdk/swift-android-toolchain\n", 36)

      tool.print("\n2. Clean project:", 32)
      tool.print("   $ make clean\n", 36)
   end
   
   def self.perform()
      action = ARGV.first
      @toolchainDir = ARGV[1]
      if action.nil? then usage()
      elsif action == "build" then buildAll()
      elsif action.start_with?("build:") then build(action.sub("build:", ''))
      elsif action == "clean" then clean()
      else usage()
      end
   end
   
   def self.buildAll()
     Builder.new("armeabi-v7a", @toolchainDir).build()
     Builder.new("arm64-v8a", @toolchainDir).build()
     Builder.new("x86", @toolchainDir).build()
     Builder.new("x86_64", @toolchainDir).build()
   end

   def self.build(arch)
     Builder.new(arch, @toolchainDir).build()
   end
   
   def self.clean()
      Builder.new("armeabi-v7a").clean()
      Builder.new("arm64-v8a").clean()
      Builder.new("x86").clean()
      Builder.new("x86_64").clean()
   end
   
   def initialize(component, arch)
      @arch = arch
      @builds = "#{@root}/../app/build/swift/#{arch}"
    
      if @toolchainDir.nil?
          print("toolchainDir not found", 31)
          exit
      end
      
      @binary = "#{@builds}/#{component}"
      if @arch == "armeabi-v7a"
         @ndkArchPath = "arm-linux-androideabi"
      elsif @arch == "x86"
         @ndkArchPath = "i686-linux-android"
      elsif @arch == "arm64-v8a"
         @ndkArchPath = "aarch64-linux-android"
      elsif @arch == "x86_64"
         @ndkArchPath = "x86_64-linux-android"
      end
      @swiftc = @toolchainDir + "/bin/swiftc-" + @ndkArchPath
      @copyLibsCmd = @toolchainDir + "/bin/copy-libs-" + @ndkArchPath
   end

   def libs
      return Dir["#{@builds}/lib/*"]
   end

   def copyLibs()
      targetDir = "#{@builds}/lib"
      execute "rm -rf \"#{targetDir}\""
      execute "#{@copyLibsCmd} #{targetDir}"
   end
   
   def build
      clean()
      execute "mkdir -p \"#{@builds}\""
      executeBuild()
   end
   
   def clean
      execute "rm -rf \"#{@builds}\""
   end

end
