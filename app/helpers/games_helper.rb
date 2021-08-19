module GamesHelper
	def image_exists?(image)
		if Rails.configuration.assets.compile
			Rails.application.precompiled_assets.include? image
		else Rails.application.assets_manifest.assets[image].present?
		end
	end
end
