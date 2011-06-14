module ApplicationHelper
    
    
    # return a title on a per-page basis.
    def title
        base_title = "The Great War's Essential Booklist"
        if @title.nil?
            base_title
            else
            "#{base_title} | #{@title}"
        end
    end
    
    def logo
        image_tag("logo.jpg", :height => "10%", :width => "10%", :alt => "GWEssentialList", :class => "round" )
    end
    
    def front_page_picture
        image_tag("front_page_picture.jpg", :height => "34%", :width => "34%", :alt => "The Great War Essential Booklist", :class => "round")
    end

end
