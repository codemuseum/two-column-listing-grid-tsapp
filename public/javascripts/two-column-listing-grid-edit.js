var TwoColumnListingGridEdit = {
  init: function() {
    this.newGroupCount = 0;
    $$('div.app-two-column-listing-grid').each(function(el) {
      el.getElementsBySelector('.listing a').each(function(listing) { listing.observe('click', function(ev) { ev.stop(); }) }); // Allow the links to be draggable by turning off their behavior
      
      var columnsBox = el.getElementsBySelector('.columns')[0];
      TwoColumnListingGridEdit._observeDrags(columnsBox);

      el.getElementsBySelector('a.new-page').each(function(newPage) { newPage.observe('click', function(ev) { ev.stop(); if (confirm("Are you sure you would like to cancel editing this page and make a new " + newPage.href.substring(newPage.href.indexOf('representing=') + 'representing='.length) + "?")) { document.location = newPage.href; } }) });

      el.ancestors().detect(function(anc) { return anc.tagName == 'FORM' }).observe('submit', function(ev) { TwoColumnListingGridEdit._saveOrder(el); });
      
      el.getElementsBySelector('.datapath a').each(function(a) { a.observe('click', function() {
        el.getElementsBySelector('.datapath .readonly')[0].addClassName('hidden');
        el.getElementsBySelector('.datapath .editable')[0].removeClassName('hidden');
        el.getElementsBySelector('.datapath .editable input')[0].focus();
      }); });
    });
  },
  
  _observeDrags: function(columns) {
    columns.getElementsBySelector('div.column').each(function(c) { 
      Sortable.create(c,
          { containment: columns.getElementsBySelector('div.column').collect(function(div) {return div.id}), 
            dropOnEmpty: true, scroll: window, scrollSensitivity: 40, scrollSpeed: 30, tag:'div', constraint: false});
    });
  },
  
  _saveOrder: function(el) {
    el.getElementsBySelector('.column').each(function(g) {
      urns = g.getElementsBySelector('div.listing').collect(function(l) { 
        return l.classNames().detect(function(c) { return c.startsWith('urn-'); }).substring('urn-'.length);
      });
      g.getElementsBySelector('input.piped-listings-value')[0].value = urns.join('|');
    });
  }
}
TwoColumnListingGridEdit.init();