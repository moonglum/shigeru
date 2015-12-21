require "shigeru/version"
require "uri"

module Shigeru
  class Repository
    def initialize
      @mapping = {}
    end

    def define(name, template)
      @mapping[name] = UriTemplate.new(template)
    end

    def uri_for(name, parameters={})
      @mapping.fetch(name).expand(parameters)
    end
  end

  # Handles a subset of [URI Template](https://tools.ietf.org/html/rfc6570), Level 4
  class UriTemplate
    PATTERN = /{([\?\/]?)([\w,*]+)}/

    def initialize(template)
      terms = template.split(PATTERN)
      parts = ["Proc.new do |params, __o|", "params ||= {}", "__o ||= ''"]
      while (term = terms.shift)
        case term
        when '' then parts.push(expansion('', ',', terms.shift.split(',')))
        when '?' then parts.push(expansion('?', '&', terms.shift.split(',')))
        when '/' then parts.push(expansion('/', '/', terms.shift.split(',')))
        else parts << "__o << '#{term}'"
        end
      end
      parts.push("__o", "end")
      @template = self.instance_eval(parts.join("\n"))
    end

    def expand(parameters)
      @template[parameters]
    end

    private

    def expansion(sigil, seperator, terms)
      result = []

      case sigil
      when '?' then result << "__o << '?'"
      when '/' then result << "__o << '/'"
      end

      while (term = terms.shift)
        if term[-1] == '*'
          result << "__o << params[:#{term[0...-1]}].map do |t|"
          result << "  '#{term[0...-1]}=' +" if sigil == '?'
          result << "  URI.escape(t.to_s)"
          result << "end.join('#{seperator}')"
        else
          result << "__o << '#{term}='" if sigil == '?'
          result << "__o << URI.escape(params[:#{term}].to_s)"
        end
        result << "__o << '#{seperator}'" if terms.any?
      end

      result
    end
  end
end
