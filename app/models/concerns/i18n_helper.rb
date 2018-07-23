module I18nHelper
  extend self

  def interpolate_key(string)
    string.gsub(I18n::INTERPOLATION_PATTERN).map do |match|
      if match == '%%'
        next
      else
        ($1 || $2 || match.tr('%{}', '')).to_sym
      end
    end
  end

end
