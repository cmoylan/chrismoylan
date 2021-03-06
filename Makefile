HYDE_CONFIG = production.yaml
#HYDE_CONFIG = site.yaml
MEDIA_DIR = content/media
SITE_DIR = deploy
TO_REMOVE = $(SITE_DIR)/media/sass $(SITE_DIR)/media/.sass-cache
SASS_DIR = $(MEDIA_DIR)/sass
CSS_DIR = $(MEDIA_DIR)/css
SASS=

include deploy.mk


# Default target
all: build

clean:
	rm -rf $(SITE_DIR)

build: clean
	#source hyde_virt_env/bin/activate
	#	./.run_sass --update $(SASS_DIR):$(CSS_DIR)
	sass --update $(SASS_DIR):$(CSS_DIR)
	#./.run_hyde gen -c $(HYDE_CONFIG)
	hyde gen -c $(HYDE_CONFIG)
	rm -rf $(TO_REMOVE)

serve: build
	./.run_hyde serve

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

bootstrap:
	echo "`which sass` \$$*" > .run_sass
	echo "`which hyde` \$$*" > .run_hyde
	chmod +x .run_sass .run_hyde



# Always use the targets defined in this file
.PHONY: clean
