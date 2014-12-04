/*global sinamon, Backbone*/

sinamon.Routers = sinamon.Routers || {};

(function () {
    'use strict';

    sinamon.Routers.AppRouter = Backbone.Router.extend({

        routes: {
            '': 'index'
        },
        initialize: function() {
            // initialize codes
        },
        index: function() {
            var entries = new sinamon.Collections.EntryList();
            new sinamon.Views.EntriesView({el: '#entries', collection: entries});
            entries.fetch({reset: true});
        }

    });

})();
