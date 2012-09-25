module KML
  # A Container is an abstract base class that holds one or more Features and allows the creation of nested hierarchies.
  class Container < Feature

    # Access the features in the container
    attr_accessor :features
    attr_accessor :plain_children

    # Get the features in the container
    def features
      @features ||= []
    end

    def plain_children
      @plain_children ||= []
    end

    def parse(node)
      super(node) do |cld|
        case cld.name
        when 'Document'
          self.features << KML::Document.parse(cld)
        when 'Folder'
          self.features << KML::Folder.parse(cld)
        when 'NetworkLink'
        when 'Placemark'
          self.features << KML::Placemark.parse(cld)
        when 'GroundOverlay'
        when 'PhotoOverlay'
        when 'ScreenOverlay'
        else
          yield cld
        end
      end
      self
    end

  end
end

require 'kml/folder'
require 'kml/document'
