module KML #:nodoc:
  # A Folder is used to arrange other Features hierarchically (Folders, Placemarks, NetworkLinks, 
  # or Overlays). A Feature is visible only if it and all its ancestors are visible.
  class Folder < Container
    def render(xm=Builder::XmlMarkup.new(:indent => 2))
      xm.Folder {
        super
        features.each { |f| f.render(xm) }
      }
    end

    def self.parse(node)
      self.new.parse(node)
    end

    def parse(node)
      super(node) do |cld|
        case cld.name
        when 'Stylex'
        when 'Schemax'
        else
          puts "Folder"
          p cld
          puts
        end
      end
    end
  end
end
