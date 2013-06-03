# Source file which generates a Polygon element.
#
# <Polygon id="ID">
#   <!-- specific to Polygon -->
#   <extrude>0</extrude>                       <!-- boolean -->
#   <tessellate>0</tessellate>                 <!-- boolean -->
#   <altitudeMode>clampToGround</altitudeMode> 
#     <!-- kml:altitudeModeEnum: clampToGround, relativeToGround, or absolute -->
#   <outerBoundaryIs>
#     <LinearRing>
#       <coordinates>...</coordinates>         <!-- lon,lat[,alt] -->
#     </LinearRing>
#   </outerBoundaryIs>
#   <innerBoundaryIs>
#     <LinearRing>
#       <coordinates>...</coordinates>         <!-- lon,lat[,alt] -->
#     </LinearRing>
#   </innerBoundaryIs>
#   <innerBoundaryIs>
#     ...
#   </innerBoundaryIs>
# </Polygon>

module KML #:nodoc:
  # A Polygon is defined by an outer boundary and 0 or more inner boundaries. The boundaries, in turn, are defined 
  # by LinearRings. When a Polygon is extruded, its boundaries are connected to the ground to form additional polygons, 
  # which gives the appearance of a building. When a Polygon is extruded, each point is extruded individually. 
  # Extruded Polygons use PolyStyle for their color, color mode, and fill.
  class Polygon < Geometry
    attr_accessor :outer_boundary_is

    def inner_boundary_is
      @inner_boundary_is ||= []
    end

    # allow old semantics for adding inner boundaries
    def inner_boundary_is=(ib)
      if ib.kind_of?(Array)
        @inner_boundary_is = ib
      else
        self.inner_boundary_is << ib
      end
    end

    def render(xm=Builder::XmlMarkup.new(:indent => 2))
      xm.Polygon {
        super
        xm.outerBoundaryIs {
          outer_boundary_is.render(xm)
        }
        inner_boundary_is.each do |ib|
          xm.innerBoundaryIs {
            ib.render(xm)
          }
        end
      }
    end

    def self.parse(node)
      self.new.parse(node)
    end

    def parse(node)
      super(node) do |cld|
        case cld.name
        when 'outerBoundaryIs'
          self.outer_boundary_is = self.parse_boundary(cld)
        when 'innerBoundaryIs'
          self.inner_boundary_is << self.parse_boundary(cld)
        else
          puts "Polygon"
          p cld
          puts
        end
      end
      self
    end

    # should only contain a LinearRing
    def parse_boundary(node)
      ring = nil
      node.element_children.each do |cld|
        case cld.name
        when 'LinearRing'
          ring = KML::LinearRing.parse(cld)
        end
      end
      ring
    end
  end
end
