$.ajax('/dropdown/templates.json').success(data => {
    $(".ignore-search").select2({
        sorter(results) {
            const query = $('.select2-search__field').val().toLowerCase();
            return results.sort((a, b) => a.text.toLowerCase().indexOf(query) -
                b.text.toLowerCase().indexOf(query));
        },
        minimumInputLength: 1,
        theme: "bootstrap",
        multiple: true,
        data
    });

    const urlParams = new URLSearchParams(window.location.search);
    const preFilledSearchTerms = urlParams.get("templates").replace(/\s/g, "+").toLowerCase().split(",");
    const validIDs = new Set(data.map(datum => datum.id));
    const validPreFilledSearchTerms = preFilledSearchTerms.filter(term => validIDs.has(term));
    $(".ignore-search").val(validPreFilledSearchTerms).trigger('change.select2');
});


// Delete selecitons by tag instead of individual letter
$.fn.select2.amd.require(['select2/selection/search'], function (Search) {
    Search.prototype.searchRemoveChoice = function (decorated, item) {
        this.trigger('unselect', {
            data: item
        });

        this.$search.val('');
        this.handleSearch();
    };
});

// Highlight input on site load
setTimeout(() => {
    $(".select2-search__field").focus();
}, 100);

// All users to press ctrl+enter to create template
$(".ignore-search").on("select2:selecting", e => {
    setTimeout(() => {
        $(".select2-search__field").keydown(e => {
            if (e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
                generateGitIgnore();
            }
        });
    }, 100);
});

// Generate gitignore template
function generateGitIgnore() {
    const searchString = $(".ignore-search").map(function() {return $(this).val();}).get().join(',');
    const searchLength = searchString.length;
    if (searchLength > 0) {
        const files = searchString.replace(/^,/, '');
        window.location = `/api/${files}`;
        $(".ignore-search").val("");
    }
}

// Generate gitignore file template
function generateGitIgnoreFile() {
    const searchString = $(".ignore-search").map(function() {return $(this).val();}).get().join(',');
    const searchLength = searchString.length;
    if (searchLength > 0) {
        const files = searchString.replace(/^,/, '');
        window.location = `/api/f/${files}`;
    }
}
