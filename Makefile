ifndef AWS_BUCKET
$(error The AWS_BUCKET environmental variable is not set)
endif

PROJECT_SLUG := graphics-kit

spreadsheet/authorize:
	@node ./utils/authorize.js

spreadsheet/fetch:
	@node ./utils/fetch_spreadsheet.js

spreadsheet/edit:
	@node ./utils/edit_spreadsheet.js

# Used to pull down assets for this app from the graphics server
sync_assets_to_local:
	aws s3 sync --profile personal s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/raw_assets/ app/assets

deploy:
	@echo "Syncing *.css files to S3..."
	@aws s3 sync --acl public-read --profile personal --exclude '*.*' --include '*.css' --cache-control 'max-age=31536000' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing *.js files to S3..."
	@aws s3 sync --acl public-read --profile personal --exclude '*.*' --include '*.js' --cache-control 'max-age=31536000' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing *.html files to S3..."
	@aws s3 sync --acl public-read --profile personal --exclude '*.*' --include '*.html' --cache-control 'no-cache' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing everything else to S3..."
	@aws s3 sync --profile personal dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing raw assets to S3..."
	@aws s3 sync --delete --profile personal --exclude '.*' app/assets s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/raw_assets/
