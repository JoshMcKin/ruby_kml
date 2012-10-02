# Basic XML Structure:
#
#   <Placemark id="ID">
#     <!-- inherited from Feature element -->
#     <name>...</name>                      <!-- string -->
#     <visibility>1</visibility>            <!-- boolean -->
#     <open>1</open>                        <!-- boolean -->
#     <address>...</address>                <!-- string -->
#     <AddressDetails xmlns="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0">...
#         </AddressDetails>                 <!-- string -->
#     <phoneNumber>...</phoneNumber>        <!-- string -->
#     <Snippet maxLines="2">...</Snippet>   <!-- string -->
#     <description>...</description>        <!-- string -->
#     <LookAt>...</LookAt>
#     <TimePrimitive>...</TimePrimitive>
#     <styleUrl>...</styleUrl>              <!-- anyURI -->
#     <StyleSelector>...</StyleSelector>
#     <Region>...</Region>
#     <Metadata>...</Metadata>
#
#     <!-- specific to Placemark element -->
#     <Geometry>...</Geometry>
#   </Placemark>

module KML
  class Placemark < KML::Container
    attr_accessor :geometry

    def render(xm=Builder::XmlMarkup.new(:indent => 2))
      xm.Placemark {
        super
        features.each { |f| f.render(xm) }
        plain_children.each { |c| xm << c }
        geometry.render(xm) unless geometry.nil?
      }
    end

    def self.parse(node)
      self.new.parse(node)
    end

    def parse(node)
      super(node) do |cld|
        case cld.name
        when 'MultiGeometry'
          self.geometry = KML::MultiGeometry.parse(cld)
        when 'Polygon'
          self.geometry = KML::Polygon.parse(cld)
        when 'Point'
          self.geometry = KML::Point.parse(cld)
        else
          puts "Placemark"
          p cld
          puts
        end
      end
      self
    end
  end
end
