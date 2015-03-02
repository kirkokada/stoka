module MarkersHelper
	def format_caption(comment, options={})
		line_width = options[:line_width] || 50
		# Put spaces between hashtags
		comment = format_hashtags(comment)
		# comment = word_wrap(comment, line_width: line_width)
		# simple_format(comment)
	end

	def format_hashtags(string)
		string.gsub(/([#@]\w+)/, "<strong>\\1</strong>\s").squeeze(' ').gsub(/(\s\z)/, "") 
	end
end
