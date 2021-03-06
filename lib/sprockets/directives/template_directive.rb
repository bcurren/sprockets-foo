require "ejs-rcompiler"

module Sprockets
  module Directives
    class TemplateDirective < RequireDirective
      def self.pattern
        /(template)\s+(#{ANGLED_STRING})/
      end
      
      def evaluate_in(preprocessor)
        if template_file_path
          compile_ejs(template_file_path.to_s)
          super(preprocessor)
        else
          raise_load_error
        end
      end
      
      protected
        
        def compile_ejs(source_file)
          compiler = Ejs::Compiler.new
          compiler.compile(source_file, namespace)
        end
        
        def namespace
          dir = File.dirname(require_location)
          dir == "." ? nil : dir.gsub(/\//, ".")
        end
        
        def template_file_path
          @template_file_path ||= location_finder.find(normalize_template(require_location))
        end
        
        def normalize_template(location)
          File.join(File.dirname(location), File.basename(location, ".ejs") + ".ejs")
        end
    end
  end
end
