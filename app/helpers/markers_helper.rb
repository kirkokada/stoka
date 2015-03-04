module MarkersHelper
	def format_caption(comment)
		format_hashtags(comment)
	end

	# Put spaces between hashtags or user mentions and wrap them in <strong> tags

	def format_hashtags(string)
		string.gsub(/([#@]\w+)/, "<strong>\\1</strong>\s").squeeze(' ').gsub(/(\s\z)/, "") 
	end
end
