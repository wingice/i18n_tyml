require 'spec_helper'
require 'i18n_tyml/ruby_i18n_parser'

describe I18nTyml::RubyI18nParser do
  let(:erb_1) { <<-END
    <% provide(:title, "Edit") %>
    <h1><%= I18n.t("companies.edit.edit", :default => "Edit") %></h1>
    
    <div class="row">
        <div class="col-md-8 col-md-offset-2 well">
    	<%= simple_form_for @company do |f| %>
    	    <%= render 'shared/error_messages',:object =>@company %>
    	    <%= f.input :name %> 
    	    <%= f.input :description, :as => :text , input_html: { :rows => 6} %> 
    	    <div>
    		<%= f.submit I18n.t("companies.edit.update_company", :default => 'Update Company'), :class =>'btn btn-primary' %> 
    		<%= link_to I18n.t("common.back", :default => 'Back'), :back, class:'btn btn-default' %>
    	    </div>
    	<% end %>
        </div>
    </div>

  END
  }

  describe "Extract the I18n.t call" do
    it {
      expect(I18nTyml::RubyI18nParser.get_locale_ref_array(erb_1)).to eq [["companies.edit.edit", "Edit"],
                                                                    ["companies.edit.update_company", "Update Company"],
                                                                    ["common.back", "Back"]]
    }
  end
  describe "remove_default" do
    it "should remove default part from I18n.t funcation call" do
      result_str =  <<-END
    <% provide(:title, "Edit") %>
    <h1><%= I18n.t("companies.edit.edit") %></h1>
    
    <div class="row">
        <div class="col-md-8 col-md-offset-2 well">
    	<%= simple_form_for @company do |f| %>
    	    <%= render 'shared/error_messages',:object =>@company %>
    	    <%= f.input :name %> 
    	    <%= f.input :description, :as => :text , input_html: { :rows => 6} %> 
    	    <div>
    		<%= f.submit I18n.t("companies.edit.update_company"), :class =>'btn btn-primary' %> 
    		<%= link_to I18n.t("common.back"), :back, class:'btn btn-default' %>
    	    </div>
    	<% end %>
        </div>
    </div>

  END
      expect(I18nTyml::RubyI18nParser.remove_default(erb_1)).to eq result_str
    end 
  end
end

