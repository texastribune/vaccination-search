/* global pym, Bloodhound */

(function() {
  'use strict';

  var pymChild, $billSearch;

  function render() {
    var searchDistricts = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('school_district'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      prefetch: {
        url: 'assets/data/districts.json'
      },
      ttl: 3600000 // One hour
    });

    searchDistricts.initialize();

    $billSearch = $('#search').typeahead({
      autoselect: true,
      hint: false,
      highlight: false,
      minLength: 2
      }, {
      name: 'districts',
      displayKey: 'school_district',
      source: searchDistricts.ttAdapter()
    });

    $billSearch.on('typeahead:selected', function(e, datum) {
      e.stopPropagation();
      $('.results-card').addClass('active');
      $('#name').text(datum.school_district);
      $('#county').text(datum.county);
      $('#students_exempting').text(datum.students_exempting);
      $('#percent_students_exempting').text(datum.percent_students_exempting);

      pymChild.sendHeight();
    });

    if (pymChild) {
      pymChild.sendHeight();
    }
  }

  function load() {
    pymChild = new pym.Child({
      renderCallback: render
    });
  }

  window.onload = load;
})();
