require "i18n_tyml/version"
require "i18n_tyml/hash_deep_merge"
require "i18n_tyml/ruby_i18n_parser"

module I18nTyml
  class TranslationManager

    def initialize(options)
      @dest_path = options[:path]
      @remove_default = options[:remove_default]
      @existed_translations = Hash.new
    end

    def search_missing(lang=nil)
      collect_translations

      languages = lang ? [lang] : existed_trans.keys
      get_missing(collect_trans_in_erb(), languages )
    end

    private
    
    def existed_trans
      @existed_translations
    end

    def add_translations(trs)
      existed_trans.deep_safe_merge!(trs)
    end


    def collect_translations
      locales_pathes = ["config/locales/**/*.yml",
                        "vendor/plugins/**/config/locales/**/*yml",
                        "vendor/plugins/**/locale/**/*yml"]
      locales_pathes.each do |path|
        Dir.glob(path) do |file|
          file_content = translations_in_file(file)
          add_translations(file_content) if file_content
        end
      end
    end

    def collect_trans_in_erb
      target_files().each_with_object({}) do |file, trans|
        trs_in_file = translation_refs_in(file)
        if trs_in_file.any?
          trans[file] = trs_in_file
        end
      end
    end

    def target_files
      path = @dest_path
      path = path[0...-1] if path[-1..-1] == '/'
      if File.directory?(path)
        [Dir.glob("#{path}/**/*.erb"), Dir.glob("#{path}/**/*.rb") ].flatten
      else
        [path]
      end
    end

    def read_content_of_file(file)
      File.read(File.expand_path(file))
    end

    def write_content_to_file(file, output)
      File.open(file, "w") { |f| f.puts output  }
    end

    
    def translation_refs_in(file)
      file_content = read_content_of_file(file)
      results = I18nTyml::RubyI18nParser.get_locale_ref_array(file_content)
      write_content_to_file(file, I18nTyml::RubyI18nParser.remove_default(file_content)) if @remove_default
      results
    end

    def add_translations(trs)
      existed_trans.deep_safe_merge!(trs)
    end

    def translations_in_file(yaml_file)
      open(yaml_file) { |f| YAML.load(f.read) }
    end


    def get_missing(trans_in_code, languages)
      languages.each_with_object({}) do |lang, missing|
        get_missing_for_lang(trans_in_code, lang).each do |file, translation_refs|
          missing[file] ||= []
          missing[file].concat(translation_refs).uniq!
        end
      end
    end

    def get_missing_for_lang(trans_in_code, lang)
      trans_in_code.map do |file, trans_with_defaults|
        unmatched = trans_with_defaults.select {|q| has_trans?(lang, q[0]) == false  }
        [file, unmatched.map { |q| [i18n_label(lang, q[0]), q[1]] }] if unmatched.size > 0
      end.compact
    end


    def has_trans?(lang, i18n_key)
      existed_trans[lang].has_nested_key?(i18n_key)
    end

    def i18n_label(lang, query)
      "#{lang}.#{query}"
    end
  end
end

