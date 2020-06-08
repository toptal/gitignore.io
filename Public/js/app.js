$(function () {

    $.ajax(window.BASE_PREFIX + '/dropdown/templates.json').done(function(data) {
        // bootstrap select2
        $("#input-gitignore").select2({
            data: data,
            theme: "toptal", // customized theme
            multiple: true,
            allowClear: false,
            minimumInputLength: 1,
            placeholder: $("#input-gitignore-placeholder").text(),
            sorter: function(results) {
                const query = $('.select2-search__field').val().toLowerCase();
                return results.sort(function(a, b) {
                    return a.text.toLowerCase().indexOf(query) - b.text.toLowerCase().indexOf(query);
                });
            },
        });

        // load pre-selected tags from URL search params
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get("templates") != null) {
             const preFilledSearchTerms = urlParams.get("templates").replace(/\s/g, "+").toLowerCase().split(",");
            const validIDs = data.map(function(datum) {
                return datum.id
            });
            const validPreFilledSearchTerms = preFilledSearchTerms.filter(function(term) {
                return validIDs.indexOf(term) >= 0;
            });
            $("#input-gitignore").val(validPreFilledSearchTerms).trigger('change.select2');
        } else {
            // in order to fix the problem where placeholder gets cut off
            $("#input-gitignore").val('').trigger('change.select2');
        }

        // Highlight input on site load
        setTimeout(function() {
            $(".select2-search__field").focus();
            // prevent dropdown opening on page load focus
            $("#input-gitignore").on("select2:opening", function (e) {
                e.preventDefault();
                $("#input-gitignore").off("select2:opening");
            });
        });

    });


    // All users to press ctrl+enter to create template
    $("#input-gitignore").on("select2:selecting", function(e) {
        setTimeout(function() {
            $(".select2-search__field").keydown(function(e) {
                if (e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
                    generateGitIgnore();
                }
            });
        });
    });


    // prevent auto sorting of tags selection, keep the order in which they are added
    // @ref https://github.com/select2/select2/issues/3106
    $("#input-gitignore").on('select2:select', function(e) {
        var id = e.params.data.id;
        var option = $(e.target).children('[value="'+id+'"]');
        option.detach();
        $(e.target).append(option).change();
    });


    // bind click handler to "Create" button
    $("#btn-gitignore").click(function() {
        generateGitIgnore()
    });


    // Delete selections by tag instead of individual letter
    $.fn.select2.amd.require(['select2/selection/search'], function (Search) {
        Search.prototype.searchRemoveChoice = function (decorated, item) {
            this.trigger('unselect', {
                data: item
            });

            this.$search.val('');
            this.handleSearch();
        };
    });


    // Generate gitignore template
    function generateGitIgnore() {
        const searchString = $("#input-gitignore").map(function() {return $(this).val();}).get().join(',');
        const searchLength = searchString.length;
        if (searchLength > 0) {
            const files = searchString.replace(/^,/, '');
            window.location = window.BASE_PREFIX + '/api/' + files;
            $("#input-gitignore").val("");
        }
    }


    // Generate gitignore file template
    function generateGitIgnoreFile() {
        const searchString = $("#input-gitignore").map(function() {return $(this).val();}).get().join(',');
        const searchLength = searchString.length;
        if (searchLength > 0) {
            const files = searchString.replace(/^,/, '');
            window.location = window.BASE_PREFIX + '/api/f/' + files;
        }
    }
});

(function setupAnalytics() {
    if (!window.GOOGLE_ANALYTICS_UID) {
        console.error('Google Analytics UID is not set, skipping...');
        return;
    }

    var script = document.createElement('script');
    script.onload = loadAnalytics;
    script.type = 'text/javascript';
    script.src = 'https://www.googletagmanager.com/gtag/js?id=' + window.GOOGLE_ANALYTICS_UID;
    document.getElementsByTagName('head')[0].appendChild(script);

    function loadAnalytics() {
        window.dataLayer = window.dataLayer || [];
        function gtag() {
          dataLayer.push(arguments);
        };
        gtag('js', new Date());
        gtag('config', window.GOOGLE_ANALYTICS_UID, {
            'content_group1': 'Git Ignore',
            'custom_map': { 'dimension10': 'client_id' }
        });
        setTimeout(function() {
          gtag('event', 'read', { 'event_category': '15_seconds' });
        }, 15000);
    }
})();
