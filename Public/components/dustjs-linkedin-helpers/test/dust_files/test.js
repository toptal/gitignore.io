(function(){
	dust.register("select",body_0);
  function body_0(chk,ctx){
  	return chk.write("<select style=\"clear: both;width: 230px;\">").section(ctx.get("examples"),ctx,{"block":body_1},null).write("</select>");
  }
	function body_1(chk,ctx){
		return chk.write("<option ").reference(ctx.get("selected"),ctx,"h").write("value=\"").helper("idx",ctx,{"block":body_2},null).write("\">").reference(ctx.get("name"),ctx,"h").write("</option>");
	}
	function body_2(chk,ctx){
		return chk.reference(ctx.getPath(true,[]),ctx,"h");
	}
return body_0;})();
	
jsDump.parsers['function'] = function(fn) { return fn.toString();}

function renderDemo() {
	var tmpl = dust.cache["demo"],
	source = $('#input-context').val();
	$('#output-text').empty();
	if (tmpl && source) {
		setPending('#input-context');
		setPending('#output-text');
		try {
			eval("var context = " + source + ";");
			if (typeof context === 'function') {
				context = context();
			}
			dust.stream("demo", context).on('data', function(data) {
				$('#output-text').append(dust.escapeHtml(data));
			}).on('end', function() {
				setOkay('#input-context');
				setOkay('#output-text');
			}).on('error', function(err) {
				setError('#input-context', err);
			});
		} catch(err) {
			setError('#input-context', err);
		}
	}
}

function setOkay(sel) {
	$(sel).next()
	.removeClass('pending')
	.addClass('ok')
	.html('<i class="icon iconOk"></i> <span>Ready </span>');
}

function setPending(sel) {
	$(sel).next()
	.removeClass('ok')
	.removeClass('error')
	.addClass('pending')
	.html('<i class="icon"></i> <span>Pending </span>');
}

function setError(sel, err) {
	$(sel).next()
	.removeClass('pending')
	.addClass('error')
	.html('<i class="icon iconFail"></i> <span>' + err.toString() + '</span>');
}

function dump(obj) {
	return js_beautify(jsDump.parse(obj), { indent_size: 2 });
}

function renderSelect(examples, defaultTemplate, id) {
	dust.render("select", 
		{
	  	examples: examples,
	  	selected: function(chk, ctx) {
	    	if (ctx.current().name === defaultTemplate) return " selected ";
	  	}
		}, function(err, output) { $('#' + id).html(output); }
	);
}

$(document).ready(function() {
  helpersTests.forEach(function(ex) {
  	ex.tests.forEach(function(test) {
  		if (test.error) {
    		helpersTests.tests.splice(helpersTests.tests.indexOf(test), 1);  
  		} else {
				dust.loadSource(dust.compile(test.source, test.name));
  		}
  	});
	});
  
  renderSelect(helpersTests, "replace", "select-helper")
	
	$('#select-helper > select').change(function() {
		var helperIdx = $(this).val();
		renderSelect(helpersTests[helperIdx].tests, "replace", "select-test")
 
		$('#select-test > select').change(function() {
			var test = helpersTests[helperIdx].tests[$(this).val()];

			$('#input-source').val(test.source);
			$('#input-context').val(dump(test.context));
			$('#input-source').change();
		});
		$('#select-test > select').change();
	});

	$('#input-source').change(function() {
		setPending('#input-source');
		try {
			var compiled = dust.compile($(this).val(), "demo");
			dust.loadSource(compiled);
			$('#output-js').text(js_beautify(compiled, { indent_size: 2 }));
			setOkay('#input-source');
		} catch(err) {
			setError('#input-source', err); return;
		}
	renderDemo();
	});

	$('#input-context').change(renderDemo);
	$('#select-helper > select').change();
});