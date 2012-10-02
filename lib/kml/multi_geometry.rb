module KML
  class MultiGeometry < Geometry
    def render(xm=Builder::XmlMarkup.new(:indent => 2))
      xm.MultiGeometry { features.each { |f| f.render(xm) } }
    end

    def self.parse(node)
      self.new.parse(node)
    end

    def parse(node)
      super(node) do |cld|
        case cld.name
        when 'Polygon'
          self.features << KML::Polygon.parse(cld)
        else
          puts "MultiGeometry"
          p cld
          puts
        end
      end
      self
    end

  end
end
