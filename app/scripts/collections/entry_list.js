/*global sinamon, Backbone*/

sinamon.Collections = sinamon.Collections || {};

(function () {
    'use strict';

    sinamon.Collections.EntryList = Backbone.Collection.extend({

        model: sinamon.Models.Entry,
        url: '/entries' 

    });

})();
