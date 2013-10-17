module Base52
    @@keys = ([*0..9,*'a'..'z',*'A'..'Z'] - %w[a e i o u A E I O U]).join
  ENCODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.with_index.to_a.map(&:reverse) ]
  end
  DECODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.with_index.to_a ]
  end
  def self.encode( value)
    ring = ENCODER[@@keys]
    base = @@keys.length
    result = []
    until value == 0
      result << ring[ value % base ]
      value /= base
    end
    result.reverse.join
  end
  def self.decode( string)
    ring = DECODER[@@keys]
    base = @@keys.length
    string.reverse.chars.with_index.inject(0) do |sum,(char,i)|
      sum + ring[char] * base**i
    end
  end
end