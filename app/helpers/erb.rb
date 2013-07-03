module Tribute
  module Helpers
    module Erb
      def erb(template, locals = {})
      	klass = Class.new(OpenStruct) do
  		  def render(template)
    	    ERB.new(template).result(binding)
  		  end
		end
		klass.new(locals).render(File.read(File.join(File.dirname(__FILE__), "../views/#{template}")))
      end
    end
  end
end


