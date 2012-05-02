HYDE_CONFIG = production.yaml
MEDIA_DIR = content/media
SITE_DIR = deploy
TO_REMOVE = $(SITE_DIR)/media/sass $(SITE_DIR)/media/.sass-cache
SASS_DIR = $(MEDIA_DIR)/sass
CSS_DIR = $(MEDIA_DIR)/css

include deploy.mk

# Default target
all: build

clean:
	rm -rf $(SITE_DIR)

build: clean
	./.run_sass --update $(SASS_DIR):$(CSS_DIR)
	./.run_hyde gen -c $(HYDE_CONFIG)
	rm -rf $(TO_REMOVE)

package: build
	# minify and compress js and css
	echo "packaging..."

stage: package
	# go to /www/beta
	rsync -arvuz -e "ssh -p $(PORT)" $(SITE_DIR)/ $(HOST):/www/beta/

publish: package
	# go to /www/chrismoylan
	rsync -arvuz -e "ssh -p $(PORT)" $(SITE_DIR)/ $(HOST):/www/chrismoylan/

unstage:
	mkdir temp
	rsync -rv --delete -e "ssh -p $(PORT)" temp/ $(HOST):/www/beta/
	rm -r temp



# Always use the targets defined in this file
.PHONY: clean
