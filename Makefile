ifndef AWS_BUCKET
$(error The AWS_BUCKET environmental variable is not set)
endif

PROJECT_SLUG := vaccination-search

spreadsheet/authorize:
	@node ./utils/authorize.js

spreadsheet/fetch:
	@node ./utils/fetch_spreadsheet.js

spreadsheet/edit:
	@node ./utils/edit_spreadsheet.js

# Used to send assets for this app to the graphics server
sync_assets_to_s3:
	aws s3 sync --delete --exclude '.*' app/assets s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/raw_assets/

# Used to pull down assets for this app from the graphics server
sync_assets_from_local:
	aws s3 sync s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/raw_assets/ app/assets

deploy:
	@echo "Syncing *.css files to S3..."
	@aws s3 sync --acl public-read --exclude '*.*' --include '*.css' --cache-control 'max-age=31536000' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing *.js files to S3..."
	@aws s3 sync --acl public-read --exclude '*.*' --include '*.js' --cache-control 'max-age=31536000' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing *.html files to S3..."
	@aws s3 sync --acl public-read --exclude '*.*' --include '*.html' --cache-control 'no-cache' --content-encoding 'gzip' dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing everything else to S3..."
	@aws s3 sync dist s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/

	@echo "Syncing raw assets to S3..."
	@aws s3 sync --delete --exclude '.*' app/assets s3://$(AWS_BUCKET)/graphics/$(PROJECT_SLUG)/raw_assets/
