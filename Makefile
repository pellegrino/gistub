build: app

JRUBY_VERSION=1.7.3
JRUBY_TARBALL=http://files.int.s-cloud.net/jruby/jruby-bin-$(JRUBY_VERSION).tar.gz
JRUBY_DIR=vendor/jruby-$(JRUBY_VERSION)
JRUBY=$(JRUBY_DIR)/bin/jruby -J-Xmx1024m

GEM=$(JRUBY) -S gem

PATH := $(JRUBY_DIR)/bin:$(PATH)

$(JRUBY):
	mkdir -p $(JRUBY_DIR)
	curl -o $(JRUBY_DIR)/jruby-bin.tar.gz $(JRUBY_TARBALL)
	cd $(JRUBY_DIR) && tar xzf jruby-bin.tar.gz --strip-components=1

BUNDLE_DIR=vendor/bundle
BUNDLER_VERSION=~> 1.2.0
BUNDLER_BIN=$(BUNDLE_DIR)/bin/bundle
BUNDLER=$(JRUBY) -S bundle

GEM_HOME := $(BUNDLE_DIR)

$(BUNDLER_BIN): $(JRUBY)
	$(GEM) install bundler -v "$(BUNDLER_VERSION)" --no-rdoc --no-ri

app: $(BUNDLER_BIN)
	$(BUNDLER) install --deployment --path $(BUNDLE_DIR) --without test development install
	RAILS_ENV=production $(BUNDLER) exec rake db:migrate assets:precompile

test-local: $(BUNDLER_BIN)
	$(BUNDLER) install --no-deployment --path $(BUNDLE_DIR)

test: test-local
	$(BUNDLER) exec rake

clean:
	rm -rf .bundle

mrproper: clean
	rm -rf $(BUNDLE_DIR) $(JRUBY_DIR)
