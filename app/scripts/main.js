/* global pym, Bloodhound */

(function() {
  'use strict';

  var pymChild;

  function render() {
    var searchDistricts = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('school_district'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 10,
      prefetch: {
        url: 'assets/data/districts.json'
      }
      // ttl: 3600000 // One hour
    });

    searchDistricts.initialize();

    var $billSearch = $('#search').typeahead({
      autoselect: true,
      hint: false,
      highlight: false,
      minLength: 3
      }, {
      name: 'districts',
      displayKey: 'school_district',
      source: searchDistricts.ttAdapter()
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
