# retina.js [![Build Status](https://secure.travis-ci.org/imulus/retinajs.png?branch=master)](http://travis-ci.org/imulus/retinajs)

### JavaScript, LESS and SASS helpers for rendering high-resolution image variants

retina.js makes it easy to serve high-resolution images to devices with retina displays

[![Build Status](https://secure.travis-ci.org/imulus/retinajs.png?branch=master)](http://travis-ci.org/imulus/retinajs)

## How it works

When your users load a page, retina.js checks each image on the page to see if there is a high-resolution version of that image on your server. If a high-resolution variant exists, the script will swap in that image in-place.

The script assumes you use Apple's prescribed high-resolution modifier (@2x) to denote high-resolution image variants on your server. It is also possible to override this by manually specifying the URL for the @2x images using `data-at2x` attributes.

For example, if you have an image on your page that looks like this:

```html
<img src="/images/my_image.png" />
```

The script will check your server to see if an alternative image exists at `/images/my_image@2x.png`

However, if you have:

```html
<img src="/images/my_image.png" data-at2x="http://example.com/my_image@2x.png" />
```

The script will use `http://example.com/my_image@2x.png` as the high-resolution image. No checks to the server will be performed.

## How to use

### JavaScript

The JavaScript helper script automatically replaces images on your page with high-resolution variants (if they exist). To use it, download the script and include it at the bottom of your page.

1. Place the retina.js file on your server
2. Include the script on your page (put it at the bottom of your template, before your closing \</body> tag)

``` html
<script type="text/javascript" src="/scripts/retina.js"></script>
```

You can also exlude an image, which has no high-res version. Simple add `data-no-retina`.


``` html
<img src="/path/to/image" data-no-retina />
```

###LESS & SASS

The LESS & SASS CSS mixins are helpers for applying high-resolution background images in your stylesheet. You provide it with an image path and the dimensions of the original-resolution image. The mixin creates a media query specifically for Retina displays, changes the background image for the selector elements to use the high-resolution (@2x) variant and applies a background-size of the original image in order to maintain proper dimensions. To use it, download the mixin, import or include it in your LESS or SASS stylesheet, and apply it to elements of your choice. The SASS versions require you pass the extension separately from the path.

*Syntax:*

``` less
.at2x(@path, [optional] @width: auto, [optional] @height: auto);
```

``` scss
@include at2x($path, [option] $ext: "jpg", [optional] $width: auto, [optional] $height: auto);
```

*Steps:*

1. LESS - Add the .at2x() mixin from retina.less to your LESS stylesheet (or reference it in an @import statement)
SASS - Add the @mixin at2x() from retina.scss or retina.sass to your SASS stylesheet (or reference it in an @import)
2. LESS - In your stylesheet, call the .at2x() mixin anywhere instead of using background-image
SASS - In your stylesheet, call @include at2x() anywhere instead of using background-image

This:

``` less
.logo {
  .at2x('/images/my_image.png', 200px, 100px);
}
```

``` sass
.logo {
  @include at2x('/images/my_image', png, 200px, 100px);
}
```

Will compile to:

``` css
.logo {
  background-image: url('/images/my_image.png');
}

@media all and (-webkit-min-device-pixel-ratio: 1.5) {
  .logo {
    background-image: url('/images/my_image@2x.png');
    background-size: 200px 100px;
  }
}
```

### Ruby on Rails 3.x

...or any framework that embeds some digest/hash to the asset URLs based on the contents, e.g. `/images/image-{hash1}.jpg`.

The problem with this is that the high-resolution version would have a different hash, and would not conform the usual pattern, i.e. `/images/image@2x-{hash2}.jpg`. So automatic detection would fail because retina.js would check the existence of `/images/image-{hash1}@2x.jpg`.

There's no way for retina.js to know beforehand what the high-resolution image's hash would be without some sort of help from the server side. So in this case, the suggested method is to supply the high-resolution URLs using the `data-at2x` attributes as previously described in the How It Works section.

In Rails, one way to automate this is using a helper, e.g.:

```ruby
# in app/helpers/some_helper.rb or app/helpers/application_helper.rb
def image_tag_with_at2x(name_at_1x, options={})
  name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '@2x\0')
  image_tag(name_at_1x, options.merge("data-at2x" => asset_path(name_at_2x)))
end
```

And then in your views (templates), instead of using image_tag, you would use image_tag_with_at2x, e.g. for ERB:

```erb
<%= image_tag_with_at2x "logo.png" %>
```

It would generate something like:

```html
<img src="logo-{hash1}.png" data-at2x="logo@2x-{hash2}.png" />
```

## How to test

We use [mocha](http://visionmedia.github.com/mocha/) for unit testing with [should](https://github.com/visionmedia/should.js) assertions. Install mocha and should by running `npm install`.

To run the test suite:

``` bash
$ npm test
```

Use [http-server](https://github.com/nodeapps/http-server) for node.js to test it. To install, run `npm install -g http-server`.

If you've updated `retina.js` be sure to copy it from `src/retina.js` to `test/functional/public/retina.js`.

To start the server, run:

``` bash
$ cd test/functional && http-server
```

Then navigate your browser to [http://localhost:8080](http://localhost:8080)

After that, open up `test/functional/public/index.html` in your editor, and try commenting out the line that spoofs retina support, and reloading it.
