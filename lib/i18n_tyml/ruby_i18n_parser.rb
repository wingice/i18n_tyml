module I18nTyml
  class RubyI18nParser

    I18N_DEFAULT_PATTERN =     /I18n\.t\(["']([\w\.]*?)["'][^"']*default[^"']*?["']([^"']*?)["']/

    def self.get_locale_ref_array(file_content)
      file_content.scan(I18N_DEFAULT_PATTERN)
    end

    def self.remove_default(file_content)
      file_content.gsub(I18N_DEFAULT_PATTERN, 'I18n.t("\1"')
    end
  end
end

