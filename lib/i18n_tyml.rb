require "forwardable"
require "i18n_tyml/version"
require "i18n_tyml/hash_deep_merge"

module I18nTyml
  class TranslationManager
    extend Forwardable
    def_delegators :@translations, :[]

    attr_accessor  :dest_path
    
    def initialize(dest_path)
      @dest_path = dest_path
      @translations = Hash.new
    end

    
    def translations
      @translations
    end

    def add_translations(trs)
      #puts "TRS: "+translations.inspect
      #puts "TRS: "+trs.inspect
      translations.deep_safe_merge!(trs)
    end

    def search_missing(lang=nil)
      collect_translations
      #puts "TRANS: "+translations.inspect
      get_missing_translations(collect_translation_queries, lang ? [lang] : translations.keys)
    end

    def collect_translations
      locales_pathes = ["config/locales/**/*.yml", "vendor/plugins/**/config/locales/**/*yml", "vendor/plugins/**/locale/**/*yml"]
      locales_pathes.each do |path|
        Dir.glob(path) do |file|
          file_content = translations_in_file(file)
          add_translations(file_content) if file_content
        end
      end
    end

    def collect_translation_queries
      target_files.each_with_object({}) do |file, queries|
        queries_in_file = translation_refs_in(file)
        if queries_in_file.any?
          #puts "DEBUG: "+queries_in_file[0][0].to_s+": "+queries_in_file[0][1].to_s
          queries[file] = queries_in_file
        end
      end
      #TODO: remove duplicate queries across files
    end

    def target_files
      path = @dest_path
      path = path[0...-1] if path[-1..-1] == '/'
      [ Dir.glob("#{path}/**/*.erb"), Dir.glob("#{path}/**/*.rb") ].flatten
    end


    def read_content_of_file(file)
      f = open(File.expand_path(file), "r")
      content = f.read()
      f.close()
      content
    end

    def write_content_to_file(file, output)
      File.open(file, "w") { |f| f.puts output  }
    end

    
    def translation_refs_in(file)
      file_content = read_content_of_file(file)
      results = I18n::RubyI18nParser.get_locale_ref_array(file_content)
      write_content_to_file(file, I18n::RubyI18nParser.remove_default(file_content))
      results
    end


    
    def add_translations(trs)
      #puts "TRS: "+translations.inspect
      #puts "TRS: "+trs.inspect
      translations.deep_safe_merge!(trs)
    end

    def translations_in_file(yaml_file)
      open(yaml_file) { |f| YAML.load(f.read) }
    end


    def get_missing_translations(queries, languages)
      languages.each_with_object({}) do |lang, missing|
        get_missing_translations_for_lang(queries, lang).each do |file, queries|
          missing[file] ||= []
          missing[file].concat(queries).uniq!
        end
      end
    end

    def get_missing_translations_for_lang(queries, lang)
      queries.map do |file, queries_in_file|
        queries_with_no_translation = queries_in_file.select { |q| 
          # if(!has_translation?(lang, q)) then
          #   trans = "n"
          # else
          #   trans = "y"
          # end
          #puts "QUERY: "+q.inspect+" --- "+trans
          !has_translation?(lang, q) 
        }
        
        if queries_with_no_translation.empty?
          nil
        else
          [file, queries_with_no_translation.map { |q| [i18n_label(lang, q[0]), q[1]] }]
        end
      end.compact
      #puts "RESULT: "+queries.inspect
      queries
    end


    def has_translation?(lang, query)
      t = translations
      i18n_label(lang, query).split('^').each do |segment|
        return false unless segment =~ /#\{.*\}/ or (t.respond_to?(:key?) and t.key?(segment))
        t = t[segment]
      end
      true
    end

    def i18n_label(lang, query)
      "#{lang}.#{query}"
    end
  end
end

