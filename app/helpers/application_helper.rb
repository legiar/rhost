module ApplicationHelper
  def jqtable(model, collection, options = {})
    content_tag :table do
      jqtable_header(model, options)
    end
  end
  
  def jqtable_header(model, options)
    model.columns.collect do |column|
      content_tag(:th, column.human_name)
    end
  end
  
end

module JqTable
  
  class HtmlElement
    include ActionView::Helpers::TagHelper
    
    delegate :[], :[]=, :to => '@html_options'
    
    def initialize(html_options = {}) #:nodoc:
      @html_options = html_options.symbolize_keys
    end
    
    def html
      content_tag(tag_name, content, @html_options)
    end
    
    private
      def tag_name
        ''
      end
      
      def content
        ''
      end
  end
end

