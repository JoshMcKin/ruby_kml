# The KMLFile class is the top level class for constructing KML files. To create a new KML file
# create a KMLFile instance and add KML objects to its objects. For example:
#
#   f = KMLFile.new
#   f.objects << Placemark.new(
#     :name => 'Simple placemark',
#     :description => 'Attached to the ground. Intelligently places itself at the height of the underlying terrain.',
#     :geometry => Point.new(:coordinates=>'-122.0822035425683,37.42228990140251,0')
#   )
#   puts f.render
class KMLFile
  # The objects in the KML file
  def objects
    @objects ||= []
  end
  alias :features :objects

  # Render the KML file
  def render(xm=Builder::XmlMarkup.new(:indent => 2))
    xm.instruct!
    xm.kml(:xmlns => 'http://earth.google.com/kml/2.1'){
      objects.each { |o| o.render(xm) }
    }
  end

  def save filename
    File.open(filename, 'w') { |f| f.write render }
  end

  # Parse the KML file using nokogiri
  # <kml xmlns="http://www.opengis.net/kml/2.2">
  #   <NetworkLinkControl> ... </NetworkLinkControl>
  #   <!-- 0 or 1 Feature elements -->
  # </kml>
  def self.parse(io)
    kml = self.new
    doc = Nokogiri::XML::Document.parse(io)
    doc.root.element_children.each do |cld|
      case cld.name
      when 'Document'
        kml.features << KML::Document.parse(cld)
      when 'Folder'
      when 'NetworkLink'
      when 'Placemark'
      when 'GroundOverlay'
      when 'PhotoOverlay'
      when 'ScreenOverlay'
      end
    end
    kml
  end

end

require 'kml/object'
