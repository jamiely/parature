class Parature::Util
  def self.force_ascii(str)
    str.to_s.encode Encoding.find("ASCII"), invalid: :replace, undef: :replace, replace: ''
  end
end
