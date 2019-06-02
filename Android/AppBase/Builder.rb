require_relative "ProjectBuilder.rb"

# See also:
# - ios - How to open a .swiftmodule file - Stack Overflow: http://bit.ly/2HET1d9

class Builder < ProjectBuilder

   def initialize(arch = Arch.default)
      component = "appbase"
      @root = File.dirname(__FILE__)
      super(component, arch)
   end

   def executeBuild
       
       moduleName = "AppBase"

       @sourcesPath = "#{@root}/../../Sources/#{moduleName}"
       sourcesFiles = " "
       filesArray = `ls "#{@sourcesPath}/"`.split("\n")
       filesArray.each { |file| 
           sourcesFiles << "#{@sourcesPath}/"
           sourcesFiles << file
           sourcesFiles << " "
       }
       
      # Lib
      binary = "#{@builds}/lib#{moduleName}.so"
      execute "cd #{@builds} && #{@swiftc} -swift-version 5 -emit-library -j4 -DSWIFT_PACKAGE -emit-dependencies -emit-module -parse-as-library -module-name #{moduleName} -o #{binary} #{sourcesFiles}"
      execute "file #{binary}"

      
      # Swift Libs
      # copyLibs()
   end

   def libs
      value = super
      value += Dir["#{@builds}/*.so"]
      return value
   end

end
