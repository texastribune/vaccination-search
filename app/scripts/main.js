/* global pym, Bloodhound */

(function() {
  'use strict';

  var pymChild, $billSearch;

  function render() {
    var $resultsCard = $('.results-card'),
        $texasCard = $('.texas-card'),
        $name = $('#name'),
        $county = $('#county'),
        $studentsExempting = $('#students_exempting'),
        $percentStudentsExempting = $('#percent_students_exempting');

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
      displayKey: function(obj) {
        return obj.school_district + ' (' + obj.county + ')'; 
      },
      source: searchDistricts.ttAdapter()
    });

    $billSearch.on('typeahead:selected', function(e, datum) {
      e.stopPropagation();
      $resultsCard.addClass('active');
      $texasCard.removeClass('active');
      $name.text(datum.school_district);
      $county.text(datum.county);
      $studentsExempting.text(datum.students_exempting);
      $percentStudentsExempting.text(datum.percent_students_exempting);
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
