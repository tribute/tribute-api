RSpec.configure do |config|
  config.before(:all) do
    # fetch unique index names
    @unique_indexes = []
    Dir[File.join(File.dirname(__FILE__), "../../app/models/*.rb")].each do |f|
      klass = "Tribute::Models::#{File.basename(f, ".rb").camelize}"
      klazz = klass.constantize
      next unless klazz.respond_to?(:index_options)
      klazz.index_options.each_pair do |name, options|
        next unless options[:unique]
        @unique_indexes << [ klass, name, options ]
      end
    end
  end
  config.before(:each) do
    Mongoid.purge!
    # create unique indexes
    @unique_indexes.each do |klass, name, options|
      klass.constantize.collection.indexes.create(name, options)
    end
  end
  config.after(:all) do
    Mongoid.default_session.drop
  end
end
